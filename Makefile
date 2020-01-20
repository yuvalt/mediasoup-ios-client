CC = clang
CXX = clang++

SOURCES=\
	mediasoup-client-ios/src/Consumer.mm \
	mediasoup-client-ios/src/Device.mm \
	mediasoup-client-ios/src/Logger.mm \
	mediasoup-client-ios/src/Mediasoupclient.mm \
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
	mediasoup-client-ios/src/webrtc/RTCUtils.m

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

$(ARCHIVE): $(OBJECTS)
	$(AR) r $(ARCHIVE) $(OBJECTS)


$(TEST) :  $(TEST_CPP)
	$(CXX) -o $(TEST) -g $(TEST_CPP) $(CCFLAGS) $(LDFLAGS)

clean: 
	$(RM) $(OBJECTS) $(ARCHIVE)

%.o     :   %.mm
	$(CXX) $(CXXFLAGS) -o $@ -c $< 

%.o     :   %.m
	$(CC) $(CCFLAGS) -o $@ -c $< 
