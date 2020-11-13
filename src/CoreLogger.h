/*
 *  CoreLogger.h
 *  CocoLogger
 *
 *  Created by Manfred Bergmann on 01.12.06.
 *  Copyright 2006 __MyCompanyName__. All rights reserved.
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <syslog.h>
#include <stdarg.h>
#include <errno.h>
#include <sys/stat.h>

#define TRUE 1
#define FALSE 0

typedef enum {
	LEVEL_OFF = 1,
	LEVEL_CRIT,
	LEVEL_ERR,
	LEVEL_WARN,
	LEVEL_INFO,
	LEVEL_DEBUG
}LoggingLevel;


/**
\brief initialize the logger
 
 @param[in] logPath specify the path to where the outputgoes
 @param[in] aPrefix specify a log prefix e.g. the AppName
 @param[in] aLevel specify the log filter level to which the logger should be set to, can be changed with setLogFilterLevel:
 @param[in] fileAppend each time create a new file? YES or NO
 @param[in] consoleLogging specify if additionally the logging should go to the console
 */
int initLogger(const char *logPath, const char *aPrefix, LoggingLevel aLevel, char fileAppend, char consoleLogging);

/**
\brief close the logger
 */
int closeLogger();

/**
\brief Set the logging filter level
 @param aLevel
 */
void setLogFilterLevel(LoggingLevel aLevel);

/**
\brief Get the current log filter level
 */
LoggingLevel getLogFilterLevel();

/**
\brief Set the log prefix
 @param aPrefix
 */
void setLogPrefix(const char *aPrefix);

/**
\brief Get the log prefix
 */
const char *getLogPrefix();

/**
\brief Log a message to file and/or console
 @param message the logging message
 @param aLevel the level of this message
 @returns error status code != 0
 */
int corelog(const char *message, LoggingLevel aLevel);
