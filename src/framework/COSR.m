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

static NSString *COSUTTypeNumber = @"R.number";
static NSString *COSUTTypeTable = @"R.table";

@interface COSR ()
@property (strong) NSString *tablePath;
@property (strong) COSDatabaseQueue *q;
@end

@implementation COSR

- (instancetype)init {
    self = [super init];
    if (self) {
        // _table = [NSMutableDictionary dictionary];
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
    
    COSR *sub = [self subTableWithName:tableName];
    
    [self setObject:sub forKeyedSubscript:tableName];
    
    return sub;
}


- (id)objectForKeyedSubscript:(NSString *)key {
    
    __block id value = nil;
    
    [_q inDatabase:^(COSDatabase *db) {
        NSString *query = @"select data, uti from R where name = ? and parentID = ?";
        
        COSResultSet *rs = [db executeQuery:query, key, _tablePath];
        
        if ([rs next]) {
            
            CFStringRef uti = (__bridge CFStringRef)[rs stringForColumn:@"uti"];
            
            if (UTTypeConformsTo(uti, kUTTypeText)) {
                value = [rs stringForColumn:@"data"];
            }
            else if ([(__bridge id)uti isEqualToString:COSUTTypeNumber]) {
                value = [rs objectForColumnName:@"data"];
                assert([value isKindOfClass:[NSNumber class]]);
            }
            else if ([(__bridge id)uti isEqualToString:COSUTTypeTable]) {
                
                debug(@"yay");
                
                value = [self subTableWithName:key];
                
            }
            else {
                value = [rs dataForColumn:@"data"];
            }
            
            [rs close];
        }
        
        
    }];
    
    if (!value) {
        NSLog(@"Could not find value for %@ in table %@", key, _tablePath);
    }
    
    return value;
}

- (void)setObject:(id)theObj forKeyedSubscript:(NSString *)key {
    
    __block id obj = theObj;
    
    [_q inDatabase:^(COSDatabase *db) {
        
        NSString *uuid = [NSString stringWithUUID];
        NSString *uti = (id)kUTTypeData;
        
        if ([obj isKindOfClass:[NSString class]]) {
            uti = (id)kUTTypeUTF8PlainText;
        }
        else if ([obj isKindOfClass:[NSNumber class]]) {
            uti = COSUTTypeNumber;
        }
        else if ([obj isKindOfClass:[COSR class]]) {
            uti = COSUTTypeTable;
            obj = [NSNull null];
        }
        
        NSString *delete = @"delete from R where name = ? and parentID = ?";
        
        if (!_tablePath) {
            delete = @"delete from R where name = ? and parentID is null";
        }
        
        [db executeUpdate:delete, key, _tablePath];
        
        if (obj) {
            NSString *sql = @"insert into R (uniqueID, name, data, uti, parentID) values (?, ?, ?, ?, ?)";
            if (![db executeUpdate:sql, uuid, key, obj, uti, _tablePath]) {
                NSLog(@"Could not set value '%@' for '%@' in table '%@'", obj, key, _tablePath ? _tablePath : [NSNull null]);
            }
        }
        
    }];
}

- (NSArray*)subTables {
    
    NSMutableArray *subTables = [NSMutableArray array];
    
    [_q inDatabase:^(COSDatabase *db) {
        
        NSString *query = @"select name from R where uti = ? and parentID = ?";
        
        #pragma message "FIXME: why do we have to do 'is null' instead of passing a null value for parentID?  FMDB bug?"
        
        if (!_tablePath) {
            query = @"select name from R where uti = ? and parentID is null";
        }
        
        COSResultSet *rs = [db executeQuery:query, COSUTTypeTable, _tablePath];
        while ([rs next]) {
            
            COSR *sub = [self subTableWithName:[rs stringForColumn:@"name"]];
            
            [subTables addObject:sub];
        }
        
    }];
    
    
    return subTables;
}


- (NSString*)description {
    
    return [[super description] stringByAppendingFormat:@" (%@)", _tablePath];
    
    
}


@end
