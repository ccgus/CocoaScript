//
//  COSR.m
//  Cocoa Script
//
//  Created by August Mueller on 6/24/14.
//
//

#import "COSR.h"
#import "COSDatabaseQueue.h"
#import "COSDatabaseAdditions.h"
#import "COSExtras.h"

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SQLCode(text) @ STRINGIZE2(text)

@interface COSR ()
@property (strong) NSMutableDictionary *table;
@property (strong) NSString *tablePath;
@property (strong) COSDatabaseQueue *q;
@end

@implementation COSR

- (instancetype)init {
    self = [super init];
    if (self) {
        _table = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)tableWithPath:(NSString*)path {
    
    COSR *me = [COSR new];
    [me setTablePath:path];
    
    [me setQ:[self q]];
    
    return me;
}


+ (instancetype)rootWithURL:(NSURL*)fileURL {
    
    COSR *me = [COSR new];
    
    [me setQ:[COSDatabaseQueue databaseQueueWithPath:[fileURL path]]];
    [me setupDatabase];
    
    return me;
}

- (void)setupDatabase {
    
    [_q inDatabase:^(COSDatabase *db) {
       
        if (![db tableExists:@"R"]) {
            
            NSString *const rDB = SQLCode (
             create table R (uniqueID text,
                             name text not null,
                             data blob,
                             uti text not null,
                             parentID text);
             );
            
            if (![db executeUpdate:rDB]) {
                NSLog(@"error creating R table: %@", [db lastError]);
            }
        }
        
    }];
    
}

- (instancetype)subTableWithName:(NSString*)name {
    
    if (_tablePath) {
        return [self tableWithPath:[_tablePath stringByAppendingFormat:@".%@", name]];
    }
    
    return [self tableWithPath:name];
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
    
    /*
    This code is commented out, just because I wanted to see if the basics could be done.  It can.  It needs to be fancier for the future though.
    __block id value = nil;
    
    [_q inDatabase:^(COSDatabase *db) {
        NSString *query = @"select data, uti from R where name = ? and parentID = ?";
     
        COSResultSet *rs = [db executeQuery:query, key, _tablePath];
        
        if ([rs next]) {
            
            CFStringRef uti = (__bridge CFStringRef)[rs stringForColumn:@"uti"];
            
            if (UTTypeConformsTo(uti, kUTTypeText)) {
                value = [rs stringForColumn:@"data"];
            }
            else {
                value = [rs dataForColumn:@"data"];
            }
            
            [rs close];
        }
        else {
            NSLog(@"Could not find value for %@ in table %@", key, _tablePath);
        }
        
    }];
    
    
    if (value) {
        return value;
    }
    */
    
    return [_table objectForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(NSString *)key {
    
    /*
    
    [_q inDatabase:^(COSDatabase *db) {
        NSString *sql = @"insert into R (uniqueID, name, data, uti, parentID) values (?, ?, ?, ?, ?)";
        
        
        NSString *uuid = [NSString stringWithUUID];
        NSString *uti = (id)kUTTypeData;
        
        if ([obj isKindOfClass:[NSString class]]) {
            uti = (id)kUTTypeUTF8PlainText;
        }
        
        if (![db executeUpdate:sql, uuid, key, obj, uti, _tablePath]) {
            NSLog(@"Could not set value '%@' for '%@' in table '%@'", obj, key, _tablePath);
        }
        
    }];
    */
    
    if (!obj) {
        [_table removeObjectForKey:key];
        return;
    }
    
    [_table setObject:obj forKey:key];
}

@end
