//
//  CBUser.m
//  sample-chat
//
//  Created by Atul Manwar on 29/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import "CBUser.h"

@implementation CBUser

+ (CBUser *)sharedManager {
    static CBUser *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CBUser alloc] init];
    });
    return sharedInstance;
}

- (id) init {
    if (self = [super init]) {
//        self.user_id = @"3";
        self.qbId = @"2646385";
        self.passwd = @"sneha123";
        self.userName = @"sneha";
        self.phone = @"9538341627";
        self.statusMsg = @"Available";
    }
    return self;
}

-(void) saveData {
    [[NSUserDefaults standardUserDefaults] setObject:[[CBUser sharedManager] user_id] forKey:@"user_id"];
    [[NSUserDefaults standardUserDefaults] setObject:[[CBUser sharedManager] qbId] forKey:@"qbId"];
    [[NSUserDefaults standardUserDefaults] setObject:[[CBUser sharedManager] passwd] forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] setObject:[[CBUser sharedManager] userName] forKey:@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:[[CBUser sharedManager] phone] forKey:@"phone"];
    [[NSUserDefaults standardUserDefaults] setObject:[[CBUser sharedManager] statusMsg] forKey:@"status"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) loadData {
    [[CBUser sharedManager] setUser_id:[[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"user_id"]];
    [[CBUser sharedManager] setQbId:[[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"qbId"]];
    [[CBUser sharedManager] setPasswd:[[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"password"]];
    [[CBUser sharedManager] setUserName:[[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"name"]];
    [[CBUser sharedManager] setPhone:[[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"phone"]];
    [[CBUser sharedManager] setStatusMsg:[[NSUserDefaults standardUserDefaults]
                                        stringForKey:@"status"]];
}

@end
