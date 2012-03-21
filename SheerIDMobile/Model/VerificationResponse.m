//
//  VerificationResponse.m
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import "SheerIDMobile.h"
#import "SheerIDMobile+Private.h"

@implementation VerificationResponse

- (id) initWithRequestID:(NSString *)myRequestID result:(BOOL)myResult pending:(BOOL)myPending affiliations:(NSSet *)myAffiliations {
    self = [super init];
    if (self) {
        requestID = myRequestID;
        result = myResult;
        pending = myPending;
        affiliations = myAffiliations;
    }
    return self;
}

- (NSString *)requestID {
    return requestID;
}

- (BOOL)result {
    return result;
}

- (BOOL)pending {
    return pending;
}

- (NSSet *)affiliations {
    return affiliations;
}

@end
