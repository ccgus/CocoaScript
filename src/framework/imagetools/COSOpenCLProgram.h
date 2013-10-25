//
//  KBOpenCLProgram.h
//  KBKit
//
//  Created by Guy English on 09-10-27.
//  Copyright 2009 Kickingbear. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "COSOpenCLContext.h"

@class JSTOpenCLKernel;

@interface COSOpenCLProgram : NSObject
{
	COSOpenCLContext *context;
	NSString *sourceCode;
	cl_program computeProgram;
	NSMutableDictionary *computeKernels;
}

- (id)initWithContext: (COSOpenCLContext*) theContext;

@property (readonly) COSOpenCLContext *context;
@property (copy) NSString *sourceCode;

- (void)build;
- (JSTOpenCLKernel*) createKernel: (NSString*) kernelName;
- (JSTOpenCLKernel*) kernelWithName: (NSString*) name;

@end

@interface JSTOpenCLBuffer : NSObject
{
	COSOpenCLContext *context;
	size_t size;
	cl_bitfield attributes;
	cl_mem computeBuffer;
}

- (id)initWithContext: (COSOpenCLContext*) theContext memory: (void*) memory size: (size_t) theSize attributes: (cl_bitfield) theFlags;

@property (readonly) cl_bitfield attributes;
@property (readonly) cl_mem computeBuffer;
@property (readonly) size_t size;

- (void)readToMemory: (void*) array size: (size_t) readSize waitUntilDone: (BOOL) waitFlag;

@end




typedef float JSTOCLFloatPixelCo;

typedef struct _JSTOCLFloatPixel {

#ifdef __LITTLE_ENDIAN__
    JSTOCLFloatPixelCo b;
    JSTOCLFloatPixelCo g;
    JSTOCLFloatPixelCo r;
    JSTOCLFloatPixelCo a;
#else
    JSTOCLFloatPixelCo a;
    JSTOCLFloatPixelCo r;
    JSTOCLFloatPixelCo g;
    JSTOCLFloatPixelCo b;
#endif
} JSTOCLFloatPixel;





@interface COSOpenCLImageBuffer : JSTOpenCLBuffer {
    
    size_t _width;
    size_t _height;
    
    size_t _bytesPerRow;
    
    cl_float4 *_bitmapData;
}

@property (readonly) size_t width;
@property (readonly) size_t height;
@property (readonly) cl_float4 *bitmapData;
@property (readonly) size_t bytesPerRow;

- (id)initWithContext:(COSOpenCLContext*)theContext width:(size_t)w height:(size_t)h;

- (id)initWithContext:(COSOpenCLContext*)theContext usingImageAtPath:(NSString*)path;


@end






@interface JSTOpenCLKernel : NSObject
{
	COSOpenCLProgram *program;
	cl_kernel computeKernel;
	size_t workGroupSize;
}

- (id)initWithProgram: (COSOpenCLProgram*) theProgram;

@property (readonly) cl_kernel computeKernel;
@property (readonly) size_t workGroupSize;

- (void)setArgument: (cl_uint) argIndex size: (size_t) argumentSize value: (void*) value;
- (void)setArgument: (cl_uint) argIndex buffer: (JSTOpenCLBuffer*) buffer;
//- (void)setArgument: (cl_uint) argIndex int:(size_t)v;


- (void)enqueueCallWithDimensions: (cl_uint) workDimension globalSizes: (const size_t*) globalWorkSize localSizes: (const size_t*) localWorkSize;

@end
