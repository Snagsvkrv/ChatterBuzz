//
//  ProfileViewController.m
//  sample-chat
//
//  Created by Atul Manwar on 29/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import "ProfileViewController.h"
#import "CBUser.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = false;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)nextClicked:(id)sender; {
    [[CBUser sharedManager] setUserName:self.name.text];
    [[CBUser sharedManager] setStatusMsg:self.status.text];
    [self createUser];
}

-(void) createUser {
    NSURL *aUrl = [NSURL URLWithString:@"http://localhost:3000/users.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:[[CBUser sharedManager]userName], @"name", [[CBUser sharedManager]passwd], @"password", [[CBUser sharedManager]phone], @"phone_no", nil];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
//    NSString *params = [NSString stringWithFormat:@"name=%@&password=%@&phone_no=%@", [[CBUser sharedManager]userName], [[CBUser sharedManager]passwd], [[CBUser sharedManager]phone]];
//    NSData *dataParams = [params dataUsingEncoding:NSUTF8StringEncoding];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                              options: NSJSONReadingMutableContainers
                                                                error: &error];
         if (!error) {
             NSString * userId = [[dict valueForKey:@"id"] stringValue];
             [[CBUser sharedManager]setUser_id: userId];
             [[CBUser sharedManager] saveData];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self performSegueWithIdentifier:@"interests" sender:self];
             });
         }
     }];
    [queue waitUntilAllOperationsAreFinished];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
