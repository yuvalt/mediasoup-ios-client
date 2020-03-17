CC = clang
CXX = clang++
CP = cp
SYSROOT ?= /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk
ARCH ?= x86_64
ARCHIVE ?= libmediasoup-objc.a

CXX_SOURCES=\
	mediasoup-client-ios/src/Consumer.mm \
	mediasoup-client-ios/src/Device.mm \
	mediasoup-client-ios/src/Logger.mm \
	mediasoup-client-ios/src/Producer.mm \
	mediasoup-client-ios/src/RecvTransport.mm \
	mediasoup-client-ios/src/SendTransport.mm \
	mediasoup-client-ios/src/Transport.mm \
	mediasoup-client-ios/src/C++Wrapper/ConsumerWrapper.mm \
	mediasoup-client-ios/src/C++Wrapper/DeviceWrapper.mm \
	mediasoup-client-ios/src/C++Wrapper/LoggerWrapper.mm \
	mediasoup-client-ios/src/C++Wrapper/MediasoupclientWrapper.mm \
	mediasoup-client-ios/src/C++Wrapper/ProducerWrapper.mm \
	mediasoup-client-ios/src/C++Wrapper/TransportWrapper.mm \
	mediasoup-client-ios/src/Mediasoupclient.mm 

C_SOURCES=\
	mediasoup-client-ios/src/webrtc/RTCUtils.m 

HEADERS=\
	mediasoup-client-ios/include/Consumer.h \
	mediasoup-client-ios/include/Device.h \
	mediasoup-client-ios/include/Logger.h \
	mediasoup-client-ios/include/Mediasoupclient.h \
	mediasoup-client-ios/include/Producer.h \
	mediasoup-client-ios/include/RecvTransport.h \
	mediasoup-client-ios/include/SendTransport.h \
	mediasoup-client-ios/include/Transport.h \
	mediasoup-client-ios/include/wrapper/ConsumerWrapper.h \
	mediasoup-client-ios/include/wrapper/DeviceWrapper.h \
	mediasoup-client-ios/include/wrapper/LoggerWrapper.h \
	mediasoup-client-ios/include/wrapper/MediasoupclientWrapper.h \
	mediasoup-client-ios/include/wrapper/ProducerWrapper.h \
	mediasoup-client-ios/include/wrapper/TransportWrapper.h \
	mediasoup-client-ios/include/RTCUtils.h

OBJECTS=$(CXX_SOURCES:.mm=.o) 
OBJECTS+=$(C_SOURCES:.m=.o) 


CCFLAGS=\
	$(FLAGS)

CXXFLAGS=\
	-std=c++14 \
	$(FLAGS)

OBJCFLAGS=$(FLAGS)

FLAGS=\
	-DWEBRTC_MAC \
	-DWEBRTC_POSIX \
	-g \
	-o0 \
	-arch $(ARCH) \
	-isysroot $(SYSROOT) \
	-I../libmediasoupclient/include \
	-I../webrtc-checkout/src/sdk/objc/Framework/Headers \
	-I../webrtc-checkout/src/sdk/objc \
	-I../webrtc-checkout/src/sdk/objc/base \
	-I../webrtc-checkout/src \
	-I../webrtc-checkout/src/third_party/abseil-cpp \
	-I../libmediasoupclient/deps/libsdptransform/include/ \
	-Imediasoup-client-ios/include \
	-Imediasoup-client-ios/include/wrapper \

OBJCLIBS=-framework WebRTC


TEST = test-device-load
TEST_CPP = test-device-load.cpp
LDFLAGS = \
	../libmediasoupclient/build/libmediasoupclient.a \
	../libmediasoupclient/build/libsdptransform/libsdptransform.a \
	../webrtc-checkout/src/out/Default/obj/libwebrtc.a \
	-framework Foundation \
	-framework CoreAudio \
	-framework AudioToolbox \
	-framework CoreGraphics \
	-stdlib=libc++ 

all: $(ARCHIVE)

$(ARCHIVE): $(OBJECTS) $(HEADERS)
	libtool -static -o $(ARCHIVE)  $(OBJECTS)

$(TEST) :  $(TEST_CPP)
	$(CXX) $(CXXFLAGS) -o $(TEST) -g $(TEST_CPP) $(CCFLAGS) $(LDFLAGS)

clean: 
	$(RM) $(OBJECTS) $(ARCHIVE)

copy: 
	$(CP) mediasoup-client-ios/include/*.h ../chill-mac/Frameworks/libmediasoup/include
	$(CP) $(ARCHIVE) ../chill-mac/Frameworks/libmediasoup

copy-ios: 
	$(CP) mediasoup-client-ios/include/*.h ../chill-mac/Frameworks-ios/libmediasoup/include
	$(CP) $(ARCHIVE) ../chill-mac/Frameworks-ios/libmediasoup

%.o: %.mm
	$(CXX) $(CXXFLAGS) -o $@ -c $< 

%.o: %.m
	$(CC) $(CCFLAGS) -o $@ -c $< 
