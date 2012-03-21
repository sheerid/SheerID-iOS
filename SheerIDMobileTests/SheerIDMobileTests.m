//
//  SheerIDMobileTests.m
//  SheerIDMobileTests
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import "SheerIDMobile.h"
#import "SheerIDMobile+Private.h"
#import "SheerIDMobileTests.h"

@implementation SheerIDMobileTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

#pragma mark -
#pragma mark AffiliationType tests

- (void)testAffiliationTypeNilCode
{
    @try {
        AffiliationType *aType = [[AffiliationType alloc] initWithCode:nil];
        STFail(@"should have excepted");
        STAssertNil(aType, @"this is just to suppress a warning!");
    }
    @catch (NSException *exception) {}
}

- (void)testAffiliationTypeNilBoth
{
    @try {
        AffiliationType *aType = [[AffiliationType alloc] initWithCode:nil displayName:nil];
        STFail(@"should have excepted");
        STAssertNil(aType, @"this is just to suppress a warning!");
    }
    @catch (NSException *exception) {}
}

- (void)testAffiliationTypeNilDisplayName
{
    NSString *code = @"STUDENT_FULL_TIME";
    AffiliationType *aType = [[AffiliationType alloc] initWithCode:code displayName:nil];
    STAssertNotNil(aType, @"affiliation type should not be nil");
    STAssertEquals(code, aType.code, @"code should be as defined");
    STAssertEquals(code, [aType code], @"code should be as defined");
    STAssertEquals(code, aType.displayName, @"displayName should default to code");
    STAssertEquals(code, [aType displayName], @"displayName should default to code");
}

- (void)testAffiliationTypeCodeOnly
{
    NSString *code = @"STUDENT_FULL_TIME";
    AffiliationType *aType = [[AffiliationType alloc] initWithCode:code];
    STAssertNotNil(aType, @"affiliation type should not be nil");
    STAssertEquals(code, aType.code, @"code should be as defined");
    STAssertEquals(code, [aType code], @"code should be as defined");
    STAssertEquals(code, aType.displayName, @"displayName should default to code");
    STAssertEquals(code, [aType displayName], @"displayName should default to code");
}

- (void)testAffiliationTypeCodeAndDisplayName {
    NSString *code = @"STUDENT_FULL_TIME";
    NSString *displayName = @"Full-Time Student";
    AffiliationType *aType = [[AffiliationType alloc] initWithCode:code displayName:displayName];
    STAssertNotNil(aType, @"affiliation type should not be nil");
    STAssertEquals(code, aType.code, @"code should be as defined");
    STAssertEquals(code, [aType code], @"code should be as defined");
    STAssertEquals(displayName, aType.displayName, @"displayName should be as defined");
    STAssertEquals(displayName, [aType displayName], @"displayName should be as defined");
}

#pragma mark -
#pragma mark Field tests

- (void)testFieldNilCode
{
    @try {
        Field *f = [[Field alloc] initWithCode:nil];
        STFail(@"should have excepted");
        STAssertNil(f, @"this is just to suppress a warning!");
    }
    @catch (NSException *exception) {}
}

- (void)testFieldNilBoth
{
    @try {
        Field *f = [[Field alloc] initWithCode:nil displayName:nil];
        STFail(@"should have excepted");
        STAssertNil(f, @"this is just to suppress a warning!");
    }
    @catch (NSException *exception) {}
}

- (void)testFieldNilDisplayName
{
    NSString *code = @"FIRST_NAME";
    Field *f = [[Field alloc] initWithCode:code displayName:nil];
    STAssertNotNil(f, @"field should not be nil");
    STAssertEquals(code, f.code, @"code should be as defined");
    STAssertEquals(code, [f code], @"code should be as defined");
    STAssertEquals(code, f.displayName, @"displayName should default to code");
    STAssertEquals(code, [f displayName], @"displayName should default to code");
}

- (void)testFieldCodeOnly
{
    NSString *code = @"FIRST_NAME";
    Field *f = [[Field alloc] initWithCode:code];
    STAssertNotNil(f, @"field should not be nil");
    STAssertEquals(code, f.code, @"code should be as defined");
    STAssertEquals(code, [f code], @"code should be as defined");
    STAssertEquals(code, f.displayName, @"displayName should default to code");
    STAssertEquals(code, [f displayName], @"displayName should default to code");
}

- (void)testFieldCodeAndDisplayName {
    NSString *code = @"FIRST_NAME";
    NSString *displayName = @"First Name";
    Field *f = [[Field alloc] initWithCode:code displayName:displayName];
    STAssertNotNil(f, @"field should not be nil");
    STAssertEquals(code, f.code, @"code should be as defined");
    STAssertEquals(code, [f code], @"code should be as defined");
    STAssertEquals(displayName, f.displayName, @"displayName should be as defined");
    STAssertEquals(displayName, [f displayName], @"displayName should be as defined");
}

#pragma mark -
#pragma mark Organization tests

- (void) testOrganizationNullID
{
    @try {
        Organization *org = [[Organization alloc] initWithID:nil];
        STFail(@"should have excepted");
        STAssertNil(org, @"this is just to suppress a warning!");
    }
    @catch (NSException *exception) {}
}

- (void) testOrganizationNullBoth
{
    @try {
        Organization *org = [[Organization alloc] initWithID:nil name:nil];
        STFail(@"should have excepted");
        STAssertNil(org, @"this is just to suppress a warning!");
    }
    @catch (NSException *exception) {}
}

- (void) testOrganizationWithID
{
    NSString *ID = @"1";
    Organization *org = [[Organization alloc] initWithID:ID name:nil];
    STAssertNotNil(org, @"org should not be nill");
    STAssertEquals(ID, org.ID, @"id should be as defined");
    STAssertNil(org.name, @"name should be nil");
}

- (void) testOrganizationWithIDAndName
{
    NSString *ID = @"1";
    NSString *name = @"University of North Carolina";
    Organization *org = [[Organization alloc] initWithID:ID name:name];
    STAssertNotNil(org, @"org should not be nill");
    STAssertEquals(ID, org.ID, @"id should be as defined");
    STAssertEquals(name, org.name, @"name should be as defined");
}

#pragma mark -
#pragma mark Person tests

- (void) testPersonEmpty
{
    Person *person = [[Person alloc] init];
    Field *f = [[Field alloc] initWithCode:@"FIRST_NAME"];
    STAssertNotNil(person, @"person should not be nil");
    STAssertFalse([person hasValueForField:f], @"person should not have a first name");
    STAssertNil([person valueForField:f], @"person's first name should be nil");
}

- (void) testPersonFullName
{
    Person *person = [[Person alloc] init];
    Field *firstName = [[Field alloc] initWithCode:@"FIRST_NAME"];
    Field *lastName = [[Field alloc] initWithCode:@"LAST_NAME"];
    
    NSString *strFirstName = @"John";
    NSString *strLastName = @"Smith";
    
    STAssertNotNil(person, @"person should not be nil");
    STAssertFalse([person hasValueForField:firstName], @"person should not have a first name");
    STAssertFalse([person hasValueForField:lastName], @"person should not have a last name");
    
    [person addValue:strFirstName forField:firstName];
    
    STAssertTrue([person hasValueForField:firstName], @"person should have a first name");
    STAssertEquals(strFirstName, [person valueForField:firstName], @"first name should be as defined");
    STAssertFalse([person hasValueForField:lastName], @"person should not have a last name");
    
    [person addValue:strLastName forField:lastName];
    
    STAssertTrue([person hasValueForField:firstName], @"person should have a first name");
    STAssertEquals(strFirstName, [person valueForField:firstName], @"first name should be as defined");
    STAssertTrue([person hasValueForField:lastName], @"person should have a last name");
    STAssertEquals(strLastName, [person valueForField:lastName], @"last name should be as defined");
}

@end
