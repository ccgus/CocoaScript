#!/bin/bash

# there's a lot of gus specific stuff in here.
SRC_DIR=`cd ${0%/*}/..; pwd`
startDate=`/bin/date`
revision=""
upload=1
ql=1
appStoreSettings=""
archFlags=""
appStore=0
checkout=1


while getopts e:nr:st option
do
        case "${option}"
        in      
            e)
                echoversion=${OPTARG}
                ;;
            n)
                upload=0
                    ;;
            r)
                revision="-r ${OPTARG}"
                upload=0
                ;;
            s)
                appStore=1
                upload=0
                appStoreSettings="-xcconfig AppStore.xcconfig"
                #echo 'CODE_SIGN_IDENTITY=3rd Party Mac Developer Application: Flying Meat Inc.' > AppStore.xcconfig
                echo "OTHER_CFLAGS=-DMAC_APP_STORE" > AppStore.xcconfig
                ;;
            t)
                echo "USING LOCAL TREE"
                checkout=0
                ;;
            
            \?) usage
                echo "invalid option: $1" 1>&2
                exit 1
            ;;
        esac
done

function signPath {
    echo "Developer ID sign $1"
    /usr/bin/codesign -f -s "Developer ID Application: Flying Meat Inc." "$1"
}


if [ "$echoversion" != "" ]; then
    version=$echoversion
    
    # this is for gus to make distributions with.
    
    echo "cd ~/coscript/download/"
    echo "cp CocoaScriptPreview.zip CocoaScript-$version.zip"
    echo "rm CocoaScript.zip; ln -s CocoaScript-$version.zip CocoaScript.zip"
    
    exit
fi


buildDate=`/bin/date +"%Y.%m.%d.%H"`

if [ ! -d  ~/cvsbuilds ]; then
    mkdir ~/cvsbuilds
fi

echo cleaning.
rm -rf ~/cvsbuilds/CocoaScript*
rm -rf /tmp/coscript

source ~/.bash_profile
v=`date "+%s"`

if [ $checkout == 1 ]; then

    cd /tmp
    
    echo "doing remote checkout ($revision) upload($upload)"
    git clone git://github.com/ccgus/CocoaScript.git coscript
else
    echo "Copying local tree"
    cp -r $SRC_DIR /tmp/coscript
fi

cd /tmp/coscript

echo setting build id
sed -e "s/BUILDID/$v/g"  res/Info.plist > res/Info.plist.tmp
mv res/Info.plist.tmp res/Info.plist



xcodebuild=/usr/bin/xcodebuild
function buildTarget {
    
    echo Building "$1"
    
    $xcodebuild -target "$1" -configuration Release OBJROOT=/tmp/coscript/build SYMROOT=/tmp/coscript/build $appStoreSettings
    
    if [ $? != 0 ]; then
        echo "****** Bad build for $1 ********"
        say "Bad build for $1"
        
    fi
}


buildTarget "Cocoa Script Framework"
buildTarget "coscript tool"
buildTarget "Cocoa Script Editor"

# cd /tmp/jstalk/plugins/sqlite-fmdb-jstplugin
# $xcodebuild -configuration Release OBJROOT=/tmp/jstalk/build SYMROOT=/tmp/jstalk/build OTHER_CFLAGS="" -target fmdbextra
# if [ $? != 0 ]; then
#     echo "****** Bad build for fmdb extra ********"
#     exit
# fi

cd /tmp/coscript/build/Release/

# mkdir -p /tmp/coscript/build/Release/Cocoa\ Script\ Editor.app/Contents/Library/Automator
# mv /tmp/coscript/build/Release/JSTalk.action /tmp/coscript/build/Release/Cocoa\ Script\ Editor.app/Contents/Library/Automator/.

if [ ! -d  ~/cvsbuilds ]; then
    mkdir ~/cvsbuilds
fi


mkdir CocoaScriptFoo

mv coscript CocoaScriptFoo/.
mv "Cocoa Script Editor.app" CocoaScriptFoo/.

mv /tmp/coscript/examples CocoaScriptFoo/.

# I do a cp here, since I rely on this framework being here for other builds...
#cp -R JSTalk.framework CocoaScriptFoo/.
#cp -R /tmp/coscript/example_scripts CocoaScriptFoo/examples
#cp -R /tmp/coscript/plugins/sqlite-fmdb-jstplugin/fmdb.jstalk CocoaScriptFoo/examples/.

#mkdir CocoaScriptFoo/plugins
#mkdir -p CocoaScriptFoo/Cocoa\ Script\ Editor.app/Contents/PlugIns

# cp -r JSTalk.acplugin       CocoaScriptFoo/plugins/.
# cp -r JSTalk.vpplugin       CocoaScriptFoo/plugins/.
# cp -r FMDB.jstplugin        CocoaScriptFoo/JSTalk\ Editor.app/Contents/PlugIns/.
# cp -r ImageTools.jstplugin  CocoaScriptFoo/JSTalk\ Editor.app/Contents/PlugIns/.
# cp -r GTMScriptRunner.jstplugin CocoaScriptFoo/JSTalk\ Editor.app/Contents/PlugIns/.


mv CocoaScriptFoo CocoaScript

mv CocoaScript ~/cvsbuilds/.

cd ~/cvsbuilds

signPath CocoaScript/Cocoa\ Script\ Editor.app/Contents/Frameworks/CocoaScript.framework
signPath CocoaScript/Cocoa\ Script\ Editor.app


ditto -c -k --sequesterRsrc --keepParent CocoaScript CocoaScript.zip

rm -rf CocoaScript

cp CocoaScript.zip $v-CocoaScript.zip


if [ $upload == 1 ]; then
    echo uploading to server...
    
    #downloadDir=latest
    
    scp ~/cvsbuilds/CocoaScript.zip gus@elvis.mu.org:~/jstalk/download/CocoaScriptPreview.zip
    #scp /tmp/jstalk/res/jstalkupdate.xml gus@elvis.mu.org:~/fm/download/$downloadDir/.
    #scp /tmp/jstalk/res/shortnotes.html gus@elvis:~/fm/download/$downloadDir/jstalkshortnotes.html
fi

say "done building"

endDate=`/bin/date`
echo Start: $startDate
echo End:   $endDate

echo "(That was version $v)"
