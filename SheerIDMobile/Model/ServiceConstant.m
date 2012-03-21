//
//  ServiceConstant.m
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import "SheerIDMobile.h"
#import "SheerIDMobile+Private.h"

@implementation ServiceConstant

- (id)initWithCode:(NSString *)myCode {
    self = [self initWithCode:myCode displayName:nil];
    return self;
}

- (id)initWithCode:(NSString *)myCode displayName:(NSString *)myDisplayName {
    if (myCode == nil) {
        [NSException raise:@"invalid value" format:@"code should not be nil"];
    }
    self = [super init];
    if (self) {
        code = myCode;
        if (myDisplayName) {
            displayName = myDisplayName;
        } else {
            displayName = code;
        }
    }
    return self;
}

- (NSString *)code {
    return code;
}

- (NSString *)displayName {
    return displayName;
}

@end