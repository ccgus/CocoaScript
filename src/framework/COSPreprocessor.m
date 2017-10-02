//
//  JSTPreprocessor.m
//  jstalk
//
//  Created by August Mueller on 2/14/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import "COSPreprocessor.h"
#import "TDTokenizer.h"
#import "TDToken.h"
#import "TDWhitespaceState.h"
#import "TDCommentState.h"

@implementation COSPreprocessor

+ (NSString*)processMultilineStrings:(NSString*)sourceString {
    
    NSString *tok = @"\"\"\"";
    
    NSScanner *scanner = [NSScanner scannerWithString:sourceString];
    
    // we don't want to skip any whitespace at the front, so we give it an empty character set.
    [scanner setCharactersToBeSkipped:[NSCharacterSet characterSetWithCharactersInString:@""]];
    
    NSMutableString *ret = [NSMutableString string];
    
    while (![scanner isAtEnd]) {
        
        NSString *into;
        NSString *quot;
        
        if ([scanner scanUpToString:tok intoString:&into]) {
            [ret appendString:into];
        }
        
        if ([scanner scanString:tok intoString:nil]) {
            if ([scanner scanString:tok intoString:nil]) {
                continue;
            }
            else if ([scanner scanUpToString:tok intoString:&quot] && [scanner scanString:tok intoString: nil]) {
                
                quot = [quot stringByReplacingOccurrencesOfString:@"\r\n" withString:@"\n"];
                quot = [quot stringByReplacingOccurrencesOfString:@"\r" withString:@"\n"];
                
                [ret appendString:@"\""];
                
                NSArray *lines = [quot componentsSeparatedByString:@"\n"];
                int i = 0;
                while (i < [lines count] - 1) {
                    NSString *line = [lines objectAtIndex:i];
                    line = [line stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                    [ret appendFormat:@"%@\\n", line];
                    i++;
                }
                
                NSString *line = [lines objectAtIndex:i];
                line = [line stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
                [ret appendFormat:@"%@\"", line];
            }
        }
    }
    
    return ret;
}

+ (NSString*)preprocessForObjCStrings:(NSString*)sourceString {
    
    NSMutableString *buffer = [NSMutableString string];
    TDTokenizer *tokenizer  = [TDTokenizer tokenizerWithString:sourceString];
    
    tokenizer.whitespaceState.reportsWhitespaceTokens = YES;
    tokenizer.commentState.reportsCommentTokens = NO;
    
    TDToken *eof                    = [TDToken EOFToken];
    TDToken *tok                    = nil;
    TDToken *nextToken              = nil;
    
    while ((tok = [tokenizer nextToken]) != eof) {
        
        if (tok.isSymbol && [[tok stringValue] isEqualToString:@"@"]) {
            
            // woo, it's special objc stuff.
            
            nextToken = [tokenizer nextToken];
            if (nextToken.quotedString) {
                [buffer appendFormat:@"[NSString stringWithString:%@]", [nextToken stringValue]];
            }
            else {
                [buffer appendString:[tok stringValue]];
                [buffer appendString:[nextToken stringValue]];
            }
        }
        else {
            [buffer appendString:[tok stringValue]];
        }
    }
    
    return buffer;
}

+ (BOOL)isOpenSymbol:(NSString*)tag {
    return [tag isEqualToString:@"["] || [tag isEqualToString:@"("];
}

+ (BOOL)isCloseSymbol:(NSString*)tag {
    return [tag isEqualToString:@"]"] || [tag isEqualToString:@")"];
}

+ (NSString*)fixTypeToVar:(NSString*)type {
    
    if ([type isEqualToString:@"double"]      ||
        [type isEqualToString:@"float"]       ||
        [type isEqualToString:@"CGFloat"]     ||
        [type isEqualToString:@"long"]        ||
        [type isEqualToString:@"NSInteger"]   ||
        [type isEqualToString:@"NSUInteger"]  ||
        [type isEqualToString:@"id"]          ||
        [type isEqualToString:@"bool"]        ||
        [type isEqualToString:@"BOOL"]        ||
        [type isEqualToString:@"int"])
    {
        return @"var";
    }
    
    return type;
}

+ (NSString*)preprocessForObjCMessagesToJS:(NSString*)sourceString {
    
    NSMutableString *buffer = [NSMutableString string];
    TDTokenizer *tokenizer  = [TDTokenizer tokenizerWithString:sourceString];
    
    [[tokenizer whitespaceState] setReportsWhitespaceTokens:YES];
    [[tokenizer commentState] setReportsCommentTokens:YES];
    
    TDToken *eof                    = [TDToken EOFToken];
    TDToken *tok                    = nil;
    
    JSTPSymbolGroup *currentGroup   = nil;
    
    while ((tok = [tokenizer nextToken]) != eof) {
        
        // debug(@"tok: '%@' %d", [tok description], tok.word);
        
        if ([tok isSymbol] && [self isOpenSymbol:[tok stringValue]]) {
            
            JSTPSymbolGroup *nextGroup  = [[JSTPSymbolGroup alloc] init];
            
            nextGroup.parent            = currentGroup;
            currentGroup                = nextGroup;
        }
        else if ([tok isSymbol] && [self isCloseSymbol:tok.stringValue]) {
            
            if (currentGroup.parent) {
                [currentGroup.parent addSymbol:currentGroup];
            }
            else if ([currentGroup description]) {
                [buffer appendString:[currentGroup description]];
            }
            
            currentGroup = currentGroup.parent;
            
            continue;
        }
        
        if (currentGroup) {
            [currentGroup addSymbol:tok];
        }
        else {
            
            NSString *s = [tok stringValue];
            
            s = [self fixTypeToVar:s];
            
            [buffer appendString:s];
        }
    }
    
    return buffer;
}

+ (NSString*)processImports:(NSString*)sourceString withBaseURL:(NSURL*)base importedURLs:(NSMutableArray *)importedURLs {
    
    /*
     
     This is horribly wrong, and needs to be added to an overall new parser that sticks everything in a tree, makes sure we don't import the same thing twice, makes sure that spaces in front don't kill it, etc.  It's just an idea I'm playing with for now.
     
     */
    
    NSMutableString *buffer = [NSMutableString string];
    TDTokenizer *tokenizer  = [TDTokenizer tokenizerWithString:sourceString];
    
    [[tokenizer whitespaceState] setReportsWhitespaceTokens:YES];
    [[tokenizer commentState] setReportsCommentTokens:YES];
    
    TDToken *eof                    = [TDToken EOFToken];
    TDToken *tok                    = nil;
    
    BOOL lastWasAtSym               = NO;
    
    while ((tok = [tokenizer nextToken]) != eof) {
        
        if ([tok isSymbol] && [[tok stringValue] isEqualToString:@"@"]) {
            lastWasAtSym = YES;
        }
        else {
            
            if (lastWasAtSym) {
                lastWasAtSym = NO;
                
                if ([tok isWord] && [[tok stringValue] isEqualToString:@"import"]) {
                    // OK, big assumptions here.  We're going to get some whitespace, adn then a quote, and then a newline.  And that's it.
                    
                    [tokenizer nextToken]; // the space
                    NSString *pathInQuotes = [[tokenizer nextToken] stringValue];
                    
                    NSString *path = [[pathInQuotes substringWithRange:NSMakeRange(1, [pathInQuotes length]-2)] stringByExpandingTildeInPath];
                    NSURL *importURL = nil;
                    
                    if (path.length && ![[path substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"/"]) {
                        importURL = [[base URLByDeletingLastPathComponent] URLByAppendingPathComponent:path];
                    } else if (base) {
                        importURL = [NSURL fileURLWithPath:path];
                    } else {
                        [buffer appendFormat:@"'Unable to import %@ becase we have no base url to import from'", path];
                    }
                    
                    if (importURL) {
                        if ([importedURLs containsObject:importURL]) {
                            [buffer appendFormat:@"// skipping already imported file from %@\n", [importURL path]];
                        } else {
                            NSError *outErr = nil;
                            NSString *s = [NSString stringWithContentsOfURL:importURL encoding:NSUTF8StringEncoding error:&outErr];
                            
                            if (s) {
                                [importedURLs addObject:importURL];
                                s = [self processImports:s withBaseURL:base importedURLs:importedURLs];
                                
                                [buffer appendFormat:@"// imported from %@\n", [importURL path]];
                                [buffer appendString:s];
                            }
                            else {
                                [buffer appendFormat:@"'Unable to import %@ because %@'", path, [outErr localizedFailureReason]];
                            }
                        }
                    }
                    
                    debug(@"[tok stringValue]: '%@'", path);
                    
                    continue;
                }
                else {
                    [buffer appendString:@"@"];
                }
            }
            
            [buffer appendString:[tok stringValue]];
            
        }
    }
    
    
    
    return buffer;
}


+ (NSString*)preprocessCode:(NSString*)sourceString withBaseURL:(NSURL*)base {
    
    NSMutableArray *importedURLs = (base) ? [NSMutableArray arrayWithObject:base] : [NSMutableArray new];
    
    sourceString = [self processImports:sourceString withBaseURL:(NSURL*)base importedURLs:importedURLs];
    sourceString = [self processMultilineStrings:sourceString];
    sourceString = [self preprocessForObjCStrings:sourceString];
    sourceString = [self preprocessForObjCMessagesToJS:sourceString];
    
    return sourceString;
}

+ (NSString*)preprocessCode:(NSString*)sourceString {
    return [self preprocessCode:sourceString withBaseURL:nil];
}

@end



@implementation JSTPSymbolGroup
@synthesize args=_args;
@synthesize parent=_parent;

- (id)init {
	self = [super init];
	if (self != nil) {
		_args = [NSMutableArray array];
	}
    
	return self;
}


- (void)dealloc {

}

- (void)addSymbol:(id)aSymbol {
    
    if (!_openSymbol && [aSymbol isKindOfClass:[TDToken class]]) {
        _openSymbol = [[aSymbol stringValue] characterAtIndex:0];
    }
    else {
        [_args addObject:aSymbol];
    }
}

- (int)nonWhitespaceCountInArray:(NSArray*)ar {
    
    int count = 0;
    
    for (__strong id f in ar) {
        
        f = [[f description] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if ([f length]) {
            count++;
        }
    } 
    
    return count;
    
}

- (NSString*)description {
    
    NSUInteger argsCount = [_args count];
    
    if (_openSymbol == '(') {
        return [NSString stringWithFormat:@"(%@)", [_args componentsJoinedByString:@""]];
    }
    
    if (_openSymbol != '[') {
        return [NSString stringWithFormat:@"Bad JSTPSymbolGroup! %@", _args];
    }
    
    BOOL firstArgIsWord         = [_args count] && ([[_args objectAtIndex:0] isKindOfClass:[TDToken class]] && [[_args objectAtIndex:0] isWord]);
    BOOL firstArgIsSymbolGroup  = [_args count] && [[_args objectAtIndex:0] isKindOfClass:[JSTPSymbolGroup class]];
    
    // objc messages start with a word.  So, if it isn't- then let's just fling things back the way they were.
    if (!firstArgIsWord && !firstArgIsSymbolGroup) {
        return [NSString stringWithFormat:@"[%@]", [_args componentsJoinedByString:@""]];
    }
    
    
    NSMutableString *selector   = [NSMutableString string];
    NSMutableArray *currentArgs = [NSMutableArray array];
    NSMutableArray *methodArgs  = [NSMutableArray array];
    NSString *target            = [_args objectAtIndex:0];
    NSString *lastWord          = nil;
    BOOL hadSymbolAsArg         = NO;
    NSUInteger idx = 1;
    
    while (idx < argsCount) {
        
        id currentPassedArg = [_args objectAtIndex:idx++];
        
        TDToken *currentToken = [currentPassedArg isKindOfClass:[TDToken class]] ? currentPassedArg : nil;
        
        NSString *value = currentToken ? [currentToken stringValue] : [currentPassedArg description];
        
        if ([currentToken isWhitespace]) {
            
            //if ([value isEqualToString:@" "]) {
                [currentArgs addObject:value];
            //}
            
            continue;
        }
        
        if (!hadSymbolAsArg && [currentToken isSymbol]) {
            hadSymbolAsArg = YES;
        }
        
        
        
        if ([@":" isEqualToString:value]) {
            
            [currentArgs removeLastObject];
            
            if ([currentArgs count]) {
                [methodArgs addObject:[currentArgs componentsJoinedByString:@" "]];
                [currentArgs removeAllObjects];
            }

            if (lastWord) {
                [selector appendString:lastWord];
            }
            [selector appendString:value];
        }
        else {
            [currentArgs addObject:[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        }
        
        lastWord = value;
    }
    
    
    if ([currentArgs count]) {
        [methodArgs addObject:[currentArgs componentsJoinedByString:@""]];
    }
    
    
    if (![selector length] && !hadSymbolAsArg && ([methodArgs count] == 1)) {
        [selector appendString:[methodArgs lastObject]];
        [methodArgs removeAllObjects];
    }
    
    if (![selector length] && [methodArgs count] == 1) {
        return [NSString stringWithFormat:@"[%@%@]", target, [methodArgs lastObject]];
    }
    
    if (![methodArgs count] && ![selector length]) {
        return [NSString stringWithFormat:@"[%@]", target];
    }
    
    if (![selector length] && lastWord) {
        [selector appendString:lastWord];
        [methodArgs removeLastObject];
    }
    
    
    BOOL useMsgSend = NO;
    
    if (useMsgSend) {
        NSMutableString *ret = [NSMutableString stringWithString:@"jsobjc_msgSend"];

        if ([methodArgs count]) {
            [ret appendFormat:@"%d", (int)[methodArgs count]];
        }
        
        [ret appendFormat:@"(%@, \"%@\"", target, selector];
        
        for (NSString *arg in methodArgs) {
            [ret appendFormat:@", %@", arg];
        }
        
        [ret appendString:@")"];
        
        return ret;
    }
    
    [selector replaceOccurrencesOfString:@":" withString:@"_" options:0 range:NSMakeRange(0, [selector length])];
    
    NSMutableString *ret = [NSMutableString stringWithFormat:@"%@.%@(", target, selector];
    
    if ([self nonWhitespaceCountInArray:methodArgs]) {
        
        for (int i = 0; i < [methodArgs count]; i++) {
            
            NSString *arg = [methodArgs objectAtIndex:i];
            NSString *s = [arg description];
            NSString *t = [s stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

            [ret appendString:s];
            
            if ([t length] && i < [methodArgs count] - 1) {
                [ret appendString:@","];
            }
        }
    }
    
    [ret appendString:@")"];
    
    return ret;
    
}

@end

