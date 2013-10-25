//
//  JSTCIImageAdditions.h
//  ImageTools
//
//  Created by August Mueller on 4/3/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

@interface CIImage (COSCIImageAdditions)

+ (id)cosImageNamed:(NSString*)imageName;

@end
