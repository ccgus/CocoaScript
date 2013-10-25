//
//  JSTQuickCIFilter.m
//  CIOpenCLTools
//
//  Created by August Mueller on 8/4/10.
//  Copyright 2010 Flying Meat Inc. All rights reserved.
//

#import "COSQuickCIFilter.h"

#pragma message "FIXME: Gus- you can get CI kernel errors like so: http://stackoverflow.com/questions/13754997/how-do-you-debug-syntax-errors-in-a-core-image-kernel"
/*
 If you use introspection on the CIKernel class, you will find a kernelsWithString:messageLog: method. There is no public interface to it, but don't let that stop you…
 
 NSString *myCode = ...
 NSMutableArray *messageLog = [NSMutableArray array];
 NSArray *kernels = [[CIKernel class] performSelector:@selector(kernelsWithString:messageLog:) withObject:myCode withObject:messageLog];
 if ( messageLog.count > 0) NSLog(@"Error: %@", messageLog.description);
 The messageLog argument wants to be a mutable array. In the event of errors, it will have some dictionaries put into it. The contents of these are documented nowhere visible on the internet, but they look something like this (in a case where I added "gratuitous error" to a kernel's source)…
 
 2012-12-06 17:56:53.077 MyProgram[14334:303] Error: (
 {
 CIKernelMessageDescription = "kernel vec4 clipDetection (uniform in sampler, uniform in float)";
 CIKernelMessageLineNumber = 8;
 CIKernelMessageType = CIKernelMessageTypeFunctionName;
 },
 {
 CIKernelMessageDescription = "unknown variable name: gratuitous";
 CIKernelMessageLineNumber = 8;
 CIKernelMessageType = CIKernelMessageTypeError;
 }
 )
 As always, think twice or more about leaving this in shipping code. It is undocumented and Apple could do anything to it at any time. They might even, you know, document it.
 

 */

@implementation COSQuickCIFilter

+ (id)quickFilterWithKernel:(NSString*)kernel {
    
    COSQuickCIFilter *f = [COSQuickCIFilter new];
    
    [f setTheKernel:[[CIKernel kernelsWithString:kernel] objectAtIndex:0]];
    [f setKernelArgs:[NSMutableArray array]];
    return f;
}

- (CGRect)xregionOf:(int)sampler destRect:(CGRect)rect userInfo:(id)ui {
    return CGRectInfinite;
}

- (void)addKernelArgument:(id)obj {
    
    // Convenience stuff.
    if ([obj isKindOfClass:[NSColor class]]) {
        obj = [[CIColor alloc] initWithColor:obj];
    }
    else if ([obj isKindOfClass:[CIImage class]]) {
        obj = [CISampler samplerWithImage:obj];
    }
    
    [_kernelArgs addObject:obj];
}

- (CGRect)xxregionOf:(int)sampler destRect:(CGRect)rect userInfo:(id)ui {
    
    NSValue *v = [[COScript currentCOScript] callJSFunction:[_roiMethod JSObject] withArgumentsInArray:nil];
    
    return [v rectValue];
}

- (CIImage*)applyWithArguments:(NSArray *)args options:(NSDictionary *)dict {
    return [self apply:_theKernel arguments:args options:dict];
}

- (CIImage *)outputImage {
    
    if (_roiMethod && [COScript currentCOScript]) {
        [_theKernel setROISelector:@selector(regionOf:destRect:userInfo:)];
    }
    
    if (_outputImageMethod && [COScript currentCOScript]) {
        CIImage *i = [[COScript currentCOScript] callJSFunction:[_outputImageMethod JSObject] withArgumentsInArray:nil];
        return i;
    }
    
	return [self apply:_theKernel arguments:_kernelArgs options:[NSDictionary dictionary]];
}

@end
