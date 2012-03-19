//
//  OrganizationSearch.m
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import "SheerIDMobile.h"

@interface OrganizationSearch()
{
@private
    NSString *query;    
}

@end

@implementation OrganizationSearch

- (id)initWithQuery:(NSString *)myQuery {
    self = [super init];
    if (self) {
        query = myQuery;
    }
    return self;
}

- (NSString *)query {
    return query;
}

@end