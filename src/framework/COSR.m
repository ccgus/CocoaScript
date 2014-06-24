//
//  COSR.m
//  Cocoa Script
//
//  Created by August Mueller on 6/24/14.
//
//

#import "COSR.h"

@interface COSR ()
@property (strong) NSMutableDictionary *table;
@property (strong) NSString *tablePath;
@end

@implementation COSR

- (instancetype)init {
    self = [super init];
    if (self) {
        _table = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)tableWithPath:(NSString*)path {
    
    COSR *me = [COSR new];
    [me setTablePath:path];
    
    return me;
}

- (instancetype)subTableWithName:(NSString*)name {
    
    if (_tablePath) {
        return [COSR tableWithPath:[_tablePath stringByAppendingFormat:@".%@", name]];
    }
    
    return [COSR tableWithPath:name];
}

- (instancetype)makeTable:(NSString*)tableName {
    
    COSR *sub = [_table objectForKey:tableName];
    if (!sub) {
        sub = [self subTableWithName:tableName];
        [_table setObject:sub forKey:tableName];
    }
    
    return sub;
}

- (id)objectForKeyedSubscript:(NSString *)key {
    debug(@"%s:%d", __FUNCTION__, __LINE__);
    debug(@"key: '%@'", key);
    
    return [_table objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key {
    debug(@"%s:%d", __FUNCTION__, __LINE__);
    debug(@"obj: '%@'", obj);
    debug(@"key: '%@'", key);
    
    [_table setObject:obj forKey:key];
    
}

@end
