//
//  SignupViewController.m
//  sample-chat
//
//  Created by Atul Manwar on 29/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import "SignupViewController.h"
#import "CBUser.h"

@interface SignupViewController ()
@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+150);
    self.navigationController.navigationBarHidden = true;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)signUp:(id)sender {
    [[CBUser sharedManager] setPhone:self.phoneNo.text];
    [[CBUser sharedManager] setPasswd:self.passwordTF.text];
    [self performSegueWithIdentifier:@"profile" sender:self];
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
