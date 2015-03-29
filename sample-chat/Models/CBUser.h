//
//  CBUser.h
//  sample-chat
//
//  Created by Atul Manwar on 29/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DialogsViewController.h"

@interface CBUser : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *qbId;
@property (nonatomic, strong) NSString *passwd;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *statusMsg;
@property (nonatomic, weak) DialogsViewController *dialogView;

+(id) sharedManager;
-(void) saveData;
-(void) loadData;
@end
