// ============================================================================
// Copyright (c) 2009-2010 Faustino Frechilla
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//  3. The name of the author may not be used to endorse or promote products
//     derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.
//
/// @file q_blocking_queue_impl.h
/// @brief Implementation of a thread-safe queue based on glib system calls
/// It internally contains a std::queue which is protected from concurrent
/// access by glib mutextes and conditional variables
///
/// @author Faustino Frechilla
/// @history
/// Ref  Who                 When         What
///      Faustino Frechilla 04-May-2009 Original development (based on pthreads)
///      Faustino Frechilla 19-May-2010 Ported to glib. Removed pthread dependency
/// @endhistory
///
// ============================================================================

#ifndef _GBLOCKINGQUEUEIMPL_H_
#define _GBLOCKINGQUEUEIMPL_H_

#include <assert.h>

#define NANOSECONDS_PER_SECOND 1000000000

template <typename T>
BlockingQueue<T>::BlockingQueue(std::size_t a_maxSize) :
    m_maximumSize(a_maxSize)
{
    if (!g_thread_supported ())
    {
        // glib thread system hasn't been initialized yet
        g_thread_init(NULL);
    }

    m_mutex = g_mutex_new();
    m_cond  = g_cond_new();

    assert(m_mutex != NULL);
    assert(m_cond != NULL);
}

template <typename T>
BlockingQueue<T>::~BlockingQueue()
{
    g_cond_free(m_cond);
    g_mutex_free(m_mutex);
}

template <typename T>
bool BlockingQueue<T>::IsEmpty()
{
    bool rv;

    g_mutex_lock(m_mutex);
    rv = m_theQueue.empty();
    g_mutex_unlock(m_mutex);

    return rv;
}

template <typename T>
bool BlockingQueue<T>::Push(const T &a_elem)
{
    g_mutex_lock(m_mutex);

    while (m_theQueue.size() >= m_maximumSize)
    {
        g_cond_wait(m_cond, m_mutex);
    }

    bool queueEmpty = m_theQueue.empty();

    m_theQueue.push(a_elem);

    if (queueEmpty)
    {
        // wake up threads waiting for stuff
        g_cond_broadcast(m_cond);
    }

    g_mutex_unlock(m_mutex);

    return true;
}

template <typename T>
bool BlockingQueue<T>::TryPush(const T &a_elem)
{
    g_mutex_lock(m_mutex);

    bool rv = false;
    bool queueEmpty = m_theQueue.empty();

    if (m_theQueue.size() < m_maximumSize)
    {
        m_theQueue.push(a_elem);
        rv = true;
    }

    if (queueEmpty)
    {
        // wake up threads waiting for stuff
        g_cond_broadcast(m_cond);
    }

    g_mutex_unlock(m_mutex);

    return rv;
}

template <typename T>
void BlockingQueue<T>::Pop(T &out_data)
{
    g_mutex_lock(m_mutex);

    while (m_theQueue.empty())
    {
        g_cond_wait(m_cond, m_mutex);
    }

    bool queueFull = (m_theQueue.size() >= m_maximumSize) ? true : false;

    out_data = m_theQueue.front();
    m_theQueue.pop();

    if (queueFull)
    {
        // wake up threads waiting for stuff
        g_cond_broadcast(m_cond);
    }

    g_mutex_unlock(m_mutex);
}

template <typename T>
bool BlockingQueue<T>::TryPop(T &out_data)
{
    g_mutex_lock(m_mutex);

    bool rv = false;
    if (!m_theQueue.empty())
    {
        bool queueFull = (m_theQueue.size() >= m_maximumSize) ? true : false;

        out_data = m_theQueue.front();
        m_theQueue.pop();

        if (queueFull)
        {
            // wake up threads waiting for stuff
            g_cond_broadcast(m_cond);
        }

        rv = true;
    }

    g_mutex_unlock(m_mutex);

    return rv;
}

template <typename T>
bool BlockingQueue<T>::TimedWaitPop(T &data, glong microsecs)
{
    g_mutex_lock(m_mutex);

    // adding microsecs to now
    GTimeVal abs_time;
    g_get_current_time(&abs_time);
    g_time_val_add(&abs_time, microsecs);

    gboolean retcode = TRUE;
    while (m_theQueue.empty() && (retcode != FALSE))
    {
        // Returns TRUE if cond was signalled, or FALSE on timeout
        retcode = g_cond_timed_wait(m_cond, m_mutex, &abs_time);
    }

    bool rv = false;
    bool queueFull = (m_theQueue.size() >= m_maximumSize) ? true : false;
    if (retcode != FALSE)
    {
        data = m_theQueue.front();
        m_theQueue.pop();

        rv = true;
    }

    if (rv && queueFull)
    {
        // wake up threads waiting for stuff
        g_cond_broadcast(m_cond);
    }

    g_mutex_unlock(m_mutex);

    return rv;
}

#endif /* _GBLOCKINGQUEUEIMPL_H_ */
