//
//  VerificationResponse+Private.h
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerificationResponse () {
    NSString *requestID;
    BOOL pending;
    BOOL result;
    NSSet *affiliations;
}

- (id) initWithRequestID:(NSString *)requestID result:(BOOL)result pending:(BOOL)pending affiliations:(NSSet *)affiliations;

@end
