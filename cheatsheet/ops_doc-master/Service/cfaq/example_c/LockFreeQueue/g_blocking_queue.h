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
/// @file q_blocking_queue.h
/// @brief Definition of a thread-safe queue based on glib system calls
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

#ifndef _GBLOCKINGQUEUE_H_
#define _GBLOCKINGQUEUE_H_

#include <glib.h>
#include <queue>
#include <limits> // std::numeric_limits<>::max

#define BLOCKING_QUEUE_DEFAULT_MAX_SIZE std::numeric_limits<std::size_t >::max()

/// @brief blocking thread-safe queue
/// It uses a mutex+condition variables to protect the internal queue
/// implementation. Inserting or reading elements use the same mutex
template <typename T>
class BlockingQueue
{
public:
    BlockingQueue(std::size_t a_maxSize = BLOCKING_QUEUE_DEFAULT_MAX_SIZE);
    ~BlockingQueue();

    /// @brief Check if the queue is empty
    /// This call can block if another thread owns the lock that protects the
    /// queue
    /// @return true if the queue is empty. False otherwise
    bool IsEmpty();

    /// @brief inserts an element into queue queue
    /// This call can block if another thread owns the lock that protects the
    /// queue. If the queue is full The thread will be blocked in this queue
    /// until someone else gets an element from the queue
    /// @param element to insert into the queue
    /// @return True if the elem was successfully inserted into the queue.
    ///         False otherwise
    bool Push(const T &a_elem);

    /// @brief inserts an element into queue queue
    /// This call can block if another thread owns the lock that protects the
    /// queue. If the queue is full The call will return false and the element
    /// won't be inserted
    /// @param element to insert into the queue
    /// @return True if the elem was successfully inserted into the queue.
    ///         False otherwise
    bool TryPush(const T &a_elem);

    /// @brief extracts an element from the queue (and deletes it from the q)
    /// If the queue is empty this call will block the thread until there is
    /// something in the queue to be extracted
    /// @param a reference where the element from the queue will be saved to
    void Pop(T &out_data);

    /// @brief extracts an element from the queue (and deletes it from the q)
    /// This call gets the block that protects the queue. It will extract the
    /// element from the queue only if there are elements in it
    /// @param reference to the variable where the result will be saved
    /// @return True if the element was retrieved from the queue.
    ///         False if the queue was empty
    bool TryPop(T &out_data);

    /// @brief extracts an element from the queue (and deletes it from the q)
    /// If the queue is empty this call will block the thread until there
    /// is something in the queue to be extracted or until the timer
    /// (2nd parameter) expires
    /// @param reference to the variable where the result will be saved
    /// @param microsecondsto wait before returning if the queue was empty
    /// @return True if the element was retrieved from the queue.
    ///         False if the timeout was reached
    bool TimedWaitPop(T &data, glong microsecs);

protected:
    std::queue<T> m_theQueue;
    /// maximum number of elements for the queue
    std::size_t m_maximumSize;
    /// Mutex to protect the queue
    GMutex* m_mutex;
    /// Conditional variable to wake up threads
    GCond*  m_cond;
};

// include the implementation file
#include "g_blocking_queue_impl.h"

#endif /* _GBLOCKINGQUEUE_H_ */
