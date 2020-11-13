/*
 *  CoreLogger.c
 *  CocoLogger
 *
 *  Created by Manfred Bergmann on 01.12.06.
 *  Copyright 2006 Software by MABE. All rights reserved.
 *
 */

#include "CoreLogger.h"
#include "time.h"

// some static variables
static FILE *cFHandle = NULL;
static LoggingLevel logFilterLevel = LEVEL_WARN;
static char *logPrefix = NULL;
static char logToConsole = TRUE;

/*
void Log(LoggingLevel level, const char *fmt, ...) {
	char *p;
	va_list ap;
	if((p = malloc(8192)) == NULL) {
		return;
	}
	va_start(ap, fmt);
	(void) vsnprintf(p, 8192, fmt, ap);
	va_end(ap);

	clog(p, level);
}
*/
 
/**
\brief initialize the logger
 
 @param[in] logPath specify the path to where the output goes
 @param[in] aPrefix specify a log prefix e.g. the AppName
 @param[in] aLevel specify the log filter level to which the logger should be set to, can be changed with setLogFilterLevel:
 @param[in] fileAppend each time create a new file? YES or NO
 @param[in] consoleLogging specify if additionally the logging should go to the console
 */
int initLogger(const char *logPath, const char *aPrefix, LoggingLevel aLevel, char fileAppend, char consoleLogging) {
	int ret = 0;
	
	setLogPrefix(aPrefix);
	logFilterLevel = aLevel;
	logToConsole = consoleLogging;
	
	// check, if we have a path
	if(logPath != NULL) {
		// check, if this file exists
		struct stat sb;
		int result = stat(logPath, &sb);
		if(result != ENOENT) {
			if(fileAppend == FALSE) {
				// if the file exists and we do not append, then we have to delete the file
				result = remove(logPath);
				if(result < 0) {
					// we could not delete the file, but we go on appending to this file
					printf("Could not delete file at %s, but proceeding anyway!",logPath);					
					syslog(LOG_ERR,"Could not delete file at %s, but proceeding anyway!",logPath); 
				}
			}			
		}
		
		// do it the c way
		cFHandle = fopen(logPath,"a+");
		if(cFHandle == NULL) {
			// an error has occured
			printf("Cannot get cfilehandle from %s!", logPath);			
			syslog(LOG_ERR,"Cannot get cfilehandle from %s!", logPath); 
			
			ret = -1;			
		}
	}
	
	return ret;
}

int closeLogger() {
	int ret = 0;

	setLogPrefix(NULL);
	
	if(cFHandle != NULL) {
		ret = fclose(cFHandle);
	}
	
	return ret;
}

/**
\brief Set the logging filter level
 @param aLevel
 */
void setLogFilterLevel(LoggingLevel aLevel) {
	logFilterLevel = aLevel;
}

/**
\brief Get the current log filter level
 */
LoggingLevel getLogFilterLevel() {
	return logFilterLevel;
}

/**
\brief Set the log prefix
 @param aPrefix
 */
void setLogPrefix(const char *aPrefix) {
	if(logPrefix != NULL) {
		free(logPrefix);
	}
	
	if(aPrefix != NULL) {
		logPrefix = (char *)malloc(strlen(aPrefix) + 1);
		strcpy(&logPrefix[0], &aPrefix[0]);	
	}
}

/**
\brief Get the log prefix
 */
const char *getLogPrefix() {
	return logPrefix;
}

/**
\brief Log a message to file and/or console
 @param message the logging message
 @param aLevel the level of this message
 @returns error status code != 0
 */
int corelog(const char *message, LoggingLevel aLevel) {
	int ret = 0;
	
	// check for error or unposible setting
	if(cFHandle == NULL) {
		if(logToConsole == FALSE) {
			printf("[CoreLogger] Have no open file handle and console logging is disabled!");
			syslog(LOG_ERR,"[CoreLogger] Have no open file handle and console logging is disabled!");
			
			return -1;
		}
	}
	
	if(message != NULL) {
		if(aLevel <= logFilterLevel) {
			// add log level
			char *level = NULL;
			switch(aLevel) {
				case LEVEL_CRIT:
					level = "CRIT\0";
					break;
				case LEVEL_ERR:
					level = "ERR\0";
					break;
				case LEVEL_WARN:
					level = "WARN\0";
					break;
				case LEVEL_INFO:
					level = "INFO\0";
					break;
				case LEVEL_DEBUG:
					level = "DEBUG\0";
					break;
                case LEVEL_OFF:
                    return ret;
			}
			
			// insert prefix
			if(logPrefix == NULL) {
				setLogPrefix("");
			}
			
			// build log str
			char *printString = (char *)malloc(1024);
			const time_t timeVal = time(NULL);
			char *timeString = ctime(&timeVal);
			// remove the newline of timeString
			timeString[strlen(timeString) - 1] = '\0';
			snprintf(printString, 1024, "%s %s %s %s\n",
				timeString,
				level,
				logPrefix,
				message);
			
			// check if cFHandle is not nil
			if(cFHandle != NULL) {
				fprintf(cFHandle,"%s", printString);
				fflush(cFHandle);
			}
			
			// log to console as well if we have to
			if(logToConsole == TRUE) {
				fprintf(stdout,"%s", printString);
				fflush(stdout);
			}
			
			if(printString != NULL) {
				free(printString);
			}
		}
	}
	
	return ret;
}
