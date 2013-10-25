#import "COSOpenCLContext.h"
#import "COSOpenCLProgram.h"

@interface COSOpenCLContext ()
- (BOOL)setupContext;
@end

@implementation COSOpenCLContext

@synthesize computeContext;
@synthesize computeCommands;
@synthesize computeDeviceId;
@synthesize computeDeviceType;

- (id)init {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if ([self setupContext] == NO) {
        return nil;
    }
    
    return self;
}

- (void)dealloc {
    clReleaseCommandQueue(computeCommands);
}

- (BOOL)setupContext {
    
    int err = 0;

    computeDeviceType = CL_DEVICE_TYPE_CPU;
    
    err = clGetDeviceIDs(NULL, computeDeviceType, 1, &computeDeviceId, NULL);
    if (err != CL_SUCCESS) {
        NSLog( @"Error: Failed to locate compute device!" );
        return NO;
    }

    // Create a context containing the compute device(s)
    computeContext = clCreateContext(0, 1, &computeDeviceId, clLogMessagesToStdoutAPPLE, NULL, &err);
    if (!computeContext) {
        NSLog( @"Error: Failed to create a compute context!" );
        return NO;
    }

    unsigned int device_count;
    cl_device_id device_ids[16];
    size_t returned_size;

    err = clGetContextInfo(computeContext, CL_CONTEXT_DEVICES, sizeof(device_ids), device_ids, &returned_size);
    if(err) {
        NSLog( @"Error: Failed to retrieve compute devices for context!" );
        return NO;
    }

    device_count = (unsigned int)(returned_size / sizeof(cl_device_id));

    int i = 0;
    //int device_found = 0;
    cl_device_type device_type;    
    for(i = 0; i < device_count; i++) {
        clGetDeviceInfo(device_ids[i], CL_DEVICE_TYPE, sizeof(cl_device_type), &device_type, NULL);
        
        if(device_type == computeDeviceType) {
            computeDeviceId = device_ids[i];
            //device_found = 1;
            break;
        }    
    }

    // Create a command queue
    //
    computeCommands = clCreateCommandQueue(computeContext, computeDeviceId, 0, &err);
    if (!computeCommands) {
        NSLog( @"Error: Failed to create a command queue!" );
        return NO;
    }

    // Report the device vendor and device name
    // 
    cl_char vendor_name[1024] = {0};
    cl_char device_name[1024] = {0};
    err = clGetDeviceInfo(computeDeviceId, CL_DEVICE_VENDOR, sizeof(vendor_name), vendor_name, &returned_size);
    err|= clGetDeviceInfo(computeDeviceId, CL_DEVICE_NAME, sizeof(device_name), device_name, &returned_size);
    if (err != CL_SUCCESS) {
        NSLog( @"Error: Failed to retrieve device info!\n" );
        return NO;
    }

    //debug( @"Connecting to %s %s...\n", vendor_name, device_name );
    
    return YES;
}

- (COSOpenCLProgram*)programWithSource:(NSString*) sourceCode; {
    COSOpenCLProgram *program = [[COSOpenCLProgram alloc] initWithContext:self];
    program.sourceCode = sourceCode;
    return program;
}

- (JSTOpenCLBuffer*)bufferWithSize:(size_t) size attributes:(cl_bitfield)attribs {
    JSTOpenCLBuffer *buffer = [[JSTOpenCLBuffer alloc] initWithContext:self memory:NULL size:size attributes:attribs];
    return buffer;
}

- (JSTOpenCLBuffer*)bufferWithMemory:(void*)memory size:(size_t)size attributes:(cl_bitfield)attribs {
    JSTOpenCLBuffer *buffer = [[JSTOpenCLBuffer alloc] initWithContext: self memory:memory size:size attributes:attribs];
    return buffer;
}

- (void)finish { // waits until all processing has finished
    clFinish( computeCommands );
}


- (NSUInteger)maximumWorkItemDimensions {
    cl_uint maximumWorkItemDimensions;
    
    clGetDeviceInfo(computeDeviceId, CL_DEVICE_MAX_WORK_ITEM_DIMENSIONS, sizeof(cl_uint), &maximumWorkItemDimensions, NULL);
    
    return maximumWorkItemDimensions;
}

- (NSUInteger)maximum2DImageWidth {
    size_t width;
    
    clGetDeviceInfo(computeDeviceId, CL_DEVICE_IMAGE2D_MAX_WIDTH, sizeof(size_t), &width, NULL);
    
    return width;
}

- (NSUInteger)maximum2DImageHeight {
    size_t height;
    
    clGetDeviceInfo(computeDeviceId, CL_DEVICE_IMAGE2D_MAX_HEIGHT, sizeof(size_t), &height, NULL);
    
    return height;
}

- (NSArray*)maximumWorkItemSizes {
    NSUInteger numberOfDimensions = [self maximumWorkItemDimensions];
    size_t *sizes = malloc(numberOfDimensions * sizeof(cl_uint));
    
    clGetDeviceInfo(computeDeviceId, CL_DEVICE_MAX_WORK_GROUP_SIZE, numberOfDimensions * sizeof( size_t ), sizes, NULL);
    
    NSMutableArray *sizeArray = [NSMutableArray array];
    for ( NSInteger i = 0; i < numberOfDimensions; i++ ) {
        [sizeArray addObject: [NSNumber numberWithInteger: sizes[i]]];
    }
    
    free(sizes);
    return sizeArray;
}

@end
