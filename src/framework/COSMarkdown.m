//
//  COSMarkdown.m
//  Cocoa Script
//
//  Created by August Mueller on 7/25/14.
//
//

#import "COSMarkdown.h"
#import "libMultiMarkdown.h"

@implementation COSMarkdown



+ (NSString*)convertStringToMarkdown:(NSString*)s {
    return [self convertStringToMarkdown:s usingFlags:EXT_NOTES];
}

+ (NSString*)convertStringToMarkdown:(NSString*)s usingFlags:(unsigned long)flags {
    
    const char *c = [s cStringUsingEncoding:NSUTF8StringEncoding];
    
    char *ret = markdown_to_string((char*)c, flags, HTML_FORMAT);
    
    return [NSString stringWithCString:ret encoding:NSUTF8StringEncoding];
    
}




@end
