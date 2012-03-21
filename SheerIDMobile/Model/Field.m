//
//  Field.m
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import "SheerIDMobile.h"
#import "SheerIDMobile+Private.h"

@implementation Field

+ (Field *)fieldWithCode:(NSString *)code {
    return [[[Field alloc] initWithCode:code] autorelease];
}

+ (Field *)fieldWithCode:(NSString *)code displayName:(NSString *)displayName {
    return [[[Field alloc] initWithCode:code displayName:displayName] autorelease];
}

@end
