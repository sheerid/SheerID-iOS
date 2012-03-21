//
//  AffiliationType.m
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import "SheerIDMobile.h"
#import "SheerIDMobile+Private.h"

@implementation AffiliationType

+ (AffiliationType *)affiliationTypeWithCode:(NSString *)code {
    return [[[AffiliationType alloc] initWithCode:code] autorelease];
}

@end