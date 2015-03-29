//
//  GetInterestsResponse.h
//  sample-chat
//
//  Created by Atul Manwar on 29/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetInterestsResponse : NSObject
@property (nonatomic, strong) NSMutableArray *categories;

-(id) initWithDict:(NSDictionary *) dict;

@end
