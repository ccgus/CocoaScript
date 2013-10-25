//
//  JSTOpenCLProgram.m
//  TSKit
//
//  Created by Guy English on 09-10-27.
//  Copyright 2009 Kickingbear. All rights reserved.
//

#import "COSOpenCLProgram.h"

@interface NSObject (JSTalkPrintController)
- (id)printController;
@end

static int FloorPow2(int n);

@interface JSTOpenCLKernel ()
@property (readwrite) cl_kernel computeKernel;
@property (readwrite) size_t workGroupSize;
@end

@implementation COSOpenCLProgram


- (id)initWithContext: (COSOpenCLContext*) theContext {
	self = [super init];
	if ( !self ) return nil;
	
	context = theContext;
	computeKernels = [[NSMutableDictionary alloc] init];
	
	return self;
}

- (void)dealloc;
{
	clReleaseProgram( computeProgram );
}

- (void)build;
{
	int err = 0;
	if ( computeProgram == 0 )
	{
		const char *source = [self.sourceCode UTF8String];
		
		computeProgram = clCreateProgramWithSource( context.computeContext, 1, (const char **) & source, NULL, &err);
		if (!computeProgram || err != CL_SUCCESS)
		{
			NSLog( @"Error: Failed to create compute program! %d", err);
			return;
		}
	}
	
    err = clBuildProgram(computeProgram, 0, NULL, NULL, NULL, NULL);
    if (err != CL_SUCCESS)
    {
        size_t len;
        char buffer[2048];
		
        NSLog( @"Error: Failed to build program executable!" );
        clGetProgramBuildInfo( computeProgram, context.computeDeviceId, CL_PROGRAM_BUILD_LOG, sizeof(buffer), buffer, &len);
        
        id jstalk = [[[NSThread currentThread] threadDictionary] objectForKey:@"org.jstalk.currentJSTalkContext"];
        if (jstalk) {
            
            [[jstalk printController] print:[NSString stringWithFormat:@"%s", buffer]];
        }
        
        
        NSLog( @"%s\n", buffer );
		return;
    }
}

- (JSTOpenCLKernel*) createKernel: (NSString*) kernelName;
{
	int err = 0;
	JSTOpenCLKernel *kernelInfo = [[JSTOpenCLKernel alloc] initWithProgram: self];
	
	kernelInfo.computeKernel = clCreateKernel(computeProgram, [kernelName UTF8String], &err);
	if (!kernelInfo.computeKernel || err != CL_SUCCESS)
	{
		NSLog( @"Error: Failed to create compute kernel!" );
		return nil;
	}
    
	// Get the maximum work group size for executing the kernel on the device
	//
	size_t max = 1;
	err = clGetKernelWorkGroupInfo( kernelInfo.computeKernel, context.computeDeviceId, CL_KERNEL_WORK_GROUP_SIZE, sizeof(size_t), &max, NULL);
	if (err != CL_SUCCESS)
	{
		NSLog( @"Error: Failed to retrieve kernel work group info! %d", err);
		return nil;
	}
	
	kernelInfo.workGroupSize = (max > 1) ? (size_t)FloorPow2((int)max) : max;  // use nearest power of two (less than max)
	
	[computeKernels setObject: kernelInfo forKey: kernelName];

	return kernelInfo;
}

- (JSTOpenCLKernel*) kernelWithName: (NSString*) name;
{
	return [computeKernels objectForKey: name];
}

@synthesize context;
@synthesize sourceCode;

@end

static int FloorPow2(int n)
{
    int exp;
    frexp((float)n, &exp);
    return 1 << (exp - 1);
}

@implementation JSTOpenCLBuffer

@synthesize attributes;
@synthesize computeBuffer;
@synthesize size;

- (id)initWithContext: (COSOpenCLContext*)theContext memory:(void*)memory size:(size_t)theSize attributes:(cl_bitfield)theFlags {
	self = [super init];
	if (!self) {
        return nil;
    }
	
	context = theContext;
	size = theSize;
	attributes = theFlags;
	
	int err = 0;
	computeBuffer = clCreateBuffer(context.computeContext, attributes, size, memory, &err);
	if (!computeBuffer) {
		NSLog( @"clCreateBuffer failed: %d", err );
		return nil;
	}

	return self;
}


- (void)readToMemory:(void*)array size:(size_t)readSize waitUntilDone:(BOOL)waitFlag {
	int err = 0;
	BOOL block = waitFlag?CL_TRUE:CL_FALSE;
	err = clEnqueueReadBuffer( context.computeCommands, computeBuffer, block, 0, 
							  readSize, 
							  array, 0, NULL, NULL );      
	if (err)  {
		NSLog( @"clEnqueueReadBuffer failed: %d", err );
	}
}

- (void)dealloc {
	clReleaseMemObject( computeBuffer );
}


@end


@implementation COSOpenCLImageBuffer


@synthesize width=_width;
@synthesize height=_height;
@synthesize bitmapData=_bitmapData;
@synthesize bytesPerRow=_bytesPerRow;


+ (id)instanceWithContext:(COSOpenCLContext*)theContext width:(size_t)w height:(size_t)h {
    return [[self alloc] initWithContext:theContext width:w height:h];
}

- (id)initWithContext:(COSOpenCLContext*)theContext width:(size_t)w height:(size_t)h {
    
    self = [super init];
	if (!self) {
        return nil;
    }
	
	context = theContext;
	attributes = CL_MEM_READ_WRITE|CL_MEM_USE_HOST_PTR;
	
    _width = w;
    _height = h;
    
    size_t bpp = sizeof(float) * 4; // should be 16
    assert(sizeof(float) * 4 == 16); // YES IT SHOULD BE DAMNIT AND WE'LL MAKE SURE OF THIS.
    
    // make everything happily aligned
    _bytesPerRow = (_width * bpp + 15) & ~15;
    while (0 == (_bytesPerRow & (_bytesPerRow - 1))) {
        _bytesPerRow += 16;
    }
    
    size = _bytesPerRow * _height;
    _bitmapData = calloc(1, size);
    
    NSLog(@"allocating %ld bytes", size);
    
    if (!_bitmapData) {
        NSLog(@"%s:%d", __FUNCTION__, __LINE__);
		NSLog(@"creating the bitmap data failed!");
		return nil;
    }
    
    
    int err = 0;
    
    cl_image_format format;
    format.image_channel_order = CL_RGBA;
    format.image_channel_data_type = CL_FLOAT;
    
    cl_image_desc imageDescription;
    imageDescription.image_type = CL_MEM_OBJECT_IMAGE2D;
    imageDescription.image_width = _width;
    imageDescription.image_height = _height;
    imageDescription.image_array_size = 1;
    imageDescription.image_row_pitch = _bytesPerRow;
    imageDescription.image_slice_pitch = _height;
    imageDescription.num_mip_levels = 0;
    imageDescription.num_samples = 0;
    imageDescription.image_depth = 0;
    
    computeBuffer = clCreateImage(context.computeContext, attributes, &format, &imageDescription, _bitmapData, &err);
    
    if (!computeBuffer) {
        NSLog(@"%s:%d", __FUNCTION__, __LINE__);
		NSLog(@"clCreateBuffer failed: %d", err);
		return nil;
	}
    
    return self;
}

+ (id)instanceWithContext:(COSOpenCLContext*)theContext usingImageAtPath:(NSString*)path {
    return [[self alloc] initWithContext:theContext usingImageAtPath:path];
}

- (id)initWithContext:(COSOpenCLContext*)theContext usingImageAtPath:(NSString*)path {
    
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL fileURLWithPath:path], nil);
    
    if (!imageSourceRef) {
        NSLog(@"Could not turn the file into an image");
        return nil;
    }
    
    
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(imageSourceRef, 0, (__bridge CFDictionaryRef)[NSDictionary dictionary]);
    
    _width = CGImageGetWidth(imageRef);
    _height = CGImageGetHeight(imageRef);
    
    debug(@"_width: %ld", _width);
    debug(@"_height: %ld", _height);
    
    
    self = [self initWithContext:theContext width:_width height:_height];
	if (!self) {
        CFRelease(imageRef);
        CFRelease(imageSourceRef);
        return nil;
    }
    
    
    CFRelease(imageSourceRef);
    
    CGColorSpaceRef cs = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGBLinear);
    
    CGContextRef bcontext = CGBitmapContextCreate(_bitmapData, _width, _height, 32, _bytesPerRow, cs, kCGBitmapFloatComponents | kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Host);
    
    if (!bcontext) {
        NSLog(@"Could not create a context for drawing");
        CFRelease(imageRef);
        return nil;
    }
	
    CGContextSetBlendMode(bcontext, kCGBlendModeCopy);
    CGContextDrawImage(bcontext, CGRectMake(0, 0, _width, _height), imageRef);
    
    CGContextRelease(bcontext);
    CFRelease(imageRef);
    
    debug(@"hurray!");
    
    debug(@"[self width]: %ld", [self width]);
    
    return self;
}


- (void)dealloc {
    
    if (_bitmapData) {
        free(_bitmapData);
    }
}

@end


@implementation  JSTOpenCLKernel

- (id)initWithProgram:(COSOpenCLProgram*) theProgram {
	self = [super init];
	if (!self) {
        return nil;
    }
	
	program = theProgram;
	
	return self;
}

- (void)dealloc {
	clReleaseKernel(computeKernel);
}


@synthesize computeKernel;
@synthesize workGroupSize;

- (void)setIntArgumentAtIndex:(cl_uint)argIndex value:(int32_t)val {
    [self setArgument:argIndex size:sizeof(int32_t) value:&val];
}

- (void)setInt2ArgumentAtIndex:(cl_uint)argIndex x:(int32_t)x y:(int32_t)y {
    cl_int2 junk = { x, y };
    [self setArgument:argIndex size:sizeof(cl_int2) value:&junk];
}

- (void)setArgument:(cl_uint)argIndex size:(size_t)argumentSize value:(void*)value {
	clSetKernelArg(computeKernel, argIndex, argumentSize, value);
}

- (void)setArgument:(cl_uint)argIndex buffer:(JSTOpenCLBuffer*)buffer {
	cl_mem computeBuffer = buffer.computeBuffer;
	[self setArgument:argIndex size:sizeof(cl_mem) value:&computeBuffer];
}

- (void)enqueueCallWithDimensions:(cl_uint)workDimension globalSizes:(const size_t*)globalWorkSize localSizes:(const size_t*)localWorkSize {
    clEnqueueNDRangeKernel(program.context.computeCommands, computeKernel, workDimension, NULL, globalWorkSize, localWorkSize, 0, NULL, NULL);
}

- (void)enqueueCallWithGlobalSizeX:(size_t)x Y:(size_t)y {
    
    size_t global[2];
    size_t local[2] = {1,1};
    
    global[0] = x;
    global[1] = y;
    
    cl_uint workDimension = 2;
    
    clEnqueueNDRangeKernel(program.context.computeCommands, computeKernel, workDimension, NULL, global, local, 0, NULL, NULL);
}



- (void)foo {
    
    //clCreateImage2D
    //CL_FLOAT
    
    //memobjs[0] = clCreateBuffer(context, CL_MEM_READ_ONLY | CL_MEM_USE_HOST_PTR, sizeof(cl_float4) * n, srcA, NULL);
    
    //memobjs[2] = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(cl_float) * n, NULL, NULL);
    
}


@end
