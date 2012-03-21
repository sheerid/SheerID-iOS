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

#define kSheerIDAccessToken @"** PUT YOUR ACCESS TOKEN HERE **"

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

@synthesize result;

- (void)setUp
{
    [super setUp];
    
    done = NO;
    result = nil;
    
    sheerID = [[SheerIDMobile alloc] initWithAccessToken:kSheerIDAccessToken hostname:kSheerIDSandboxHostname secure:YES];
    sheerID.delegate = self;
}

- (void)tearDown {
    [result release];
    result = nil;
}

- (BOOL)waitForCompletion {
    return [self waitForCompletion:10];
}

- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs {        
    NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeoutSecs];
    
    do {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:timeoutDate];
        if([timeoutDate timeIntervalSinceNow] < 0.0)
            break;
    } while (!done);
    
    return done;
}

- (void)sheerID:(id)sender listFieldsDidFinish:(NSSet *)fields {
    done = YES;
    self.result = fields;
}

- (void)sheerID:(id)sender listFieldshDidFinishWithError:(NSError *)error {
    done = YES;
    self.result = error;
}

- (void)sheerID:(id)sender organizationSearchDidFinish:(NSArray *)organizations {
    done = YES;
    self.result = organizations;
}

- (void)sheerID:(id)sender organizationSearchDidFinishWithError:(NSError *)error {
    done = YES;
    self.result = error;
}

- (void)sheerID:(id)sender verificationDidFinishWithResponse:(VerificationResponse *)resp {
    done = YES;
    self.result = resp;
}

- (void)sheerID:(id)sender verificationDidFinishWithError:(NSError *)error {
    done = YES;
    self.result = error;
}

- (void)testFields
{
    [sheerID listFields:nil];
    [self waitForCompletion];
    
    NSSet *fields = result;
    STAssertNotNil(fields, @"fields should not be nil");
    STAssertTrue([fields count] > 0, @"should have returned a non-empty set of fields");
}

- (void)testOrganizations
{
    [sheerID organizations];
    [self waitForCompletion];
    
    NSArray *organizations = result;
    STAssertNotNil(organizations, @"organizations should not be nil");
    STAssertTrue([organizations count] > 0, @"should have returned a non-empty array of organizations");
}

- (void)testVerificationInsufficientData
{
    Organization *org = [[[Organization alloc] initWithID:@"1"] autorelease];
    Person *p = [[[Person alloc] init] autorelease];
    
    [sheerID verify:p organization:org];
    [self waitForCompletion];
    
    NSError *error = result;
    STAssertNotNil(error, @"error should be non-nil");
    STAssertEquals(kSheerIDErrorCodeInsufficientData, error.code, @"error code should match 'insufficient data' code");
}

- (void)testVerificationSuccess
{
    Organization *org = [[[Organization alloc] initWithID:@"1"] autorelease];
    Person *p = [[[Person alloc] init] autorelease];
    
    [p addValue:@"John" forField:[[[Field alloc] initWithCode:@"FIRST_NAME"] autorelease]];
    [p addValue:@"Smith" forField:[[[Field alloc] initWithCode:@"LAST_NAME"] autorelease]];
    [p addValue:@"2010-02-02" forField:[[[Field alloc] initWithCode:@"BIRTH_DATE"] autorelease]];
    
    [sheerID verify:p organization:org affiliationTypes:nil];
    [self waitForCompletion];
    
    STAssertEquals([VerificationResponse class], [result class], @"should be of type VerificationResponse");
    
    VerificationResponse *resp = result;    
    STAssertNotNil(resp, @"response should be non-nil");
    STAssertTrue(resp.result, @"result should be YES");
}

- (void)testVerificationFailure
{
    Organization *org = [[[Organization alloc] initWithID:@"1"] autorelease];
    Person *p = [[[Person alloc] init] autorelease];
    
    [p addValue:@"John" forField:[[[Field alloc] initWithCode:@"FIRST_NAME"] autorelease]];
    [p addValue:@"Smith" forField:[[[Field alloc] initWithCode:@"LAST_NAME"] autorelease]];
    [p addValue:@"2009-02-02" forField:[[[Field alloc] initWithCode:@"BIRTH_DATE"] autorelease]];
    
    [sheerID verify:p organization:org affiliationTypes:nil];
    [self waitForCompletion];
    
    STAssertEquals([VerificationResponse class], [result class], @"should be of type VerificationResponse");
    
    VerificationResponse *resp = result; 
    STAssertNotNil(resp, @"response should be non-nil");
    STAssertFalse(resp.result, @"result should be NO");
}

@end
