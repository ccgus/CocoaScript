#!/bin/bash

SRC_DIR=`cd ${0%/*}/..; pwd`
# cd $SRC_DIR/src/framework/imagetools

gen_bridge_metadata -c '-I. -I/Volumes/mp/Applications/Xcode6-Beta7.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/System/Library/Frameworks/Foundation.framework/Headers/ -I /Volumes/mp/Applications/Xcode6-Beta7.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/usr/include' src/framework/imagetools/COSImageTools.h -o CocoaScript.bridgesupport

SDK='/Volumes/mp/Applications/Xcode6-Beta7.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk'

#gen_bridge_metadata -c '-I. --framework Foundation -I /Volumes/mp/Applications/Xcode6-Beta7.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.10.sdk/usr/include' --framework /builds/Cocoa_Script-ffvatjthjqgjsfailwkikjdzqpdl/Build/Products/Debug/CocoaScript.framework -o CocoaScript.bridgesupport

# gen_bridge_metadata -f /builds/Cocoa_Script-ffvatjthjqgjsfailwkikjdzqpdl/Build/Products/Debug/CocoaScript.framework -o CocoaScript.bridgesupport

# gen_bridge_metadata -c