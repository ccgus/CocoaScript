// Originally Created by Guy English on 09-10-27.
// Hacked to pieces by Gus Mueller on 2010-07-30

#import <Cocoa/Cocoa.h>
#import <OpenCL/OpenCL.h>

@class COSOpenCLProgram;
@class JSTOpenCLBuffer;

@interface COSOpenCLContext : NSObject {
    
	cl_context computeContext;
	cl_command_queue computeCommands;
	cl_device_id computeDeviceId;
	cl_device_type computeDeviceType;
}

@property (readonly) cl_context computeContext;
@property (readonly) cl_command_queue computeCommands;
@property (readonly) cl_device_id computeDeviceId;
@property (readonly) cl_device_type computeDeviceType;

@property (readonly) NSUInteger maximumWorkItemDimensions;
@property (readonly) NSArray *maximumWorkItemSizes;
@property (readonly) NSUInteger maximum2DImageWidth;
@property (readonly) NSUInteger maximum2DImageHeight;

- (COSOpenCLProgram*)programWithSource:(NSString*)sourceCode;
- (JSTOpenCLBuffer*)bufferWithSize:(size_t)size attributes:(cl_bitfield) attribs;
- (JSTOpenCLBuffer*)bufferWithMemory:(void*)memory size:(size_t)size attributes:(cl_bitfield)attribs;

- (void)finish; // waits until all processing has finished

@end
