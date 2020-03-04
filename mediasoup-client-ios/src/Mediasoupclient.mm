//
//  Mediasoupclient.mm
//  mediasoup-client-ios
//
//  Created by Ethan.
//  Copyright © 2019 Ethan. All rights reserved.
//

#import "Mediasoupclient.h"
#import "MediasoupclientWrapper.h"
#import "api/peerconnection/RTCPeerConnectionFactory+Private.h"

static mediasoupclient::PeerConnection::Options globalPeerConnectionOptions;

@implementation Mediasoupclient
+(NSString *)version {
    return [MediasoupclientWrapper nativeVersion];
}

+(void)initializePCWithFactory:(RTCPeerConnectionFactory *)factory {
    [MediasoupclientWrapper nativeInitialize];
    globalPeerConnectionOptions.factory = factory.nativeFactory;
}

+(void*)peerConnectionOptions {
    return (void*) &globalPeerConnectionOptions;
}

+(void)cleanUp {
    [MediasoupclientWrapper nativeCleanup];
}
@end
