//
//  GetTrendsResponse.m
//  sample-chat
//
//  Created by Atul Manwar on 28/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import "GetTrendsResponse.h"
#import "CBCategory.h"

@implementation GetTrendsResponse

-(id) initWithDict:(NSDictionary *) dict {
    self = [super init];
    if (self) {
        NSArray *category_details = [dict valueForKey:@"categories"];
        if (category_details != nil) {
            self.categories = [[NSMutableArray alloc] init];
            for (int i = 0; i < category_details.count; i++) {
                NSDictionary *category_dict = [category_details objectAtIndex:i];
                CBCategory *category = [[CBCategory alloc] initWithDict:category_dict];
                [self.categories addObject:category];
            }
        }
    }
    return self;
}
@end
