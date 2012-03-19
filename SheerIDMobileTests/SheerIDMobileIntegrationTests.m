//
//  SheerIDMobileIntegrationTests.m
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import "SheerIDMobile.h"
#import "SheerIDMobile+Private.h"
#import "SheerIDMobileIntegrationTests.h"


// used for self-signed certificates

@interface NSURLRequest (IgnoreSSL)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host;
@end

@implementation NSURLRequest (IgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString*)host
{
    return YES;
}

@end


@implementation SheerIDMobileIntegrationTests

- (void)setUp
{
    [super setUp];
    
    accessToken = @"<!-- PUT ACCESS TOKEN HERE -->";
    hostname = @"services-sandbox.sheerid.com";
    secure = YES;
}

- (void)testFields
{
    SheerIDMobile *sheer = [[SheerIDMobile alloc] initWithAccessToken:accessToken hostname:hostname secure:secure];
    NSSet *fields = [sheer fields:nil];
    STAssertNotNil(fields, @"fields should not be nil");
    STAssertTrue([fields count] > 0, @"should have returned a non-empty set of fields");
}

- (void)testOrganizations
{
    SheerIDMobile *sheer = [[SheerIDMobile alloc] initWithAccessToken:accessToken hostname:hostname secure:secure];
    NSArray *organizations = [sheer organizations];
    STAssertNotNil(organizations, @"organizations should not be nil");
    STAssertTrue([organizations count] > 0, @"should have returned a non-empty array of organizations");
}

- (void)testVerificationInsufficientData
{
    SheerIDMobile *sheer = [[SheerIDMobile alloc] initWithAccessToken:accessToken hostname:hostname secure:secure];
    Organization *org = [[[Organization alloc] initWithID:@"1"] autorelease];
    Person *p = [[[Person alloc] init] autorelease];
    
    NSError *error;
    VerificationResponse *resp = [sheer verify:p organization:org error:&error];
    STAssertNil(resp, @"response should be nil");
    STAssertNotNil(error, @"error should be non-nil");
    STAssertEquals(kSheerIDErrorCodeInsufficientData, error.code, @"error code should match 'insufficient data' code");
}

- (void)testVerificationSuccess
{
    SheerIDMobile *sheer = [[SheerIDMobile alloc] initWithAccessToken:accessToken hostname:hostname secure:secure];
    Organization *org = [[[Organization alloc] initWithID:@"1"] autorelease];
    Person *p = [[[Person alloc] init] autorelease];
    
    [p addValue:@"John" forField:[[[Field alloc] initWithCode:@"FIRST_NAME"] autorelease]];
    [p addValue:@"Smith" forField:[[[Field alloc] initWithCode:@"LAST_NAME"] autorelease]];
    [p addValue:@"2010-02-02" forField:[[[Field alloc] initWithCode:@"BIRTH_DATE"] autorelease]];
    
    NSError *error;
    VerificationResponse *resp = [sheer verify:p organization:org affiliationTypes:nil error:&error];
    STAssertNotNil(resp, @"response should be non-nil");
    STAssertNil(error, @"error should be nil");
    STAssertTrue(resp.result, @"result should be YES");
}

- (void)testVerificationFailure
{
    SheerIDMobile *sheer = [[SheerIDMobile alloc] initWithAccessToken:accessToken hostname:hostname secure:secure];
    Organization *org = [[[Organization alloc] initWithID:@"1"] autorelease];
    Person *p = [[[Person alloc] init] autorelease];
    
    [p addValue:@"John" forField:[[[Field alloc] initWithCode:@"FIRST_NAME"] autorelease]];
    [p addValue:@"Smith" forField:[[[Field alloc] initWithCode:@"LAST_NAME"] autorelease]];
    [p addValue:@"2009-02-02" forField:[[[Field alloc] initWithCode:@"BIRTH_DATE"] autorelease]];
    
    NSError *error;
    VerificationResponse *resp = [sheer verify:p organization:org affiliationTypes:nil error:&error];
    STAssertNotNil(resp, @"response should be non-nil");
    STAssertNil(error, @"error should be nil");
    STAssertFalse(resp.result, @"result should be NO");
}

@end
