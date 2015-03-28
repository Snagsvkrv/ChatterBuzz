//
//  Trend.m
//  sample-chat
//
//  Created by Atul Manwar on 28/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import "Trend.h"

@implementation Trend

-(id) initWithDict:(NSDictionary *) dict {
    self = [super init];
    if (self) {
        self.name = [dict valueForKey:@"name"];
        self.summary = [dict valueForKey:@"description"];
        self.url = [dict valueForKey:@"url"];
    }
    return self;
}

@end