//
//  TDAssembly.h
//  TDParseKit
//
//  Created by Todd Ditchendorf on 7/13/08.
//  Copyright 2008 Todd Ditchendorf. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
    @class      TDAssembly 
    @brief      An Abstract class. A <tt>TDAssembly</tt> maintains a stream of language elements along with stack and target objects.
    @details    <p>Parsers use assemblers to record progress at recognizing language elements from assembly's string.</p>
                <p>Note that <tt>TDAssembly</tt> is an abstract class and may not be instantiated directly. Subclasses include <tt>TDTokenAssembly</tt> and <tt>TDCharAssembly</tt>.</p>
*/
@interface TDAssembly : NSObject <NSCopying> {
    NSMutableArray *stack;
    id target;
    NSUInteger index;
    NSString *string;
    NSString *defaultDelimiter;
}

/*!
    @brief      Convenience factory method for initializing an autoreleased assembly.
    @param      s string to be worked on
    @result     an initialized autoreleased assembly
*/
+ (id)assemblyWithString:(NSString *)s;

/*!
    @brief      Designated Initializer. Initializes an assembly with a given string.
    @details    Designated Initializer.
    @param      s string to be worked on
    @result     an initialized assembly
*/
- (id)initWithString:(NSString *)s;

/*!
    @brief      Shows the next object in the assembly, without removing it
    @details    Note this is not the next object in this assembly's stack, but rather the next object from this assembly's stream of elements (tokens or chars depending on the type of concrete <tt>TDAssembly</tt> subclass of this object).
    @result     the next object in the assembly.
*/
- (id)peek;

/*!
    @brief      Returns the next object in the assembly.
    @details    Note this is not the next object in this assembly's stack, but rather the next object from this assembly's stream of elements (tokens or chars depending on the type of concrete <tt>TDAssembly</tt> subclass of this object).
    @result     the next object in the assembly.
*/
- (id)next;

/*!
    @brief      Returns true if this assembly has unconsumed elements.
    @result     true, if this assembly has unconsumed elements
*/
- (BOOL)hasMore;

/*!
    @brief      Returns the elements of this assembly that have been consumed, separated by the specified delimiter.
    @param      delimiter string with which to separate elements of this assembly
    @result     string representing the elements of this assembly that have been consumed, separated by the specified delimiter
*/
- (NSString *)consumedObjectsJoinedByString:(NSString *)delimiter;

/*!
    @brief      Returns the elements of this assembly that remain to be consumed, separated by the specified delimiter.
    @param      delimiter string with which to separate elements of this assembly
    @result     string representing the elements of this assembly that remain to be consumed, separated by the specified delimiter
*/
- (NSString *)remainingObjectsJoinedByString:(NSString *)delimiter;

/*!
    @brief      Removes the object at the top of this assembly's stack and returns it.
    @details    Note this returns an object from this assembly's stack, not from its stream of elements (tokens or chars depending on the type of concrete <tt>TDAssembly</tt> subclass of this object).
    @result     the object at the top of this assembly's stack
*/
- (id)pop;

/*!
    @brief      Pushes an object onto the top of this assembly's stack.
    @param      object object to push
*/
- (void)push:(id)object;

/*!
    @brief      Returns true if this assembly's stack is empty.
    @result     true, if this assembly's stack is empty
*/
- (BOOL)isStackEmpty;

/*!
    @brief      Returns a vector of the elements on this assembly's stack that appear before a specified fence.
    @details    <p>Returns a vector of the elements on this assembly's stack that appear before a specified fence.</p>
                <p>Sometimes a parser will recognize a list from within a pair of parentheses or brackets. The parser can mark the beginning of the list with a fence, and then retrieve all the items that come after the fence with this method.</p>
    @param      fence object that indicates the limit of elements returned from this assembly's stack
    @result     Array of the elements above the specified fence
*/
- (NSArray *)objectsAbove:(id)fence;

/*!
    @property   length
    @brief      The number of elements in this assembly.
*/
@property (nonatomic, readonly) NSUInteger length;

/*!
    @property   objectsConsumed
    @brief      The number of elements that have been consumed.
*/
@property (nonatomic, readonly) NSUInteger objectsConsumed;

/*!
    @property   objectsRemaining
    @brief      The number of elements that have not been consumed
*/
@property (nonatomic, readonly) NSUInteger objectsRemaining;

/*!
    @property   defaultDelimiter
    @brief      The default string to show between elements
*/
@property (nonatomic, readonly, retain) NSString *defaultDelimiter;

/*!
    @property   stack
    @brief      This assembly's stack.
*/
@property (nonatomic, readonly, retain) NSMutableArray *stack;

/*!
    @property   target
    @brief      This assembly's target.
    @details    The object identified as this assembly's "target". Clients can set and retrieve a target, which can be a convenient supplement as a place to work, in addition to the assembly's stack. For example, a parser for an HTML file might use a web page object as its "target". As the parser recognizes markup commands like &lt;head>, it could apply its findings to the target.
*/
@property (nonatomic, retain) id target;
@end
