make clean

make -j7 \
SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/ \
ARCH=x86_64 \
ARCHIVE=libmediasoup-objc_x64.a

make clean

make -j7 \
SYSROOT=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk/  \
ARCH=arm64 \
ARCHIVE=libmediasoup-objc_arm64.a

lipo -create libmediasoup-objc_x64.a libmediasoup-objc_arm64.a -output libmediasoup-objc.a

make copy-ios