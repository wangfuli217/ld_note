/* Copyright (C) 2017, kylinsage <kylinsage@gmail.com>
 *
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 * ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#ifndef EXCEPTION_H
#define EXCEPTION_H

#include <stdlib.h>
#include <setjmp.h>

#define RETHROWABLE (_rethrowable_ || \
    (!_rethrowable_ && pop_jmp() && (_rethrowable_ = 1)))

#define try \
    int _index = push_jmp(); \
    int _except_code_ = setjmp(jmpStack.buf[_index]); \
    volatile int _rethrowable_ = 0; \
    if (_except_code_ == 0)

#define catch(e) \
    else if(_except_code_ && RETHROWABLE)

#define finally \
    else if(RETHROWABLE)

#define throw(e) \
    if(jmpStack.count > 0) longjmp(jmpStack.buf[jmpStack.count - 1], e)

struct JmpStack {
    jmp_buf *buf;
    unsigned int count;
};

extern struct JmpStack jmpStack;

static inline int push_jmp(void)
{
    jmpStack.buf =
        realloc(jmpStack.buf, sizeof(jmp_buf) * (jmpStack.count + 1));
    return jmpStack.count++;
}

static inline int pop_jmp(void)
{
    if (jmpStack.count > 0)
        jmpStack.buf =
            realloc(jmpStack.buf, sizeof(jmp_buf) * (--jmpStack.count));
    return 1;
}

#endif /* EXCEPTION_H */
