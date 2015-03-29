//
//  MainNavigationController.m
//  sample-chat
//
//  Created by Atul Manwar on 29/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import "MainViewController.h"
#import "CBUser.h"

@implementation MainViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    if ([[CBUser sharedManager] user_id]) {
        [self performSegueWithIdentifier:@"login_user" sender:self];
    } else {
        [self performSegueWithIdentifier:@"logout_user" sender:self];
    }
}

@end
