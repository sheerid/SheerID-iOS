//
//  SheerIDMobile+Private.h
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SheerIDMobile() <NSURLConnectionDelegate>
{
@private
    NSString *accessToken;
    NSString *hostname;
    BOOL useHttps;
    
    CFMutableDictionaryRef requests;
}

- (id)initWithAccessToken:(NSString *)myAccessToken hostname:(NSString*)myHostname secure:(BOOL)myUseHttps;
- (void)get:(NSString *)path;
- (void)postStringData:(NSString *)strData toPath:(NSString *)path;
- (void)initiateRequest:(NSURLRequest *)request;

@end


@interface Organization ()
{
@private
    NSString *ID;
    NSString *name;
}

- (id)initWithID:(NSString *)ID;
- (id)initWithID:(NSString *)ID name:(NSString *)name;

@end


@interface ServiceConstant ()
{
@private
    NSString *code;
    NSString *displayName;
}

- (id)initWithCode:(NSString *)code;
- (id)initWithCode:(NSString *)code displayName:(NSString *)displayName;

@end


@interface VerificationResponse () {
    NSString *requestID;
    BOOL pending;
    BOOL result;
    NSSet *affiliations;
}

- (id) initWithRequestID:(NSString *)requestID result:(BOOL)result pending:(BOOL)pending affiliations:(NSSet *)affiliations;

@end
