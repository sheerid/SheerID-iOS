//
//  Person.m
//  SheerIDMobile
//
//  Created by Alexander Boone on 3/19/12.
//  Copyright (c) 2012 SheerID, Inc. All rights reserved.
//

#import "SheerIDMobile.h"

@interface Person()
{
@private
    NSMutableDictionary *data;
}

@end


@implementation Person

- (id)init {
    self = [super init];
    if (self) {
        data = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (NSEnumerator *)fieldEnumerator {
    NSMutableArray *fields = [NSMutableArray array];
    for (NSString *key in [data keyEnumerator]) {
        [fields addObject:[[[Field alloc] initWithCode:key] autorelease]];
    }
    return [fields objectEnumerator];
}

- (void)addValue:(NSString *)value forField:(Field *)field {
    [data setValue:value forKey:field.code];
}

- (BOOL)hasValueForField:(Field *)field {
    return !![self valueForField:field];
}

- (NSString *)valueForField:(Field *)field {
    return [data valueForKey:field.code];
}

@end
