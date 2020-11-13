//
// Created by Manfred Bergmann on 14.05.18.
//

#import <Foundation/Foundation.h>

@protocol Appender

- (void)append:(NSString *)message level: Level loggerName:(NSString *)logger functionName:(NSString *)function;
- (NSDateFormatter *)newDateTimeFormatter;

@end

@interface BaseAppender : NSObject <Appender>
@end

@interface ConsoleAppender : BaseAppender
@end
