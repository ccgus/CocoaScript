#import <Cocoa/Cocoa.h>
#import "COSListener.h"
#import "COScript.h"

BOOL JSCErrorHandlerExitOnError = YES;

@interface JSCErrorHandler : NSObject {
    
}
@end

@implementation JSCErrorHandler

- (void)JSTalk:(COScript*)jstalk hadError:(NSString*)error onLineNumber:(NSInteger)lineNumber atSourceURL:(id)url {
    
    printf("Error line %d, %s\n", (int)lineNumber, [[error description] UTF8String]);
    
    if (JSCErrorHandlerExitOnError) {
        exit(1);
    }
}


@end


void runREPL(COScript *t) {
    
    // thanks http://tlrobinson.net/blog/2008/10/10/command-line-interpreter-and-repl-for-jscocoa/ !
    
    JSCErrorHandlerExitOnError = NO;
    
    while (1) {
        char buffer[1024];
        
        printf("js> ");
        
        if (fgets(buffer, 1024, stdin) == NULL) {
            exit(0);
        }
        
        NSString *s = [[NSString alloc] initWithUTF8String:buffer];
        
        id o = [t executeString:s];
        
        if (o) {
            printf("%s\n", [[o description] UTF8String]);
        }
    
    }
    
    
}


int main(int argc, char *argv[]) {
    
    COScript *t = [[COScript alloc] init];
    
    [t setErrorController:[[JSCErrorHandler alloc] init]];
    
    if (argc < 2) {
        runREPL(t);
        exit(0);
    }
    
    
    NSString *source = nil;
    NSString *arg = [NSString stringWithUTF8String:argv[1]];
    
    if ([arg isEqualToString:@"-e"] && argc == 3) {
        source = [NSString stringWithUTF8String:argv[2]];
    }
    else {
        source = [NSString stringWithContentsOfFile:arg encoding:NSUTF8StringEncoding error:nil];
    }
    
    
    if (!source) {
        printf("usage: %s <path to file>\n", argv[0]);
        exit(0);
    }
    
    [t.env setObject:[NSURL fileURLWithPath:arg] forKey:@"scriptURL"];
    
    if ([source hasPrefix:@"#!"]) {
        
        NSRange r = [source rangeOfString:@"\n"];
        
        if (r.location != NSNotFound) {
            source = [source substringFromIndex:r.location];
        }
    }
    
    id o = [t executeString:source];
    
    if (o) {
        printf("%s\n", [[o description] UTF8String]);
    }
    
    return 0;
}
