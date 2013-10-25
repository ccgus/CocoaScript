//
//  JSTScanner.m
//  jstalk
//
//  Created by August Mueller on 1/16/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import "JSTScanner.h"


@implementation JSTScanner
@synthesize jsString=_jsString;
@synthesize frames=_frames;

+ (JSTScanner*) scannerWithString:(NSString*)s {
    
    JSTScanner *sc = [[[JSTScanner alloc] init] autorelease];
    
    sc.jsString = s;
    
    return sc;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (_uString) {
        free(_uString);
        _uString = nil;
    }
    
    [_jsString release];
    [super dealloc];
}

- (NSString*) nextToken {
    
    _tokenIsBreakChar    = NO;
    _currentRange.length = 0;
    
    while (_currentRange.location + _currentRange.length < _stringLength) {
        
        //printf("%c", _uString[_currentRange.location + _currentRange.length]);
        
        if (isBreakChar(_uString[_currentRange.location + _currentRange.length])) {
            
            if (_currentRange.length == 0) {
                _tokenIsBreakChar = YES;
                NSString *ret = [NSString stringWithCharacters:&_uString[_currentRange.location] length:1];
                _breakChar = _uString[_currentRange.location];
                _currentRange.location++;
                return ret;
            }
            else {
                NSString *ret = [NSString stringWithCharacters:&_uString[_currentRange.location] length:_currentRange.length];
                _currentRange.location += _currentRange.length;
                return ret;
            }
        }
        
        _currentRange.length++;
        
        if (_currentRange.location + _currentRange.length == _stringLength) {
            // crap, we're at the end.
            NSString *ret = [NSString stringWithCharacters:&_uString[_currentRange.location] length:_currentRange.length];
            _currentRange.location += _currentRange.length;
            return ret;
        }
    }
    
    return nil;
}


- (BOOL) hasNextToken {
    return (_currentRange.location < _stringLength);
}

- (unichar) breakChar {
    if (_tokenIsBreakChar) {
        return _breakChar;
    }
    
    return 0;
}

- (unichar) peekChar {
    return _uString[_currentRange.location+1];
}

- (NSString*) restOfLine {
    NSMutableString *ret = [NSMutableString string];
    
    while ([self hasNextToken]) {
        
        NSString *tok = [self nextToken];
        
        if ([tok isEqualToString:@"\r"] || [tok isEqualToString:@"\n"]) {
            return ret;
        }
        
        [ret appendString:tok];
    }
    
    return ret;
}


- (NSDictionary*) readJSTalkFrame {
    
    NSString *zeLine = [[self restOfLine] substringFromIndex:2];
    
    int endLoc = [zeLine rangeOfString:@"\""].location;
    
    NSString *appName = [zeLine substringToIndex:endLoc];
    
    NSMutableString *frame = [NSMutableString string];
    
    int bracketCount = 1;
    
    while ([self hasNextToken]) {
        
        NSString *tok = [self nextToken];
        
        
        if ([tok isEqualToString:@"}"]) {
            bracketCount--;
            
            if (bracketCount <= 0) {
                break;
            }
        }
        else if ([tok isEqualToString:@"{"]) {
            bracketCount++;
        }
        
        [frame appendString:tok];
    }
    
    NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:appName, @"appName", frame, @"script", nil];
    
    return d;
}

- (BOOL) breakCharIsSpace {
    return isspace([self breakChar]);
}

- (int) location {
    return _currentRange.location;
}

- (void) setLocation:(int)newLocation {
    _currentRange.location = newLocation;
}

- (void) scan {
    
    if (!_jsString) {
        return;
    }
    
    if (_uString) {
        free(_uString);
        _uString = nil;
    }
    
    _stringLength = [_jsString length];
    _uString = malloc((sizeof(unichar) * _stringLength) + 2);
    [_jsString getCharacters:_uString];
    
    _uString[_stringLength] = ' ';
    
    
    
    self.frames = [NSMutableArray array];
    
    NSMutableString *currentLocalFrame = [NSMutableString string];
    
    while ([self hasNextToken]) {
        
        NSString *tok = [self nextToken];
        
        if (!_inComment && !_inQuote && [tok isEqualToString:@"/"] && (_breakChar == '/')) {
            //debug(@"comment? %c %d", _breakChar, [self peekChar]);
            //debug(@"restOfLine: %@", [self restOfLine]);
        }
        
        if ([tok isEqualToString:@"JSTalk"]) {
            
            // end our current frame.
            
            NSDictionary *localFrame = [NSDictionary dictionaryWithObjectsAndKeys:@".local", @"appName", currentLocalFrame, @"script", nil];
            [_frames addObject:localFrame];
            
            currentLocalFrame = [NSMutableString string];
            
            int currentLocation = [self location];
            
            NSString *rest = [self restOfLine];
            
            if ([rest hasPrefix:@"(\""]) {
                [self setLocation:currentLocation];
                NSDictionary *frameInfo = [self readJSTalkFrame];
                [_frames addObject:frameInfo];
            }
        }
        else {
            [currentLocalFrame appendString:tok];
        }
    }
    
    NSDictionary *localFrame = [NSDictionary dictionaryWithObjectsAndKeys:@".local", @"appName", currentLocalFrame, @"script", nil];
    [_frames addObject:localFrame];
    
}


@end
