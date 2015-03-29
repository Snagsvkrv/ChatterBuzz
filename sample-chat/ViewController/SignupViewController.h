//
//  SignupViewController.h
//  sample-chat
//
//  Created by Atul Manwar on 29/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTextField.h"

@interface SignupViewController : UIViewController
@property (nonatomic, weak) IBOutlet UITextField *phoneNo;
@property (nonatomic, weak) IBOutlet UITextField *passwordTF;
@property (nonatomic, weak) IBOutlet UIButton *signupButton;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

-(IBAction)signUp:(id)sender;

@end
