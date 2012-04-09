
//  BSD License. Author: jano at jano.com.es

#import "Logger.h"

@implementation Logger

@synthesize logThreshold, async, colorEnabled;


+(Logger *)singleton {
    // Mike Ash "Care and Feeding of Singletons"
    static dispatch_once_t pred;
    static Logger *shared = nil;
    dispatch_once(&pred, ^{
        shared = [[Logger alloc] init];
        shared.logThreshold = kTrace;
        shared.async = FALSE;
        shared.colorEnabled = FALSE; // requires XCodeColors
    });
    return shared;
}


-(void) debugWithLevel:(LoggerLevel)level 
                  line:(int)line 
              funcName:(const char *)funcName 
               message:(NSString *)msg, ... {
    
    const char* const levelName[6] = { "TRACE", "DEBUG", " INFO", " WARN", "ERROR", "SILENT" };
    
    va_list ap;         // define variable ap of type va
    va_start (ap, msg); // initializes ap
	msg = [[NSString alloc] initWithFormat:msg arguments:ap];
    va_end (ap);        // invalidates ap

    BOOL skipClassInfo = FALSE; // should we add class info?
    BOOL useWhiteBg = FALSE;    // should we ignore color and use white bg + black fg?
    {
        // Process format characters at the beginning of the string:
        //   - The ` character means skip class/method/line info.
        //   - The > character means use white bg + black fg.
        NSCharacterSet *format = [NSCharacterSet characterSetWithCharactersInString:@"`>"];
        int i = 0;
        for (; i<[msg length]; i++) {
            unichar character = [msg characterAtIndex:i];
            if (![format characterIsMember:character]) break;
            switch (character) {
                case '`':
                    skipClassInfo = TRUE;
                    break;
                case '>':
                    useWhiteBg = TRUE;
                default:
                    break;
            }
        }
        if (i>0) msg = [msg substringFromIndex:i];
    }
    
    // Remove user's \n at beginning and end. I'll handle the \n thank you.
    msg = [msg stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\n"]];
    
    if (level>=logThreshold){

        if ([self isColorEnabled]){
            // If we started the string with a '>' character ignore 
            // the color from the log level and do white bg & black fg.
            if (useWhiteBg){
                msg = [NSString stringWithFormat:@"%@%@%@%@", LBCL_WHITE,LCL_BLACK,msg,LCL_RESET];
            } else {
                if (level==kTrace){
                } else if (level==kDebug){
                } else if (level==kInfo){
                    msg = [NSString stringWithFormat:@"%@%@%@", LCL_GREEN,msg,LCL_RESET];
                } else if (level==kWarn){
                    msg = [NSString stringWithFormat:@"%@%@%@", LCL_YELLOW,msg,LCL_RESET];
                } else if (level==kError){
                    msg = [NSString stringWithFormat:@"%@%@%@", LCL_RED,msg,LCL_RESET];
                }
            }
        }

        // if we didn't start the message with ` then add class/method/line        
        if (!skipClassInfo){
            msg = [NSString stringWithFormat:@"%s %50s:%3d - %@", levelName[level], funcName, line, msg];
        }
        
        if ([self isAsync]){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    fprintf(stdout,"%s\n", [msg UTF8String]);
                });
            });
        } else {
            fprintf(stdout,"%s\n", [msg UTF8String]);            
        }
        
    }
}


@end


