//
//  SheerIDMobile.m
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import "SheerIDMobile.h"
#import "SheerIDMobile+Private.h"
#import "VerificationResponse+Private.h"
#import "JSONKit.h"

#define kRestApiContext @"/rest/"
#define kRestApiVersion @"0.5"

@implementation SheerIDMobile

- (id)initWithAccessToken:(NSString *)myAccessToken {
    self = [self initWithAccessToken:myAccessToken hostname:kSheerIDProductionHostname secure:YES];
    return self;
}

- (id)initWithAccessToken:(NSString *)myAccessToken hostname:(NSString*)myHostname secure:(BOOL)myUseHttps {
    self = [super init];
    if (self) {
        accessToken = myAccessToken;
        hostname = myHostname;
        useHttps = myUseHttps;
    }
    return self;
}

- (NSArray *)organizations {
    return [self searchOrganizations:nil];
}

- (NSArray *)searchOrganizations:(OrganizationSearch *)search {
    NSMutableArray *orgs = [NSMutableArray array];
    for (NSDictionary *org in [self getJSON:@"/organization" error:nil]) {
        [orgs addObject:[[[Organization alloc] initWithID:[org valueForKey:@"id"] name:[org valueForKey:@"name"]] autorelease]];
    }
    return [NSArray arrayWithArray:orgs];
}

- (NSSet *)fields:(Organization *)org {
    NSMutableSet *fieldSet = [NSMutableSet set];
    
    //TODO: support a true per-organization field search!
    NSArray *fields = [self getJSON:@"/field" error:nil];
    for (NSString *field in fields) {
        [fieldSet addObject:[[[Field alloc] initWithCode:field] autorelease]];
    }
    
    return [NSSet setWithSet:fieldSet];
}

- (VerificationResponse *)verify:(Person *)p organization:(Organization *)org error:(NSError **)error {
    return [self verify:p organization:org affiliationTypes:nil error:error];
}

- (VerificationResponse *)verify:(Person *)p organization:(Organization *)org affiliationTypes:(NSSet *)affTypes error:(NSError **)error {
    NSMutableArray *queryParts = [NSMutableArray array];
    
    [queryParts addObject:[NSString stringWithFormat:@"organizationId=%@", [org.ID stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], nil]];
    
    for (Field *field in [p fieldEnumerator]) {
        [queryParts addObject:[NSString stringWithFormat:@"%@=%@", [field.code stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[p valueForField:field] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], nil]];
    }
//    
//   [queryParts addObject:[NSString stringWithFormat:@"_affiliationTypes=%@", [@"STUDENT_PART_TIME,STUDENT_FULL_TIME" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], nil]];
    
    NSString *query = [queryParts componentsJoinedByString:@"&"];
    NSError *httpError;
    
    NSDictionary *respObj = [self postAndReturnJSON:@"/verification" stringData:query error:&httpError];
    
    if (respObj) {
        NSString *requestID = [respObj valueForKey:@"requestId"];
        BOOL result = [[respObj valueForKey:@"result"] boolValue];
        BOOL pending = [[respObj valueForKey:@"status"] isEqualToString:@"PENDING"];
        
        *error = nil;
        
        return [[VerificationResponse alloc] initWithRequestID:requestID result:result pending:pending affiliations:nil];
    } else if (httpError) {
        if (httpError.code == 400) {
            *error = [NSError errorWithDomain:@"SheerID" code:kSheerIDErrorCodeInsufficientData userInfo:nil];
        } else {
            *error = httpError;
        }
        return nil;
    } else {
        return nil;
    }
}


- (id)getJSON:(NSString *)path error:(NSError**)error {
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", accessToken];
    NSString *requestUrlString = [NSString stringWithFormat:@"http%@://%@%@%@%@", useHttps?@"s":@"", hostname, kRestApiContext, kRestApiVersion, path, nil];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:requestUrlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    NSURLResponse* response;
    NSError *httpError;
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&httpError];
    int status = [(NSHTTPURLResponse *)response statusCode];
    
    if (status == 200) {
        return [[JSONDecoder decoder] objectWithData:result];
    } else {
        return nil;
    }
}

- (id)postAndReturnJSON:(NSString *)path stringData:(NSString*)strData error:(NSError**)error {
    NSData *postData = [strData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", accessToken];
    NSString *requestUrlString = [NSString stringWithFormat:@"http%@://%@%@%@%@", useHttps?@"s":@"", hostname, kRestApiContext, kRestApiVersion, path, nil];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:requestUrlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:postData];
    
    NSURLResponse* response;
    NSError *httpError;
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&httpError];
    int status = [(NSHTTPURLResponse *)response statusCode];
    
    if (status == 200) {
        return [[JSONDecoder decoder] objectWithData:result];
    } else {        
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:[[[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding] autorelease] forKey:NSLocalizedDescriptionKey];
        *error = [NSError errorWithDomain:@"SheerID.HTTP" code:status userInfo:errorDetail];
        return nil;
    }
}


@end
