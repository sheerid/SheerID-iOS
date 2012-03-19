//
//  SheerIDMobile.h
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSheerIDProductionHostname @"services.sheerid.com"
#define kSheerIDSandboxHostname @"services-sandbox.sheerid.com"


#pragma mark -
#pragma mark Model Interfaces

@interface ServiceConstant : NSObject

- (id)initWithCode:(NSString *)code;
- (id)initWithCode:(NSString *)code displayName:(NSString *)displayName;

- (NSString *)code;
- (NSString *)displayName;

@end


@interface AffiliationType : ServiceConstant
@end


@interface Field : ServiceConstant
@end


@interface Organization : NSObject

- (id)initWithID:(NSString *)ID;
- (id)initWithID:(NSString *)ID name:(NSString *)name;

- (NSString *)ID;
- (NSString *)name;

@end


@interface Person : NSObject

- (void)addValue:(NSString *)value forField:(Field *)field;
- (BOOL)hasValueForField:(Field *)field;
- (NSString *)valueForField:(Field *)field;

@end


@interface VerificationResponse : NSObject

- (NSString *)requestID;
- (BOOL)result;
- (BOOL)pending;
- (NSSet *)affiliations;

@end

@interface OrganizationSearch : NSObject

- (id) initWithQuery:(NSString *)query;

@end

#pragma mark -
#pragma mark SheerIDMobile Interface

@interface SheerIDMobile : NSObject

- (id)initWithAccessToken:(NSString *)accessToken;
- (NSArray *)organizations;
- (NSArray *)searchOrganizations:(OrganizationSearch *)search;
- (VerificationResponse *)verify:(Person *)p organization:(Organization *)org;
- (VerificationResponse *)verify:(Person *)p organization:(Organization *)org affiliationTypes:(NSSet *)affTypes;

@end
