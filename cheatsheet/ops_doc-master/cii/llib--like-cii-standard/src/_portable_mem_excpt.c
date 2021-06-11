#include "portable.h"


#ifdef _WIN32
#else
void* Aligned_malloc(long nbytes, long alignment) {
    void *ptr;
    assert(posix_memalign(&ptr, alignment, nbytes);
    return ptr;
}

void* Aligned_realloc(void* ptr, long nbytes, long alignment) {
    assert(0);
    /*  no posix_memrealloc, should implement it by keeping track of size of block
        associated with ptr */
}

#endif


#ifdef _WIN32

#ifdef NATIVE_EXCEPTIONS

/* from here: http://stackoverflow.com/questions/3523716/is-there-a-function-to-convert-exception-pointers-struct-to-a-string */
/* If we didn't care about being gcc specific, we could use the more elegant https://gist.github.com/raw/4441299/a15d0d5a6c716f4f375ed5ea492b45350eaa6288/stack_traces.c */

/* Compile with /EHa */
#if __GNUC__
#define _WIN32_WINNT    0x0501
#endif

#include <windows.h>
#include <Psapi.h>

static const char* opDescription( const ULONG opcode )
{
    switch( opcode ) {
    case 0: return "read";
    case 1: return "write";
    case 8: return "user-mode data execution prevention (DEP) violation";
    default: return "unknown";
    }
}

static const char* seDescription( const unsigned int code )
{
    switch( code ) {
        case EXCEPTION_ACCESS_VIOLATION:         return "EXCEPTION_ACCESS_VIOLATION"         ;
        case EXCEPTION_ARRAY_BOUNDS_EXCEEDED:    return "EXCEPTION_ARRAY_BOUNDS_EXCEEDED"    ;
        case EXCEPTION_BREAKPOINT:               return "EXCEPTION_BREAKPOINT"               ;
        case EXCEPTION_DATATYPE_MISALIGNMENT:    return "EXCEPTION_DATATYPE_MISALIGNMENT"    ;
        case EXCEPTION_FLT_DENORMAL_OPERAND:     return "EXCEPTION_FLT_DENORMAL_OPERAND"     ;
        case EXCEPTION_FLT_DIVIDE_BY_ZERO:       return "EXCEPTION_FLT_DIVIDE_BY_ZERO"       ;
        case EXCEPTION_FLT_INEXACT_RESULT:       return "EXCEPTION_FLT_INEXACT_RESULT"       ;
        case EXCEPTION_FLT_INVALID_OPERATION:    return "EXCEPTION_FLT_INVALID_OPERATION"    ;
        case EXCEPTION_FLT_OVERFLOW:             return "EXCEPTION_FLT_OVERFLOW"             ;
        case EXCEPTION_FLT_STACK_CHECK:          return "EXCEPTION_FLT_STACK_CHECK"          ;
        case EXCEPTION_FLT_UNDERFLOW:            return "EXCEPTION_FLT_UNDERFLOW"            ;
        case EXCEPTION_ILLEGAL_INSTRUCTION:      return "EXCEPTION_ILLEGAL_INSTRUCTION"      ;
        case EXCEPTION_IN_PAGE_ERROR:            return "EXCEPTION_IN_PAGE_ERROR"            ;
        case EXCEPTION_INT_DIVIDE_BY_ZERO:       return "EXCEPTION_INT_DIVIDE_BY_ZERO"       ;
        case EXCEPTION_INT_OVERFLOW:             return "EXCEPTION_INT_OVERFLOW"             ;
        case EXCEPTION_INVALID_DISPOSITION:      return "EXCEPTION_INVALID_DISPOSITION"      ;
        case EXCEPTION_NONCONTINUABLE_EXCEPTION: return "EXCEPTION_NONCONTINUABLE_EXCEPTION" ;
        case EXCEPTION_PRIV_INSTRUCTION:         return "EXCEPTION_PRIV_INSTRUCTION"         ;
        case EXCEPTION_SINGLE_STEP:              return "EXCEPTION_SINGLE_STEP"              ;
        case EXCEPTION_STACK_OVERFLOW:           return "EXCEPTION_STACK_OVERFLOW"           ;
        default: return "UNKNOWN EXCEPTION" ;
    }
}


LONG(CALLBACK win_exception_handler)(LPEXCEPTION_POINTERS ep) {

    HMODULE hm;
    MODULEINFO mi;
    WCHAR fn[MAX_PATH];
    char message[512];
    unsigned int code;

    code = ep->ExceptionRecord->ExceptionCode;

    GetModuleHandleEx(
        GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS, (LPCTSTR)(ep->ExceptionRecord->ExceptionAddress), &hm );
    GetModuleInformation(GetCurrentProcess(), hm, &mi, sizeof(mi) );
    GetModuleFileNameEx(GetCurrentProcess(), hm, fn, MAX_PATH );

    sprintf(message, "SE %s at address %p inside %s loaded at base address %p\n",
        seDescription(code), ep->ExceptionRecord->ExceptionAddress, fn,
        mi.lpBaseOfDll);

    if(code == EXCEPTION_ACCESS_VIOLATION || code == EXCEPTION_IN_PAGE_ERROR ) {
        sprintf("%sInvalid operation: %s at address %p\n", message,
            opDescription(ep->ExceptionRecord->ExceptionInformation[0]),
            ep->ExceptionRecord->ExceptionInformation[1]);
    }

    if(code == EXCEPTION_IN_PAGE_ERROR) {
        sprintf("%sUnderlying NTSTATUS code that resulted in the exception %i", message,
            ep->ExceptionRecord->ExceptionInformation[2]);
    }

    Native_Exception.reason = message;

    SetUnhandledExceptionFilter(win_exception_handler);

    Except_raise(&Native_Exception, "", 0);
    return 0;
}

void Except_hook_signal() {
    #ifdef _WIN32
    SetUnhandledExceptionFilter(win_exception_handler);
    #endif 

}

#endif /* NATIVE_EXCEPTIONS */

#endif /* _WIN32 */
