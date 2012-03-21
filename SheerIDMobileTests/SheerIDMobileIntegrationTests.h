//
//  SheerIDMobileIntegrationTests.h
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SheerIDMobile.h"

@interface SheerIDMobileIntegrationTests : SenTestCase <SheerIDDelegate> {
    NSString *accessToken;
    NSString *hostname;
    BOOL secure;
    BOOL done;
    id result;
    SheerIDMobile *sheerID;
}

@property (nonatomic, retain) id result;

- (BOOL)waitForCompletion;
- (BOOL)waitForCompletion:(NSTimeInterval)timeoutSecs;
@end
