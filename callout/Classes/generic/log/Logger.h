
//  BSD License. Author: jano at jano.com.es

#define trace(args...) [[Logger singleton] debugWithLevel:kTrace line:__LINE__ funcName:__PRETTY_FUNCTION__ message:args];
#define debug(args...) [[Logger singleton] debugWithLevel:kDebug line:__LINE__ funcName:__PRETTY_FUNCTION__ message:args];
#define info(args...)  [[Logger singleton] debugWithLevel:kInfo  line:__LINE__ funcName:__PRETTY_FUNCTION__ message:args];
#define warn(args...)  [[Logger singleton] debugWithLevel:kWarn  line:__LINE__ funcName:__PRETTY_FUNCTION__ message:args];
#define error(args...) [[Logger singleton] debugWithLevel:kError line:__LINE__ funcName:__PRETTY_FUNCTION__ message:args];

// replace Magical Record log with Logger "debug"
#define ARLog(args...) [[Logger singleton] debugWithLevel:kDebug line:__LINE__ funcName:__PRETTY_FUNCTION__ message:args];


// Colorized console messages require XCodeColors. 
// See http://deepit.ru/products/XcodeColors/info/

// foreground
#define LCL_BLACK     @"\033[0;30m"
#define LCL_RED       @"\033[0;31m"
#define LCL_GREEN     @"\033[0;32m"
#define LCL_YELLOW    @"\033[0;33m"
#define LCL_BLUE      @"\033[0;34m"
#define LCL_MAGENTA   @"\033[0;35m"
#define LCL_CYAN      @"\033[0;36m"
#define LCL_WHITE     @"\033[0;37m"
// background
#define LBCL_BLACK    @"\033[0;40m"
#define LBCL_RED      @"\033[0;41m"
#define LBCL_GREEN    @"\033[0;42m"
#define LBCL_YELLOW   @"\033[0;43m"
#define LBCL_BLUE     @"\033[0;44m"
#define LBCL_MAGENTA  @"\033[0;45m"
#define LBCL_CYAN     @"\033[0;46m"
#define LBCL_WHITE    @"\033[0;47m"
// reset colors
#define LCL_RESET     @"\033[0m"

/** Logger. */
@interface Logger : NSObject

typedef enum {
    kTrace=0, kDebug=1, kInfo=2, kWarn=3, kError=4, KSilent=5
} LoggerLevel;

// silently ignore logs beyond this level
@property (nonatomic, assign) LoggerLevel logThreshold;
@property (nonatomic, assign, getter=isAsync) BOOL async;
@property (nonatomic, assign, getter=isColorEnabled) BOOL colorEnabled;


+(Logger *)singleton;


-(void) debugWithLevel:(LoggerLevel)level 
                  line:(int)line 
              funcName:(const char *)funcName 
               message:(NSString *)msg, ...; 

@end
