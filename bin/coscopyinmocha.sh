#!/bin/bash

# there's a lot of gus specific stuff in here.
SRC_DIR=`cd ${0%/*}/..; pwd`

MOCHA_DIR=`cd ${0%/*}/../../Mocha; pwd`

COS_MOCHA_DIR=`cd ${0%/*}/../src/framework/mocha; pwd`

echo $MOCHA_DIR

echo $COS_MOCHA_DIR

function coscp {
    echo cp $*
    cp $*
}

function fixStrings {
    
    for i in $*; do 
    
        sed -e "s#\#import <Mocha/MochaDefines.h>#\#import \"MochaDefines.h\"#g" \
            -e "s#\#import <Mocha/MORuntime.h>#\#import \"MORuntime.h\"#g" \
            -e "s#\#import <Mocha/MOJavaScriptObject.h>#\#import \"MOJavaScriptObject.h\"#g" \
            -e "s#\#import <Mocha/MOMethod.h>#\#import \"MOMethod.h\"#g" \
            -e "s#\#import <Mocha/MOStruct.h>#\#import \"MOStruct.h\"#g" \
            -e "s#\#import <Mocha/MOUndefined.h>#\#import \"MOUndefined.h\"#g" \
            -e "s#\#import <Mocha/MOWeak.h>#\#import \"MOWeak.h\"#g" \
            -e "s#\#import <Mocha/MOPointer.h>#\#import \"MOPointer.h\"#g" \
            $i > /tmp/foo.copymochastuff
        
        mv /tmp/foo.copymochastuff $i
        
    done
    

}


coscp $MOCHA_DIR/Mocha/*.h $MOCHA_DIR/Mocha/*.m $COS_MOCHA_DIR/.

coscp $MOCHA_DIR/Mocha/BridgeSupport/*.h $MOCHA_DIR/Mocha/BridgeSupport/*.m $COS_MOCHA_DIR/BridgeSupport/.

coscp $MOCHA_DIR/Mocha/Categories/*.h $MOCHA_DIR/Mocha/Categories/*.m $COS_MOCHA_DIR/Categories/.

coscp $MOCHA_DIR/Mocha/Invocation/*.h $MOCHA_DIR/Mocha/Invocation/*.m $COS_MOCHA_DIR/Invocation/.

coscp $MOCHA_DIR/Mocha/Objects/*.h $MOCHA_DIR/Mocha/Objects/*.m $COS_MOCHA_DIR/Objects/.

coscp $MOCHA_DIR/Mocha/Runtime/*.h $MOCHA_DIR/Mocha/Runtime/*.m $COS_MOCHA_DIR/Runtime/.

fixStrings $COS_MOCHA_DIR/*.h
fixStrings $COS_MOCHA_DIR/*.m

fixStrings $COS_MOCHA_DIR/BridgeSupport/*.h
fixStrings $COS_MOCHA_DIR/BridgeSupport/*.m

fixStrings $COS_MOCHA_DIR/Categories/*.h
fixStrings $COS_MOCHA_DIR/Categories/*.m

fixStrings $COS_MOCHA_DIR/Invocation/*.h
fixStrings $COS_MOCHA_DIR/Invocation/*.m

fixStrings $COS_MOCHA_DIR/Objects/*.h
fixStrings $COS_MOCHA_DIR/Objects/*.m

fixStrings $COS_MOCHA_DIR/Runtime/*.h
fixStrings $COS_MOCHA_DIR/Runtime/*.m
