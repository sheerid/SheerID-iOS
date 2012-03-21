//
//  Organization.m
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import "SheerIDMobile.h"
#import "SheerIDMobile+Private.h"

@implementation Organization

+ (Organization *)organizationWithID:(NSString *)ID {
    return [[[Organization alloc] initWithID:ID] autorelease];
}

- (id)initWithID:(NSString *)myID {
    self = [self initWithID:myID name:nil];
    return self;
}

- (id)initWithID:(NSString *)myID name:(NSString *)myName {
    if (myID == nil) {
        [NSException raise:@"invalid value" format:@"ID should not be nil"];
    }
    self = [super init];
    if (self) {
        ID = myID;
        name = myName;
    }
    return self;
}

- (NSString *)ID {
    return ID;
}
- (NSString *)name {
    return name;
}

@end
