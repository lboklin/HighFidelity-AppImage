#!/bin/bash
# Parts copied from or inspired by: 
# https://github.com/probonopd/AppImages/blob/master/recipes/scribus/Recipe

# Halt on errors
set -e

# Be verbose
#set -x

# Get the path of this script
pushd `dirname $0` > /dev/null
PACKAGING_DIR=$(pwd)
popd > /dev/null

# What to call the resulting appimage
APPIMAGE_NAME=HighFidelity-Interface-x86_64.AppImage

mkdir -p $PACKAGING_DIR/HighFidelity.AppDir

cd $PACKAGING_DIR/HighFidelity.AppDir/

# Directory hierarchy vars
APPDIR=$(pwd)
APPIMAGE_LIBS=$APPDIR/usr/lib/
APPIMAGE_BINS=$APPDIR/usr/bin/
PROJECT_EXT_LIBS=$PACKAGING_DIR/../ext/makefiles/ # External libraries that are included 

# Qt vars. Need to automate retrieving and using the right qt version, but until then 
# you must change the path to where you have Qt5.6 installed.
QT_DIR=/usr/local/Qt5.6.1/5.6/gcc_64/ 
QT_PLUGINS=$QT_DIR/plugins/

APPIMAGE_QT_DIR=$APPDIR/usr/lib/
APPIMAGE_QT_PLUGINS=$APPIMAGE_QT_DIR/qt5/plugins/

#export PATH=$QT_DIR:$PATH
#export LD_LIBRARY_LIBRARY_PATH=/usr/local/

printf "\nCleansing any pre-existing files..."

rm -rf $APPDIR/*

printf "Done.\n"

printf "\nCopying over what we need from the build directory..."

mkdir -p $APPIMAGE_BINS 

cp -Rt $APPIMAGE_BINS/ $PACKAGING_DIR/../interface/{interface,plugins,resources,scripts}

printf "Done.\n"


## QT

mkdir -p $APPIMAGE_LIBS

cd $APPIMAGE_LIBS

printf "\nPackaging Qt libraries..."

mkdir -p $APPIMAGE_QT_DIR/qml/QtQuick/
cp -R $QT_DIR/qml/QtQuick/ $APPIMAGE_QT_DIR/qml/QtQuick/

# This is inelegant. Any better way to do it?
#find $QT_DIR/lib/ -name "*.so*" -not -name "*.so.*.*" -exec cp -t $APPIMAGE_QT_DIR/ {} +

# This is more manual but safer. Let's not do it 
cp -t ./ $QT_DIR/lib/libQt5Core.so.5
cp -t ./ $QT_DIR/lib/libQt5DBus.so.5
cp -t ./ $QT_DIR/lib/libQt5Gui.so.5
cp -t ./ $QT_DIR/lib/libQt5Multimedia.so.5
cp -t ./ $QT_DIR/lib/libQt5Network.so.5
cp -t ./ $QT_DIR/lib/libQt5OpenGL.so.5
cp -t ./ $QT_DIR/lib/libQt5Qml.so.5
cp -t ./ $QT_DIR/lib/libQt5Quick.so.5
cp -t ./ $QT_DIR/lib/libQt5Script.so.5
cp -t ./ $QT_DIR/lib/libQt5ScriptTools.so.5
cp -t ./ $QT_DIR/lib/libQt5Svg.so.5
cp -t ./ $QT_DIR/lib/libQt5WebChannel.so.5
cp -t ./ $QT_DIR/lib/libQt5WebEngine.so.5
cp -t ./ $QT_DIR/lib/libQt5WebEngineCore.so.5
cp -t ./ $QT_DIR/lib/libQt5WebSockets.so.5
cp -t ./ $QT_DIR/lib/libQt5Widgets.so.5
cp -t ./ $QT_DIR/lib/libQt5XcbQpa.so.5
cp -t ./ $QT_DIR/lib/libQt5XmlPatterns.so.5
cp -t ./ $QT_DIR/lib/libicudata.so.56
cp -t ./ $QT_DIR/lib/libicui18n.so.56
cp -t ./ $QT_DIR/lib/libicuuc.so.56

printf "Done.\n"

printf "\nPackaging Qt plugins..."

mkdir -p $APPIMAGE_QT_PLUGINS

cd $APPIMAGE_QT_PLUGINS

cp -Rt ./ $QT_PLUGINS/bearer
cp -Rt ./ $QT_PLUGINS/iconengines
cp -Rt ./ $QT_PLUGINS/imageformats
cp -Rt ./ $QT_PLUGINS/platforminputcontexts
cp -Rt ./ $QT_PLUGINS/platforms
cp -Rt ./ $QT_PLUGINS/platformthemes || true # Not sure about this one
cp -Rt ./ $QT_PLUGINS/styles || true
cp -Rt ./ $QT_PLUGINS/sensors
cp -Rt ./ $QT_PLUGINS/xcbglintegrations

printf "Done.\n"

##


mkdir -p $APPIMAGE_LIBS/ext/

cd $APPIMAGE_LIBS/

printf "\nPackaging the project's included external libs..." 

#find $PACKAGING_DIR/../ext/ -regex "lib\(Bullet\(Collision\|Dynamics\)\|LinearMath\|steam_api\|PolyVoxCore\|tbb\)\.so.*" -type f exec cp -t $APPIMAGE_LIBS/ext/ {} +

cp -t ./ $PROJECT_EXT_LIBS/bullet/project/lib/libBulletDynamics.so.2.83
cp -t ./ $PROJECT_EXT_LIBS/bullet/project/lib/libBulletCollision.so.2.83
cp -t ./ $PROJECT_EXT_LIBS/bullet/project/lib/libLinearMath.so.2.83
cp -t ./ $PROJECT_EXT_LIBS/steamworks/project/src/steamworks/redistributable_bin/linux64/libsteam_api.so
cp -t ./ $PROJECT_EXT_LIBS/bullet/project/lib/libLinearMath.so.2.83
cp -t ./ $PROJECT_EXT_LIBS/polyvox/project/lib/Release/libPolyVoxCore.so.0
cp -t ./ $PROJECT_EXT_LIBS/tbb/project/src/tbb/lib/intel64/gcc4.4/libtbb.so.2

printf "Done.\n"

printf "\nPackaging dependencies from the system..."

cp -t ./ /lib/x86_64-linux-gnu/libjson-c.so.2
cp -t ./ /lib/x86_64-linux-gnu/libexpat.so.1
cp -t ./ /lib/x86_64-linux-gnu/libsystemd.so.0

cp /usr/lib/x86_64-linux-gnu/libKF5Style.so.5.29.0 ./libKF5Style.so.5 

#cp -t ./ /usr/lib/nvidia-367/libGLdispatch.so.0 

cp -t ./ /usr/lib/x86_64-linux-gnu/libFLAC.so.8
cp -t ./ /usr/lib/x86_64-linux-gnu/libXau.so.6
cp -t ./ /usr/lib/x86_64-linux-gnu/libXcomposite.so.1
cp -t ./ /usr/lib/x86_64-linux-gnu/libXcursor.so.1
cp -t ./ /usr/lib/x86_64-linux-gnu/libXdamage.so.1
cp -t ./ /usr/lib/x86_64-linux-gnu/libXdmcp.so.6
cp -t ./ /usr/lib/x86_64-linux-gnu/libXext.so.6
cp -t ./ /usr/lib/x86_64-linux-gnu/libXfixes.so.3
cp -t ./ /usr/lib/x86_64-linux-gnu/libXi.so.6
cp -t ./ /usr/lib/x86_64-linux-gnu/libXrender.so.1
cp -t ./ /usr/lib/x86_64-linux-gnu/libXtst.so.6
cp -t ./ /usr/lib/x86_64-linux-gnu/libasyncns.so.0
cp -t ./ /usr/lib/x86_64-linux-gnu/libffi.so.6
cp -t ./ /usr/lib/x86_64-linux-gnu/libfreetype.so.6
cp -t ./ /usr/lib/x86_64-linux-gnu/libgobject-2.0.so.0
cp -t ./ /usr/lib/x86_64-linux-gnu/libgthread-2.0.so.0
cp -t ./ /usr/lib/x86_64-linux-gnu/libicudata.so.55
cp -t ./ /usr/lib/x86_64-linux-gnu/libicuuc.so.55
cp -t ./ /usr/lib/x86_64-linux-gnu/libnspr4.so
#cp -t ./ /usr/lib/x86_64-linux-gnu/libnss3.so
#cp -t ./ /usr/lib/x86_64-linux-gnu/libnssutil3.so
cp -t ./ /usr/lib/x86_64-linux-gnu/libogg.so.0
cp -t ./ /usr/lib/x86_64-linux-gnu/libplc4.so
cp -t ./ /usr/lib/x86_64-linux-gnu/libplds4.so
cp -t ./ /usr/lib/x86_64-linux-gnu/libpulse.so.0
cp -t ./ /usr/lib/x86_64-linux-gnu/libquazip5.so.1
cp -t ./ /usr/lib/x86_64-linux-gnu/libsmime3.so
cp -t ./ /usr/lib/x86_64-linux-gnu/libsndfile.so.1
cp -t ./ /usr/lib/x86_64-linux-gnu/libstdc++.so.6
cp -t ./ /usr/lib/x86_64-linux-gnu/libvorbis.so.0
cp -t ./ /usr/lib/x86_64-linux-gnu/libvorbisenc.so.2
cp -t ./ /usr/lib/x86_64-linux-gnu/libxml2.so.2
cp -t ./ /usr/lib/x86_64-linux-gnu/libxslt.so.1
cp -t ./ /usr/lib/x86_64-linux-gnu/pulseaudio/libpulsecommon-8.0.so
cp -t ./ /usr/lib/x86_64-linux-gnu/libxcb.so.1
cp -t ./ /usr/lib/x86_64-linux-gnu/libxcb-glx.so.0


# Disable because I dunno if this is necessary. It was in the referenced recipe. Keeping it here just in case.
#cp $(ldconfig -p | grep libGLU.so.1 | cut -d ">" -f 2 | xargs) $APPIMAGE_LIBS/ || true # otherwise segfaults!?
#cp $(ldconfig -p | grep libEGL.so.1 | cut -d ">" -f 2 | xargs) $APPIMAGE_LIBS/ || true # Otherwise F23 cannot load the Qt platform plugin "xcb"
 #cp $(ldconfig -p | grep libxcb.so.1 | cut -d ">" -f 2 | xargs) $APPIMAGE_LIBS/ || true
## See excludefile for reason for commenting out
#cp $(ldconfig -p | grep libfreetype.so.6 | cut -d ">" -f 2 | xargs) $APPIMAGE_LIBS/ || true # For Fedora 20

#ldd $APPIMAGE_QT_PLUGINS/platforms/libqxcb.so | cut -d ">" -f 2 | cut -d \( -f 1 | sed -e 's/[ \t]//g' | xargs -I '{}' cp -v '{}' $APPIMAGE_LIBS || true

printf "Done.\n"

printf "\nRemoving dependencies and files that are not to be included..."

# Workaround for:
# relocation error: /tmp/.mount_gP4OX1/usr/lib/libQt5Widgets.so.5: symbol _ZN22QGuiApplicationPrivate20scrollNoPhaseAllowedE, version Qt_5_PRIVATE_API not defined in file libQt5Gui.so.5 with link time reference
#rm -f ./libQt5Widgets.so.5

# The following are assumed to be part of the base system
rm -f ./libcom_err.so.2 || true
rm -f ./libcrypt.so.1 || true
rm -f ./libdl.so.2 || true
#rm -f ./libexpat.so.1 || true
rm -f ./libgcc_s.so.1 || true
rm -f ./libglib-2.0.so.0 || true
rm -f ./libgpg-error.so.0 || true
rm -f ./libgssapi_krb5.so.2 || true
rm -f ./libgssapi.so.3 || true
rm -f ./libhcrypto.so.4 || true
rm -f ./libheimbase.so.1 || true
rm -f ./libheimntlm.so.0 || true
rm -f ./libhx509.so.5 || true
rm -f ./libICE.so.6 || true
rm -f ./libidn.so.11 || true
rm -f ./libk5crypto.so.3 || true
rm -f ./libkeyutils.so.1 || true
rm -f ./libkrb5.so.26 || true
rm -f ./libkrb5.so.3 || true
rm -f ./libkrb5support.so.0 || true
# rm -f ./liblber-2.4.so.2 || true # needed for debian wheezy
# rm -f ./libldap_r-2.4.so.2 || true # needed for debian wheezy
rm -f ./libm.so.6 || true
rm -f ./libp11-kit.so.0 || true
rm -f ./libpcre.so.3 || true
rm -f ./libpthread.so.0 || true
rm -f ./libresolv.so.2 || true
rm -f ./libroken.so.18 || true
rm -f ./librt.so.1 || true
rm -f ./libsasl2.so.2 || true
rm -f ./libSM.so.6 || true
rm -f ./libusb-1.0.so.0 || true
rm -f ./libuuid.so.1 || true
rm -f ./libwind.so.0 || true
rm -f ./libz.so.1 || true
rm -f ./libGL.so.1 || true
rm -f ./libdrm.so.2 || true
#rm -f ./libxcb.so.1 || true
rm -f ./libX11.so.6 || true
rm -f ./libgio-2.0.so.0 || true
rm -f ./libgdk-x11-2.0.so.0 || true
rm -f ./libasound.so.2 || true
rm -f ./libgdk_pixbuf-2.0.so.0 || true
rm -f ./libfontconfig.so.1 || true
rm -f ./libselinux.so.1 || true

# Delete potentially dangerous libraries
#rm -f ./libstdc* ./libgobject* ./libc.so.* || true
rm -f ./libgobject* ./libc.so.* || true

# We don't bundle the developer stuff
#rm -rf usr/include || true # This won't exist
rm -rf ./cmake || true
rm -rf ./pkgconfig || true

printf "Done.\n"

printf "\nStripping binaries..."

find $APPDIR/ -type f -exec strip {} + 2>/dev/null || true
#strip $APPDIR/usr/bin/* || true

# Patch binary to enable relocation
#sed -i -e 's|/usr|././|g' HighFidelity.AppDir/usr/bin/interface
#find . -type f -exec sed -i -e 's|/usr|././|g' {} \;

printf "Done.\n"

printf "\nPackaging AppRun script, desktop file, icon, metadata, etc..."

#ln -fs usr/bin/interface $APPDIR/AppRun
cp -R $PACKAGING_DIR/bundle/{*,.directory} $APPDIR/ 

printf "Done.\n"

printf "\nCreating AppImage...\n\n"

appimagetool $APPDIR $PACKAGING_DIR/$APPIMAGE_NAME || appimagetool -n $APPDIR $PACKAGING_DIR/$APPIMAGE_NAME

printf "\nAll done.\n"

exit
