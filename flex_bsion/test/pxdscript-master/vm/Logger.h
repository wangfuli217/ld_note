#ifndef LOGGER_H
#define LOGGER_H


// --** Includes: **---------------------------------------------------
#include <stdio.h>

// --** Defines: **----------------------------------------------------
#define DEFAULT_LOG_FILENAME "log.txt"
#define MAX_LOG_ENTRY_SIZE 256

// --** Externals: **--------------------------------------------------
// Globale log object
class Logger;
extern Logger *logger;

// --** Classes: **----------------------------------------------------

class Logger {
protected:
	FILE *f;
	char *filename;
	bool valid;
	
public:
	Logger(const char *fname=DEFAULT_LOG_FILENAME);
	~Logger();
	bool isValid() const;
	
	void log(const char *format, ...) const;
	void logLn(const char *format, ...) const;
	void newline() const;
};


// --** Static Methods: **---------------------------------------------
// Convenience functions using the global log object
void Log(char const *format, ...);
void LogNoLn(char const *format, ...);

#endif
