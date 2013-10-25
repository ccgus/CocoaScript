//
//  MOBridgeSupportParser.m
//  Mocha
//
//  Created by Logan Collins on 5/11/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

#import "MOBridgeSupportParser.h"
#import "MOBridgeSupportLibrary.h"
#import "MOBridgeSupportSymbol.h"


#define PARSER_DEBUG 0


@interface MOBridgeSupportParser () <NSXMLParserDelegate>

@end


@implementation MOBridgeSupportParser {
    NSXMLParser *_parser;
    MOBridgeSupportLibrary *_library;
    NSMutableArray *_symbolStack;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    _parser = nil;
    _library = nil;
    _symbolStack = nil;
}

- (MOBridgeSupportLibrary *)libraryWithBridgeSupportURL:(NSURL *)aURL error:(NSError **)outError {
    _parser = [[NSXMLParser alloc] initWithContentsOfURL:aURL];
    [_parser setDelegate:self];
    
    BOOL success = [_parser parse];
    if (!success) {
        _library = nil;
    }
    
    NSError *error = [_parser parserError];
    if (outError != NULL) {
        *outError = error;
    }
    
    _parser = nil;
    
    return _library;
}


#pragma mark -
#pragma mark XML Parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
#if PARSER_DEBUG
    NSLog(@"Parser didStartDocument");
#endif
    
    _library = [[MOBridgeSupportLibrary alloc] init];
    _symbolStack = [[NSMutableArray alloc] init];
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
#if PARSER_DEBUG
    NSLog(@"Parser didEndDocument");
#endif
    
    _symbolStack = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
#if PARSER_DEBUG
    NSLog(@"Parser didStartElement: %@, attributes=%@", elementName, attributeDict);
#endif
    
    if ([elementName isEqualToString:@"signatures"]) {
        // Signatures
        
    }
    else if ([elementName isEqualToString:@"depends_on"]) {
        // Dependency
        NSString *path = [attributeDict objectForKey:@"path"];
        [_library addDependency:path];
    }
    else if ([elementName isEqualToString:@"struct"]) {
        // Struct
        MOBridgeSupportStruct *symbol = [[MOBridgeSupportStruct alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.type = [attributeDict objectForKey:@"type"];
        symbol.type64 = [attributeDict objectForKey:@"type64"];
        symbol.opaque = [[attributeDict objectForKey:@"opaque"] isEqualToString:@"true"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"cftype"]) {
        // CFType
        MOBridgeSupportCFType *symbol = [[MOBridgeSupportCFType alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.type = [attributeDict objectForKey:@"type"];
        symbol.type64 = [attributeDict objectForKey:@"type64"];
        symbol.tollFreeBridgedClassName = [attributeDict objectForKey:@"tollfree"];
        symbol.getTypeIDFunctionName = [attributeDict objectForKey:@"gettypeid_func"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"opaque"]) {
        // Opaque
        MOBridgeSupportOpaque *symbol = [[MOBridgeSupportOpaque alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.type = [attributeDict objectForKey:@"type"];
        symbol.type64 = [attributeDict objectForKey:@"type64"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"constant"]) {
        // Constant
        MOBridgeSupportConstant *symbol = [[MOBridgeSupportConstant alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.type = [attributeDict objectForKey:@"type"];
        symbol.type64 = [attributeDict objectForKey:@"type64"];
        symbol.hasMagicCookie = [[attributeDict objectForKey:@"magic_cookie"] isEqualToString:@"true"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"string_constant"]) {
        // String constant
        MOBridgeSupportStringConstant *symbol = [[MOBridgeSupportStringConstant alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.value = [attributeDict objectForKey:@"value"];
        symbol.hasNSString = [[attributeDict objectForKey:@"nsstring"] isEqualToString:@"true"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"enum"]) {
        // Enum
        MOBridgeSupportEnum *symbol = [[MOBridgeSupportEnum alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        if ([attributeDict objectForKey:@"value"]) {
            symbol.value = [NSNumber numberWithInteger:[[attributeDict objectForKey:@"value"] integerValue]];
        }
        if ([attributeDict objectForKey:@"value64"]) {
            symbol.value64 = [NSNumber numberWithInteger:[[attributeDict objectForKey:@"value64"] integerValue]];
        }
        symbol.ignored = [[attributeDict objectForKey:@"ignore"] isEqualToString:@"true"];
        symbol.suggestion = [attributeDict objectForKey:@"suggestion"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"function"]) {
        // Function
        MOBridgeSupportFunction *symbol = [[MOBridgeSupportFunction alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.variadic = [[attributeDict objectForKey:@"variadic"] isEqualToString:@"true"];
        if ([attributeDict objectForKey:@"sentinel"]) {
            symbol.sentinel = [NSNumber numberWithInteger:[[attributeDict objectForKey:@"sentinel"] integerValue]];
        }
        symbol.inlineFunction = [[attributeDict objectForKey:@"inline"] isEqualToString:@"true"];
        [_library setSymbol:symbol forName:symbol.name];
        
        [_symbolStack addObject:symbol];
    }
    else if ([elementName isEqualToString:@"function_alias"]) {
        // Function alias
        MOBridgeSupportFunctionAlias *symbol = [[MOBridgeSupportFunctionAlias alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        symbol.original = [attributeDict objectForKey:@"original"];
        [_library setSymbol:symbol forName:symbol.name];
    }
    else if ([elementName isEqualToString:@"class"]) {
        // Class
        MOBridgeSupportClass *symbol = [[MOBridgeSupportClass alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        [_library setSymbol:symbol forName:symbol.name];
        [_symbolStack addObject:symbol];
    }
    else if ([elementName isEqualToString:@"informal_protocol"]) {
        // Informal protocol
        MOBridgeSupportInformalProtocol *symbol = [[MOBridgeSupportInformalProtocol alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        [_library setSymbol:symbol forName:symbol.name];
        [_symbolStack addObject:symbol];
    }
    else if ([elementName isEqualToString:@"method"]) {
        // Method
        MOBridgeSupportMethod *symbol = [[MOBridgeSupportMethod alloc] init];
        symbol.name = [attributeDict objectForKey:@"name"];
        if ([attributeDict objectForKey:@"selector"]) {
            symbol.selector = NSSelectorFromString([attributeDict objectForKey:@"selector"]);
        }
        symbol.type = [attributeDict objectForKey:@"type"];
        symbol.type64 = [attributeDict objectForKey:@"type64"];
        symbol.classMethod = [[attributeDict objectForKey:@"class_method"] isEqualToString:@"true"];
        symbol.variadic = [[attributeDict objectForKey:@"variadic"] isEqualToString:@"true"];
        if ([attributeDict objectForKey:@"sentinel"]) {
            symbol.sentinel = [NSNumber numberWithInteger:[[attributeDict objectForKey:@"sentinel"] integerValue]];
        }
        symbol.ignored = [[attributeDict objectForKey:@"ignore"] isEqualToString:@"true"];
        symbol.suggestion = [attributeDict objectForKey:@"suggestion"];
        
        MOBridgeSupportSymbol *currentSymbol = [_symbolStack lastObject];
        if ([currentSymbol isKindOfClass:[MOBridgeSupportClass class]]
            || [currentSymbol isKindOfClass:[MOBridgeSupportInformalProtocol class]]) {
            [(MOBridgeSupportClass *)currentSymbol addMethod:symbol];
        }
        
        [_symbolStack addObject:symbol];
    }
    else if ([elementName isEqualToString:@"arg"]) {
        // Argument
        MOBridgeSupportArgument *argument = [[MOBridgeSupportArgument alloc] init];
        argument.cArrayLengthInArg = [attributeDict objectForKey:@"c_array_length_in_arg"];
        argument.cArrayOfFixedLength = [[attributeDict objectForKey:@"c_array_of_fixed_length"] isEqualToString:@"true"];
        argument.cArrayDelimitedByNull = [[attributeDict objectForKey:@"c_array_delimited_by_null"] isEqualToString:@"true"];
        argument.cArrayOfVariableLength = [[attributeDict objectForKey:@"c_array_of_variable_length"] isEqualToString:@"true"];
        argument.functionPointer = [[attributeDict objectForKey:@"function_pointer"] isEqualToString:@"true"];
        argument.signature = [attributeDict objectForKey:@"sel_of_type"];
        argument.signature64 = [attributeDict objectForKey:@"sel_of_type64"];
        argument.cArrayLengthInReturnValue = [[attributeDict objectForKey:@"c_array_length_in_retval"] isEqualToString:@"true"];
        argument.acceptsNull = ![[attributeDict objectForKey:@"null_accepted"] isEqualToString:@"false"];
        argument.acceptsPrintfFormat = [[attributeDict objectForKey:@"printf_format"] isEqualToString:@"true"];
        argument.alreadyRetained = [[attributeDict objectForKey:@"already_retained"] isEqualToString:@"true"];
        argument.type = [attributeDict objectForKey:@"type"];
        argument.type64 = [attributeDict objectForKey:@"type64"];
        argument.index = [[attributeDict objectForKey:@"index"] integerValue];
        
        id currentSymbol = [_symbolStack lastObject];
        if ([currentSymbol isKindOfClass:[MOBridgeSupportMethod class]]) {
            [(MOBridgeSupportMethod *)currentSymbol addArgument:argument];
        }
        else if ([currentSymbol isKindOfClass:[MOBridgeSupportFunction class]]) {
            [(MOBridgeSupportFunction *)currentSymbol addArgument:argument];
        }
        else if ([currentSymbol isKindOfClass:[MOBridgeSupportArgument class]]) {
            [(MOBridgeSupportArgument *)currentSymbol addArgument:argument];
        }
        
        [_symbolStack addObject:argument];
    }
    else if ([elementName isEqualToString:@"retval"]) {
        // Return value
        MOBridgeSupportArgument *argument = [[MOBridgeSupportArgument alloc] init];
        argument.cArrayLengthInArg = [attributeDict objectForKey:@"c_array_length_in_arg"];
        argument.cArrayOfFixedLength = [[attributeDict objectForKey:@"c_array_of_fixed_length"] isEqualToString:@"true"];
        argument.cArrayDelimitedByNull = [[attributeDict objectForKey:@"c_array_delimited_by_null"] isEqualToString:@"true"];
        argument.cArrayOfVariableLength = [[attributeDict objectForKey:@"c_array_of_variable_length"] isEqualToString:@"true"];
        argument.functionPointer = [[attributeDict objectForKey:@"function_pointer"] isEqualToString:@"true"];
        argument.signature = [attributeDict objectForKey:@"sel_of_type"];
        argument.signature64 = [attributeDict objectForKey:@"sel_of_type64"];
        argument.cArrayLengthInReturnValue = [[attributeDict objectForKey:@"c_array_length_in_retval"] isEqualToString:@"true"];
        argument.acceptsNull = ![[attributeDict objectForKey:@"null_accepted"] isEqualToString:@"false"];
        argument.acceptsPrintfFormat = [[attributeDict objectForKey:@"printf_format"] isEqualToString:@"true"];
        argument.alreadyRetained = [[attributeDict objectForKey:@"already_retained"] isEqualToString:@"true"];
        argument.type = [attributeDict objectForKey:@"type"];
        argument.type64 = [attributeDict objectForKey:@"type64"];
        argument.index = [[attributeDict objectForKey:@"index"] integerValue];
        
        id currentSymbol = [_symbolStack lastObject];
        if ([currentSymbol isKindOfClass:[MOBridgeSupportMethod class]]) {
            [(MOBridgeSupportMethod *)currentSymbol setReturnValue:argument];
        }
        else if ([currentSymbol isKindOfClass:[MOBridgeSupportFunction class]]) {
            [(MOBridgeSupportFunction *)currentSymbol setReturnValue:argument];
        }
        else if ([currentSymbol isKindOfClass:[MOBridgeSupportArgument class]]) {
            [(MOBridgeSupportArgument *)currentSymbol setReturnValue:argument];
        }
        
        [_symbolStack addObject:argument];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
#if PARSER_DEBUG
    NSLog(@"Parser didEndElement: %@", elementName);
#endif
    
    MOBridgeSupportSymbol *currentSymbol = [_symbolStack lastObject];
    if ([elementName isEqualToString:@"class"]) {
        // Class
        if ([currentSymbol isKindOfClass:[MOBridgeSupportClass class]]) {
            [_symbolStack removeLastObject];
        }
    }
    else if ([elementName isEqualToString:@"informal_protocol"]) {
        // Informal protocol
        if ([currentSymbol isKindOfClass:[MOBridgeSupportInformalProtocol class]]) {
            [_symbolStack removeLastObject];
        }
    }
    else if ([elementName isEqualToString:@"method"]) {
        // Method
        if ([currentSymbol isKindOfClass:[MOBridgeSupportMethod class]]) {
            [_symbolStack removeLastObject];
        }
    }
    else if ([elementName isEqualToString:@"function"]) {
        // Function
        if ([currentSymbol isKindOfClass:[MOBridgeSupportFunction class]]) {
            [_symbolStack removeLastObject];
        }
    }
    else if ([elementName isEqualToString:@"arg"]
             || [elementName isEqualToString:@"retval"]) {
        // Argument
        if ([currentSymbol isKindOfClass:[MOBridgeSupportArgument class]]) {
            [_symbolStack removeLastObject];
        }
    }
}

@end
