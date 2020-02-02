CC = clang
CXX = clang++
CP = cp

SOURCES=\
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
	mediasoup-client-ios/src/webrtc/RTCUtils.m \
	mediasoup-client-ios/src/Mediasoupclient.mm

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

OBJECTS=$(SOURCES:.mm=.o) 
OBJECTS+=$(SOURCES:.m=.o)

CCFLAGS=\
	$(FLAGS)

CXXFLAGS=\
	-std=c++11 \
	$(FLAGS)

OBJCFLAGS=$(FLAGS)

FLAGS=\
	-DWEBRTC_MAC -DWEBRTC_POSIX \
	-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk \
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

ARCHIVE = libmediasoup-objc.a

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

all: $(ARCHIVE) $(TEST)

$(ARCHIVE): $(OBJECTS) $(HEADERS)
	$(AR) r $(ARCHIVE) $(OBJECTS)


$(TEST) :  $(TEST_CPP)
	$(CXX) -o $(TEST) -g $(TEST_CPP) $(CCFLAGS) $(LDFLAGS)

clean: 
	$(RM) $(OBJECTS) $(ARCHIVE)

copy: 
	$(CP) mediasoup-client-ios/include/*.h ../chill-mac/Frameworks/libmediasoup/include
	$(CP) $(ARCHIVE) ../chill-mac/Frameworks/libmediasoup

%.o     :   %.mm
	$(CXX) $(CXXFLAGS) -o $@ -c $< 

%.o     :   %.m
	$(CC) $(CCFLAGS) -o $@ -c $< 
