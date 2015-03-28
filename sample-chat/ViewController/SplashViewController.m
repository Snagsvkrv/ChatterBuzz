//
//  SplashViewController.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/16/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "SplashViewController.h"

#define demoUserLogin @"atul"
#define demoUserPassword @"atulatul"

@interface SplashViewController () <QBActionStatusDelegate>

@end

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Your app connects to QuickBlox server here.
    //
    // QuickBlox session creation
    QBSessionParameters *extendedAuthRequest = [[QBSessionParameters alloc] init];
    extendedAuthRequest.userLogin = demoUserLogin;
    extendedAuthRequest.userPassword = demoUserPassword;
    //
    __weak __typeof(self)weakSelf = self;
    [QBRequest createSessionWithExtendedParameters:extendedAuthRequest successBlock:^(QBResponse *response, QBASession *session) {
        [self registerForRemoteNotifications];
        
        // Save current user
        //
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID;
        currentUser.login = demoUserLogin;
        currentUser.password = demoUserPassword;
        //
        [[LocalStorageService shared] setCurrentUser:currentUser];
        
        // Login to QuickBlox Chat
        //
        [[ChatService instance] loginWithUser:currentUser completionBlock:^{
            
            // hide alert after delay
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            });
        }];
        
    } errorBlock:^(QBResponse *response) {
        
        NSString *errorMessage = [[response.error description] stringByReplacingOccurrencesOfString:@"(" withString:@""];
        errorMessage = [errorMessage stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Errors"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles: nil];
        [alert show];
    }];
}

- (void)registerForRemoteNotifications{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
}


@end
