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
#import "COScript.h"

#define STRINGIZE(x) #x
#define STRINGIZE2(x) STRINGIZE(x)
#define SQLCode(text) @ STRINGIZE2(text)

static NSString *COSUTTypeNumber = @"R.number";
static NSString *COSUTTypeTable = @"R.table";

@interface COSR ()
@property (strong) NSString *tablePath;
@property (strong) NSString *tableID;
@property (strong) COSDatabaseQueue *q;
@end

@implementation COSR

- (instancetype)init {
    self = [super init];
    if (self) {
        // _modules = [NSMutableDictionary dictionary];
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

+ (instancetype)rootWithPath:(NSString*)filePath {
    return [self rootWithURL:[NSURL fileURLWithPath:filePath]];
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
    
    #pragma message "FIXME: make sure to return an existing one if it's already around"
    
    [sub setTableID:[NSString stringWithUUID]];
    [self setObject:sub forKeyedSubscript:tableName];
    
    return sub;
}


- (id)fsObjectWithKey:(NSString*)key {
    
    debug(@"key: '%@'", key);
    
    NSString *basePath = [[_q path] stringByDeletingLastPathComponent];
    
    
    // FIXME: is this too fragile?
    NSString *subFolder = [_tablePath stringByReplacingOccurrencesOfString:@"." withString:@"/"];
    
    basePath = [basePath stringByAppendingPathComponent:subFolder];
    
    NSString *filePath   = [basePath stringByAppendingPathComponent:key];
    NSString *lookupPath = filePath;
    
    BOOL found = [[NSFileManager defaultManager] fileExistsAtPath:lookupPath];
    
    if (!found) {
        
        NSArray *extensions = @[@"js", @"coscript"];
        
        for (NSString *ext in extensions) {
            
            lookupPath = [filePath stringByAppendingPathExtension:ext];
            
            debug(@"lookupPath: '%@'", lookupPath);
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:lookupPath]) {
                found = YES;
                break;
            }
        }
    }
    
    if (found) {
        
        NSError *outErr = nil;
        NSString *script = [NSString stringWithContentsOfFile:lookupPath encoding:NSUTF8StringEncoding error:&outErr];
        if (!script) {
            NSLog(@"Error reading path '%@'", lookupPath);
            NSLog(@"%@", outErr);
            return nil;
        }
        
        
        NSString *rep = [NSString stringWithFormat:@"R.%@.%@", _tablePath, key];
        script = [script stringByReplacingOccurrencesOfString:@"$R" withString:rep];
        
        COScript *cos = [COScript currentCOScript];
        
        id r = [cos executeString:script baseURL:[NSURL fileURLWithPath:lookupPath]];
        
        return r;
    }
    
    
    return nil;
    
}

- (id)objectForKeyedSubscript:(NSString *)key {
    
    __block id value = nil;
    
    [_q inDatabase:^(COSDatabase *db) {
        NSString *query = @"select data, uti, uniqueID from R where name = ? and parentID = ?";
        
        if (!_tableID) {
            query = @"select data, uti, uniqueID from R where name = ? and parentID is null";
        }
        
        COSResultSet *rs = [db executeQuery:query, key, _tableID];
        
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
                value = [self subTableWithName:key];
                [(COSR*)value setTableID:[rs stringForColumn:@"uniqueID"]];
            }
            else {
                value = [rs dataForColumn:@"data"];
            }
            
            [rs close];
        }
    }];
    
    if (!value) {
        value = [self fsObjectWithKey:key];
    }
    
    if (!value) {
        NSLog(@"Could not find value for key '%@' in table %@ / %@", key, _tablePath, _tableID);
    }
    
    return value;
}

/*
- (void)_dynamicContextEvaluation:(id)e patternString:(NSString*)s {
    debug(@"s: '%@'", s);
    debug(@"e: '%@' (%@)", e, NSStringFromClass([e class]));
}
*/

- (void)setObject:(id)theObj forKeyedSubscript:(NSString *)key {
    
    
    debug(@"%@: '%@'", key, theObj);
    
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
            
            uuid = [(COSR*)obj tableID];
            assert([(COSR*)obj tableID]);
            
            obj = [NSNull null];
        }
        
        NSString *delete = @"delete from R where name = ? and parentID = ?";
        
        if (!_tableID) {
            delete = @"delete from R where name = ? and parentID is null";
        }
        
        [db executeUpdate:delete, key, _tableID];
        
        if (obj) {
            NSString *sql = @"insert into R (uniqueID, name, data, uti, parentID) values (?, ?, ?, ?, ?)";
            if (![db executeUpdate:sql, uuid, key, obj, uti, _tableID]) {
                NSLog(@"Could not set value '%@' for '%@' in table '%@'", obj, key, _tablePath ? _tablePath : [NSNull null]);
            }
        }
        
        if ([_tablePath length]) {
            assert(_tableID);
        }
        
    }];
}

- (NSArray*)subTables {
    
    NSMutableArray *subTables = [NSMutableArray array];
    
    [_q inDatabase:^(COSDatabase *db) {
        
        NSString *query = @"select name from R where uti = ? and parentID = ?";
        
        if (!_tablePath) {
            query = @"select name, uniqueID from R where uti = ? and parentID is null";
        }
        
        COSResultSet *rs = [db executeQuery:query, COSUTTypeTable, _tableID];
        while ([rs next]) {
            
            COSR *sub = [self subTableWithName:[rs stringForColumn:@"name"]];
            [sub setTableID:[rs stringForColumn:@"uniqueID"]];
            [subTables addObject:sub];
        }
        
    }];
    
    
    return subTables;
}

- (NSArray*)keys {
    
    NSMutableArray *keyNames = [NSMutableArray array];
    
    [_q inDatabase:^(COSDatabase *db) {
        
        NSString *query = @"select name from R where parentID = ?";
        
        if (!_tablePath) {
            query = @"select name from R where parentID is null";
        }
        
        COSResultSet *rs = [db executeQuery:query, _tableID];
        while ([rs next]) {
            [keyNames addObject:[rs stringForColumn:@"name"]];
        }
        
    }];
    
    return keyNames;
}

- (NSString*)description {
    
    return [[super description] stringByAppendingFormat:@" (%@ id:%@)", _tablePath, _tableID];
    
    
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    debug(@"-[%@ %@]?", NSStringFromClass([self class]), NSStringFromSelector(aSelector));
    return [super respondsToSelector:aSelector];
}


@end
