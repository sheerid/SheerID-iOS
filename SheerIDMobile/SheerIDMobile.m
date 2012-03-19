//
//  SheerIDMobile.m
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import "SheerIDMobile.h"

@interface SheerIDMobile()
{
@private
    NSString *accessToken;
    NSString *hostname;
    BOOL useHttps;
}

- (id)initWithAccessToken:(NSString *)myAccessToken hostname:(NSString*)myHostname secure:(BOOL)myUseHttps;

@end

@implementation SheerIDMobile

- (id)initWithAccessToken:(NSString *)myAccessToken {
    self = [self initWithAccessToken:myAccessToken hostname:kSheerIDProductionHostname secure:YES];
    return self;
}

- (id)initWithAccessToken:(NSString *)myAccessToken hostname:(NSString*)myHostname secure:(BOOL)myUseHttps {
    self = [super init];
    if (self) {
        accessToken = myAccessToken;
        hostname = hostname;
        useHttps = myUseHttps;
    }
    return self;
}

- (NSArray *)organizations {
    return [self searchOrganizations:nil];
}

- (NSArray *)searchOrganizations:(OrganizationSearch *)search {
    return [NSArray arrayWithObjects:nil];
}

- (VerificationResponse *)verify:(Person *)p organization:(Organization *)org {
    return [self verify:p organization:org affiliationTypes:nil];
}

- (VerificationResponse *)verify:(Person *)p organization:(Organization *)org affiliationTypes:(NSSet *)affTypes {
    return [[VerificationResponse alloc] init];
}

@end
