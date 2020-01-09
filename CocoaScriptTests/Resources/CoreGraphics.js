//
//  CoreGraphics.js
//  UnitTests
//
//  Created by Logan Collins on 7/25/12.
//  Copyright (c) 2012 Sunflower Softworks. All rights reserved.
//

function main() {
    var fm = NSFileManager.alloc().init();
    
    var url = NSURL.fileURLWithPath_("/tmp/foo.pdf");
    fm.removeItemAtURL_error_(url, null);
    
    var rect = CGRectMake(0.0, 0.0, 100.0, 100.0);
    var rectPtr = MOPointer.alloc().initWithValue_(rect);
    var c = CGPDFContextCreateWithURL(url, rect, null);
    
    CGPDFContextBeginPage(c, null);
    
    var redColor = CGColorCreateGenericRGB(1.0, 0.0, 0.0, 1.0);
    CGContextSetFillColorWithColor(c, redColor);
    CGContextFillRect(c, NSMakeRect(0.0, 0.0, 50.0, 50.0));
    CGColorRelease(redColor);
    
    var greenColor = CGColorCreateGenericRGB(0.0, 1.0, 0.0, 1.0);
    CGContextSetFillColorWithColor(c, redColor);
    CGContextFillRect(c, NSMakeRect(50.0, 0.0, 25.0, 50.0));
    CGColorRelease(greenColor);
    
    var blueColor = CGColorCreateGenericRGB(0.0, 0.0, 1.0, 1.0);
    CGContextSetFillColorWithColor(c, redColor);
    CGContextFillRect(c, NSMakeRect(25.0, 25.0, 25.0, 25.0));
    CGColorRelease(blueColor);
    
    CGPDFContextEndPage(c);
    
    CGPDFContextClose(c);
    CGContextRelease(c);
    
    return [true, null];
}
