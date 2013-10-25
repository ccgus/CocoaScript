//
//  TDParseKitState.m
//  TDParseKit
//
//  Created by Todd Ditchendorf on 1/20/06.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import "TDTokenizerState.h"

@interface TDTokenizerState ()
- (void)reset;
- (void)append:(NSInteger)c;
- (void)appendString:(NSString *)s;
- (NSString *)bufferedString;

#if TD_USE_MUTABLE_STRING_BUF
@property (nonatomic, retain) NSMutableString *stringbuf;
#else
- (void)checkBufLength;
- (unichar *)mallocCharbuf:(NSUInteger)size;
#endif
@end

@implementation TDTokenizerState

- (void)dealloc {
#if TD_USE_MUTABLE_STRING_BUF
    self.stringbuf = nil;
#else
    if (charbuf && ![[NSGarbageCollector defaultCollector] isEnabled]) {
        free(charbuf);
        charbuf = NULL;
    }
#endif
    [super dealloc];
}


- (TDToken *)nextTokenFromReader:(TDReader *)r startingWith:(NSInteger)cin tokenizer:(TDTokenizer *)t {
    NSAssert(0, @"TDTokenizerState is an Abstract Classs. nextTokenFromStream:at:tokenizer: must be overriden");
    return nil;
}


- (void)reset {
#if TD_USE_MUTABLE_STRING_BUF
    self.stringbuf = [NSMutableString string];
#else
    if (charbuf && ![[NSGarbageCollector defaultCollector] isEnabled]) {
        free(charbuf);
        charbuf = NULL;
    }
    index = 0;
    length = 16;
    charbuf = [self mallocCharbuf:length];
#endif
}


- (void)append:(NSInteger)c {
#if TD_USE_MUTABLE_STRING_BUF
    [stringbuf appendFormat:@"%C", (unsigned short)c];
#else 
    [self checkBufLength];
    charbuf[index++] = c;
#endif
}


- (void)appendString:(NSString *)s {
#if TD_USE_MUTABLE_STRING_BUF
    [stringbuf appendString:s];
#else 
    // TODO
    NSAssert1(0, @"-[TDTokenizerState %s] not impl for charbuf", _cmd);
#endif
}


- (NSString *)bufferedString {
#if TD_USE_MUTABLE_STRING_BUF
    return [[stringbuf copy] autorelease];
#else
    return [[[NSString alloc] initWithCharacters:(const unichar *)charbuf length:index] autorelease];
//    return [[[NSString alloc] initWithBytes:charbuf length:index encoding:NSUTF8StringEncoding] autorelease];
#endif
}


#if TD_USE_MUTABLE_STRING_BUF
#else
- (void)checkBufLength {
    if (index >= length) {
        unichar *nb = [self mallocCharbuf:length * 2];
        
        NSInteger j = 0;
        for ( ; j < length; j++) {
            nb[j] = charbuf[j];
        }
        if (![[NSGarbageCollector defaultCollector] isEnabled]) {
            free(charbuf);
            charbuf = NULL;
        }
        charbuf = nb;
        
        length = length * 2;
    }
}


- (unichar *)mallocCharbuf:(NSUInteger)size {
    unichar *result = NULL;
    if ((result = (unichar *)NSAllocateCollectable(size, 0)) == NULL) {
        [NSException raise:@"Out of memory" format:nil];
    }
    return result;
}
#endif

#if TD_USE_MUTABLE_STRING_BUF
@synthesize stringbuf;
#endif
@end
