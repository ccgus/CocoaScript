//
//  JSTCIImageAdditions.m
//  ImageTools
//
//  Created by August Mueller on 4/3/11.
//  Copyright 2011 Flying Meat Inc. All rights reserved.
//

#import "COSCIImageAdditions.h"
#import "COSImageTools.h"

@implementation CIImage (COSCIImageAdditions)

+ (id)jstImageNamed:(NSString*)imageName {
    return [self cosImageNamed:imageName];
}

+ (id)cosImageNamed:(NSString*)imageName {
    
    NSURL *url = [[NSBundle bundleForClass:[COSImageTools class]] URLForImageResource:imageName];
    
    if (!url) {
       url = [[NSBundle mainBundle] URLForImageResource:imageName];
    }
    
    if (!url) {
        return 0x00;
    }
    
    return [CIImage imageWithContentsOfURL:url];
    
}

@end
