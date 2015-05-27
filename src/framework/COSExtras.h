
#import <Cocoa/Cocoa.h>


@interface NSApplication (COSExtras)
- (id)open:(NSString*)pathToFile;
@end

@interface NSString (JSTExtras)

+ (id)stringWithUUID;

@end