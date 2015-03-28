//
//  Trend.h
//  sample-chat
//
//  Created by Atul Manwar on 28/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trend : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *summary;

-(id) initWithDict:(NSDictionary *) dict;
@end
