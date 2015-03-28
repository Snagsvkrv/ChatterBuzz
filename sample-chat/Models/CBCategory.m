//
//  Category.m
//  sample-chat
//
//  Created by Atul Manwar on 28/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import "CBCategory.h"
#import "Trend.h"

@implementation CBCategory

-(id) initWithDict:(NSDictionary *) dict {
    self = [super init];
    if (self) {
        self.name = [dict valueForKey:@"name"];
        NSArray *trend_details = [dict valueForKey:@"trends"];
        if (trend_details != nil) {
            self.trends = [[NSMutableArray alloc] init];
            for (int i = 0; i < trend_details.count; i++) {
                NSDictionary *trend_dict = [trend_details objectAtIndex:i];
                Trend *trend = [[Trend alloc] initWithDict:trend_dict];
                [self.trends addObject:trend];
            }
        }
    }
    return self;
}
@end