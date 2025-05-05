//
// Created by yechentide on 2025/05/05
//

#import "DebugLog.h"

void DebugLog(NSString *format, ...) {
#if DEBUG
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    });

    NSString *timestamp = [formatter stringFromDate:[NSDate date]];

    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    NSLog(@"[LvDBWrapper] [%@] %@", timestamp, message);
#endif
}
