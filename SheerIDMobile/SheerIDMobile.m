//
//  SheerIDMobile.m
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import "SheerIDMobile.h"
#import "SheerIDMobile+Private.h"
#import "JSONKit.h"

#define kRestApiContext @"/rest/"
#define kRestApiVersion @"0.5"

#define kDataTypeField 1001
#define kDataTypeOrganization 1002
#define kDataTypeVerification 1003

@implementation SheerIDMobile

@synthesize delegate;

#pragma mark -
#pragma mark Initializers

- (id)initWithAccessToken:(NSString *)myAccessToken {
    self = [self initWithAccessToken:myAccessToken hostname:kSheerIDProductionHostname secure:YES];
    return self;
}

- (id)initWithAccessToken:(NSString *)myAccessToken hostname:(NSString *)myHostname {
    self = [self initWithAccessToken:myAccessToken hostname:myHostname secure:YES];
    return self;
}

- (id)initWithAccessToken:(NSString *)myAccessToken hostname:(NSString*)myHostname secure:(BOOL)myUseHttps {
    self = [super init];
    if (self) {
        accessToken = myAccessToken;
        hostname = myHostname;
        useHttps = myUseHttps;
        
        requests = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    return self;
}

#pragma mark -
#pragma mark Business methods

- (void)organizations {
    return [self searchOrganizations:nil];
}

- (void)searchOrganizations:(OrganizationSearch *)search {
    [self get:@"/organization"];
}

- (void)listFields:(Organization *)org {
    //TODO: support a true per-organization field search!
    [self get:@"/field"];
}

- (void)verify:(Person *)p organization:(Organization *)org {
    [self verify:p organization:org affiliationTypes:nil];
}

- (void)verify:(Person *)p organization:(Organization *)org affiliationTypes:(NSSet *)affTypes {
    NSMutableArray *queryParts = [NSMutableArray array];
    
    [queryParts addObject:[NSString stringWithFormat:@"organizationId=%@", [org.ID stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], nil]];
    
    for (Field *field in [p fieldEnumerator]) {
        [queryParts addObject:[NSString stringWithFormat:@"%@=%@", [field.code stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [[p valueForField:field] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], nil]];
    }
    
//   [queryParts addObject:[NSString stringWithFormat:@"_affiliationTypes=%@", [@"STUDENT_PART_TIME,STUDENT_FULL_TIME" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], nil]];
    
    NSString *query = [queryParts componentsJoinedByString:@"&"];
    
    NSLog(@"%@", query);
    
    [self postStringData:query toPath:@"/verification"];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSMutableDictionary *connectionInfo = CFDictionaryGetValue(requests, connection);
    int dataType = [[connectionInfo valueForKey:@"dataType"] intValue];
    
    switch (dataType) {
        case kDataTypeField: {
            if ([delegate respondsToSelector:@selector(sheerID:listFieldshDidFinishWithError:)]) {
                [delegate sheerID:self listFieldshDidFinishWithError:error];
            }
            break;
        }
            
        case kDataTypeOrganization: {
            if ([delegate respondsToSelector:@selector(sheerID:organizationSearchDidFinishWithError:)]) {
                [delegate sheerID:self organizationSearchDidFinishWithError:error];
            }
            break;
        }
            
        case kDataTypeVerification: {
            if ([delegate respondsToSelector:@selector(sheerID:verificationDidFinishWithError:)]) {
                [delegate sheerID:self verificationDidFinishWithError:error];
            }
            break;
        }
    }
    
    CFDictionaryRemoveValue(requests, connection);
    [connection release];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableDictionary *connectionInfo = CFDictionaryGetValue(requests, connection);
    
    id respObj = [[JSONDecoder decoder] objectWithData:[connectionInfo valueForKey:@"receivedData"]];
    
    int dataType = [[connectionInfo valueForKey:@"dataType"] intValue];
    
    switch (dataType) {
        case kDataTypeField: {
            NSMutableSet *fields = [NSMutableSet set];
            for (NSString *field in respObj) {
                [fields addObject:[[[Field alloc] initWithCode:field] autorelease]];
            }
            if ([delegate respondsToSelector:@selector(sheerID:listFieldsDidFinish:)]) {
                [delegate sheerID:self listFieldsDidFinish:[NSSet setWithSet:fields]];
            }
            break;
        }

        case kDataTypeOrganization: {
            NSMutableArray *orgs = [NSMutableArray arrayWithCapacity:[respObj count]];
            for (NSDictionary *org in respObj) {
                [orgs addObject:[[[Organization alloc] initWithID:[org valueForKey:@"id"] name:[org valueForKey:@"name"]] autorelease]];
            }
            if ([delegate respondsToSelector:@selector(sheerID:organizationSearchDidFinish:)]) {
                [delegate sheerID:self organizationSearchDidFinish:[NSArray arrayWithArray:orgs]];
            }
            break;
        }
            
        case kDataTypeVerification: {
            if ([[connectionInfo valueForKey:@"response"] statusCode] == 400) {
                //NSString *str = [[NSString alloc] initWithData:[connectionInfo valueForKey:@"receivedData"] encoding:NSUTF8StringEncoding];
                NSError *error = [NSError errorWithDomain:@"SheerID" code:kSheerIDErrorCodeInsufficientData userInfo:nil];
                
                if ([delegate respondsToSelector:@selector(sheerID:verificationDidFinishWithError:)]) {
                    [delegate sheerID:self verificationDidFinishWithError:error];
                }
            } else {
                NSString *requestID = [respObj valueForKey:@"requestId"];
                BOOL result = [[respObj valueForKey:@"result"] boolValue];
                BOOL pending = [[respObj valueForKey:@"status"] isEqualToString:@"PENDING"];
                
                if ([delegate respondsToSelector:@selector(sheerID:verificationDidFinishWithResponse:)]) {
                    [delegate sheerID:self verificationDidFinishWithResponse:[[[VerificationResponse alloc] initWithRequestID:requestID result:result pending:pending affiliations:nil] autorelease]];
                }
            }
            
            break;
        }
    }

    CFDictionaryRemoveValue(requests, connection);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSMutableDictionary *connectionInfo = CFDictionaryGetValue(requests, connection);
    [connectionInfo setValue:response forKey:@"response"];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSMutableDictionary *connectionInfo = CFDictionaryGetValue(requests, connection);
    [[connectionInfo objectForKey:@"receivedData"] appendData:data];
}

#pragma mark -
#pragma mark Helper methods

- (void)initiateRequest:(NSURLRequest *)request {
    NSURLConnection *theConnection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (theConnection) {
        NSString *path = [request.URL path];
        int dataType = 0;
        
        NSRange verificationRange = [path rangeOfString:@"verification"];
        NSRange organizationRange = [path rangeOfString:@"organization"];
        NSRange fieldRange = [path rangeOfString:@"field"];
        
        if (verificationRange.location != NSNotFound) {
            dataType = kDataTypeVerification;
        } else if (organizationRange.location != NSNotFound) {
            dataType = kDataTypeOrganization;
        } else if (fieldRange.location != NSNotFound) {
            dataType = kDataTypeField;
        }
        
        NSMutableDictionary *info = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSMutableData data], @"receivedData", [NSNumber numberWithInt:dataType], @"dataType", nil];
        
        [info setValue:nil forKey:@"response"];
        
        CFDictionaryAddValue(requests, theConnection, info);
    }
}

- (void)get:(NSString *)path {
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", accessToken];
    NSString *requestUrlString = [NSString stringWithFormat:@"http%@://%@%@%@%@", useHttps?@"s":@"", hostname, kRestApiContext, kRestApiVersion, path, nil];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:requestUrlString]];
    [request setHTTPMethod:@"GET"];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    
    [self initiateRequest:request];
}

- (void)postStringData:(NSString*)strData toPath:(NSString *)path {
    NSData *postData = [strData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *authHeader = [NSString stringWithFormat:@"Bearer %@", accessToken];
    NSString *requestUrlString = [NSString stringWithFormat:@"http%@://%@%@%@%@", useHttps?@"s":@"", hostname, kRestApiContext, kRestApiVersion, path, nil];
    
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:[NSURL URLWithString:requestUrlString]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:postData];
    
    [self initiateRequest:request];
}


@end
