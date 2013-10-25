//
//  JSTDocumentController.m
//  jstalk
//
//  Created by August Mueller on 8/15/10.
//  Copyright 2010 Flying Meat Inc. All rights reserved.
//

#import "JSTDocumentController.h"
#import "JSTDocument.h"

@implementation JSTDocumentController

- (void)noteNewRecentDocument:(NSDocument *)document {
    if ([document isKindOfClass:[JSTDocument class]]) {
        [super noteNewRecentDocument:document];
    }
}

@end
