// --** Includes: **---------------------------------------------------
#include "string.h"
#include "stdarg.h"
#include "Logger.h"

// --** Globals: **----------------------------------------------------
Logger *logger = NULL;

// --** Static Methods: **---------------------------------------------
Logger::Logger(const char *fname) {
  // Initialize members:
  valid = false;
  f = NULL;
  filename = NULL;
  
  // Get filename:
  if(fname==NULL) {
    filename = strdup(DEFAULT_LOG_FILENAME);
  }   
  else {
    filename = strdup(fname);
    // strdup can fail:
    if(filename == NULL)
      return;
  }
        
  // Open file:
  f = fopen(filename,"wt");
  if (f == NULL) {
    delete filename;
    return;
  }
        
  // Disable buffering: (else data may be lost in a crash)
  setbuf(f, NULL);
        
  // Mark object as valid:
  valid = true;
  logLn("--** Started logging **-------------------------------------");
}

Logger::~Logger() {
  if (valid) {
    logLn("--** Ended Logging **---------------------------------------");
    
    if (f != NULL)
      fclose(f);
    
    delete[] filename;
  }
}

bool Logger::isValid() const {
  return valid;
}

void Logger::log(const char *format, ...) const {
  if (valid) {

    char buffer[MAX_LOG_ENTRY_SIZE+1];
    va_list errmsg;
                
    va_start (errmsg, format);
    vsprintf (buffer, format, errmsg);
    va_end (errmsg);
                
    fprintf(f,"%s",buffer);
  }
}

void Logger::logLn(const char *format, ...) const {
  if (valid) {
    char buffer[MAX_LOG_ENTRY_SIZE+1];
    va_list errmsg;
                
    va_start (errmsg, format);
    vsprintf (buffer, format, errmsg);
    va_end (errmsg);
                
    fprintf(f,"%s\n",buffer);
  }
}

void Logger::newline() const {
  if (valid) {
    fprintf(f,"\n");
  }
}

// Convenience functions
void Log(char const *format, ...) {
  if(logger!=NULL) {
      
		static char buffer[256];
		va_list errmsg;
      
		va_start (errmsg, format);
		vsprintf (buffer, format, errmsg);
		va_end (errmsg);
      
		logger->logLn("%s",buffer);
	}
}

void LogNoLn(char const *format, ...) {
	if(logger!=NULL) {
                   
		static char buffer[256];
		va_list errmsg;
		
		va_start (errmsg, format);
		vsprintf (buffer, format, errmsg);
		va_end (errmsg);
		
		logger->log("%s",buffer);
	}
}

