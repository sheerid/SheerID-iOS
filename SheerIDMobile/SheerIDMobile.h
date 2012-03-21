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

#define kSheerIDErrorCodeInsufficientData 9901

#pragma mark -
#pragma mark Model Interfaces

@interface ServiceConstant : NSObject

- (NSString *)code;
- (NSString *)displayName;

@end


@interface AffiliationType : ServiceConstant

+ (AffiliationType *)affiliationTypeWithCode:(NSString *)code;

@end


@interface Field : ServiceConstant

+ (Field *)fieldWithCode:(NSString *)code;
+ (Field *)fieldWithCode:(NSString *)code displayName:(NSString *)displayName;

@end


@interface Organization : NSObject

- (NSString *)ID;
- (NSString *)name;

+ (Organization *)organizationWithID:(NSString *)ID;

@end


@interface OrganizationSearch : NSObject

- (id)initWithQuery:(NSString *)query;
- (NSString *)query;

@end


@interface Person : NSObject

- (void)addValue:(NSString *)value forField:(Field *)field;
- (NSEnumerator *)fieldEnumerator;
- (BOOL)hasValueForField:(Field *)field;
- (NSString *)valueForField:(Field *)field;

@end


@interface VerificationResponse : NSObject

- (NSString *)requestID;
- (BOOL)result;
- (BOOL)pending;
- (NSSet *)affiliations;

@end

#pragma mark -
#pragma mark SheerIDMobile Interface

@protocol SheerIDDelegate <NSObject>

@optional
- (void)sheerID:(id)sender listFieldsDidFinish:(NSSet *)fields;
- (void)sheerID:(id)sender listFieldshDidFinishWithError:(NSError *)error;
- (void)sheerID:(id)sender organizationSearchDidFinish:(NSArray *)organizations;
- (void)sheerID:(id)sender organizationSearchDidFinishWithError:(NSError *)error;
- (void)sheerID:(id)sender verificationDidFinishWithResponse:(VerificationResponse *)resp;
- (void)sheerID:(id)sender verificationDidFinishWithError:(NSError *)error;

@end

@interface SheerIDMobile : NSObject {
    id<SheerIDDelegate> delegate;
}

@property (nonatomic, retain) id<SheerIDDelegate> delegate;

- (id)initWithAccessToken:(NSString *)accessToken;
- (id)initWithAccessToken:(NSString *)accessToken hostname:(NSString *)hostname;
- (void)listFields:(Organization *)org;
- (void)organizations;
- (void)searchOrganizations:(OrganizationSearch *)search;
- (void)verify:(Person *)p organization:(Organization *)org;
- (void)verify:(Person *)p organization:(Organization *)org affiliationTypes:(NSSet *)affTypes;

@end
