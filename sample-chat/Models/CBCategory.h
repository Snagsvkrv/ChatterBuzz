//
//  Category.h
//  sample-chat
//
//  Created by Atul Manwar on 28/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBCategory : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *category_id;
@property (nonatomic, strong) NSMutableArray *trends;

-(id) initWithDict:(NSDictionary *) dict;
@end
