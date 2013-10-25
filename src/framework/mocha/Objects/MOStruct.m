//
//  MOStruct.m
//  Mocha
//
//  Created by Logan Collins on 5/15/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOStruct.h"
#import "MochaRuntime.h"


@implementation MOStruct {
    NSArray *_memberNames;
    NSMutableDictionary *_memberValues;
}

@synthesize name=_name;
@synthesize memberNames=_memberNames;

+ (MOStruct *)structureWithName:(NSString *)name memberNames:(NSArray *)memberNames {
    return [[self alloc] initWithName:name memberNames:memberNames];
}

- (id)initWithName:(NSString *)name memberNames:(NSArray *)memberNames {
    self = [super init];
    if (self) {
        _name = [name copy];
        _memberNames = [memberNames copy];
        _memberValues = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)init {
    return [self initWithName:nil memberNames:nil];
}

- (NSString *)descriptionWithIndent:(NSUInteger)indent {
    NSMutableString *indentString = [NSMutableString string];
    for (NSUInteger i=0; i<indent; i++) {
        [indentString appendString:@"    "];
    }
    
    NSMutableString *items = [NSMutableString stringWithString:@"{\n"];
    for (NSUInteger i=0; i<[_memberNames count]; i++) {
        NSString *key = [_memberNames objectAtIndex:i];
        
        [items appendString:indentString];
        [items appendString:@"    "];
        [items appendString:key];
        [items appendString:@" = "];
        
        id value = [_memberValues objectForKey:key];
        if ([value isKindOfClass:[MOStruct class]]) {
            [items appendString:[value descriptionWithIndent:indent + 1]];
        }
        else {
            [items appendString:[value description]];
        }
        
        if (i != [_memberNames count] - 1) {
            [items appendString:@","];
        }
        
        [items appendString:@"\n"];
    }
    [items appendString:indentString];
    [items appendString:@"}"];
    return [NSString stringWithFormat:@"%@ %@", self.name, items];
}

- (NSString *)description {
    return [self descriptionWithIndent:0];
}

- (id)objectForMemberName:(NSString *)name {
    if (![_memberNames containsObject:name]) {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Struct %@ has no member named %@", self.name, name] userInfo:nil];
    }
    return [_memberValues objectForKey:name];
}

- (void)setObject:(id)obj forMemberName:(NSString *)name {
    if (![_memberNames containsObject:name]) {
        @throw [NSException exceptionWithName:MORuntimeException reason:[NSString stringWithFormat:@"Struct %@ has no member named %@", self.name, name] userInfo:nil];
    }
    [_memberValues setObject:obj forKey:name];
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return [self objectForMemberName:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key {
    [self setObject:obj forMemberName:key];
}

@end
