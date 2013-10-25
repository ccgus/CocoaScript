//
//  JSTTextView.h
//  jstalk
//
//  Created by August Mueller on 1/18/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NoodleLineNumberView;

typedef void (^JSTTextViewDragHandler)(NSTextView *draggedObject, NSString *draggedLine);

@interface JSTTextView : NSTextView <NSTextStorageDelegate> {
    NSDictionary            *_keywords;
    
    NSString                *_lastAutoInsert;
}


@property (retain) NSDictionary *keywords;
@property (retain) NSString *lastAutoInsert;
@property (copy) JSTTextViewDragHandler numberDragHandler; // will be called continuously as a number is dragged

- (void)parseCode:(id)sender;

@end
