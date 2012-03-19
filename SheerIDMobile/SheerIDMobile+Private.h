//
//  SheerIDMobile+Private.h
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SheerIDMobile()
{
@private
    NSString *accessToken;
    NSString *hostname;
    BOOL useHttps;
}

- (id)initWithAccessToken:(NSString *)myAccessToken hostname:(NSString*)myHostname secure:(BOOL)myUseHttps;
- (id)getJSON:(NSString*)path error:(NSError**)error;
- (id)postAndReturnJSON:(NSString *)path stringData:(NSString*)strData error:(NSError**)error;

@end
