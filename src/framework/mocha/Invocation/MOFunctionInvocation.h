//
//  MOFunctionInvocation.h
//  Mocha
//
//  Created by Logan Collins on 12/9/13.
//  Copyright (c) 2013 Sunflower Softworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>


JSValueRef MOFunctionInvoke(id function, JSContextRef ctx, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception);
JSValueRef MOSelectorInvoke(id target, SEL selector, JSContextRef ctx, size_t argumentCount, const JSValueRef arguments[], JSValueRef *exception);
