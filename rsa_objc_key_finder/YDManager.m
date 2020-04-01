#import "YDManager.h"

@implementation YDManager : NSObject

- (BOOL)preCheck: (int)args {

    if (args != 2){
        [YDPrettyConsole multiple:@"Usage: enter N value. You entered %d argument(s)", args];
        return FALSE;
    }
    
    return TRUE;
}

- (instancetype) init: (int)argCount{
    self = [super init];
    if (self) {
       
        startTime = [NSDate date];
        [YDPrettyConsole multiple:@"Started\t%@", [YDManager prettyDate:startTime]];
        [YDPrettyConsole multiple:@"Kill Timer\t%d", KILLTIMER];
        if([self preCheck: argCount] == FALSE){
            return NULL;
        }
        [self setNotification];
    }

    return self;
}


+ (NSString *)prettyDate: (NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"HH:mm:ss:mm"];
    return [dateFormat stringFromDate:date];
}

- (void) setNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:@"FactorizationCompleted" object:nil queue:nil usingBlock:^(NSNotification *note)
     {
         [self receiveNotification:note];
     }];
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ProgressBarFinished" object:NULL queue:NULL usingBlock:^(NSNotification *prettyConsole)
     {
         [self receiveNotification:prettyConsole];
     }];
}


-(void) receiveNotification:(NSNotification*)notification
{
    if ([notification.name isEqualToString:@"FactorizationCompleted"])
    {
        endTime = [NSDate date];
    }
    if ([notification.name isEqualToString:@"ProgressBarFinished"])
    {
        [self cleanExit];
    }
}

- (void)cleanExit
{
    [YDPrettyConsole multiple:@"Finished in: %.2f seconds", [endTime timeIntervalSinceDate:startTime]];
}

+ (void)dirtyExit
{
    [YDPrettyConsole single:@"Error in setup"];
}
@end