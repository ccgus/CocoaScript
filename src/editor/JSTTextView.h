//
//  JSTTextView.h
//  jstalk
//
//  Created by August Mueller on 1/18/09.
//  Copyright 2009 Flying Meat Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class NoodleLineNumberView;

typedef NS_ENUM(NSUInteger, JSTTextViewTheme) {
    JSTTextViewThemeLight = 0,
    JSTTextViewThemeDark,
    JSTTextViewThemeDefault = JSTTextViewThemeLight,
};

typedef void (^JSTTextViewDragHandler)(NSTextView *draggedObject, NSString *draggedLine);

@interface JSTTextView : NSTextView <NSTextStorageDelegate> {
    NSDictionary            *_keywords;
    NSString                *_lastAutoInsert;
    NSSet                   *_ignoredSymbols;
}


@property (retain) NSDictionary *keywords;
@property (retain) NSString *lastAutoInsert;
@property (retain) NSSet *ignoredSymbols;
@property (copy) JSTTextViewDragHandler numberDragHandler; // will be called continuously as a number is dragged

- (void)parseCode:(id)sender;
- (JSTTextViewTheme) theme;
- (void)setTheme:(JSTTextViewTheme)theme;

@end
