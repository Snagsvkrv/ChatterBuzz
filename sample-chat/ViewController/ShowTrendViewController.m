//
//  ShowTrendViewController.m
//  sample-chat
//
//  Created by Atul Manwar on 29/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import "ShowTrendViewController.h"
#import "UsersViewController.h"

@implementation ShowTrendViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:self.trend.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 23)];
    [button setImage:[UIImage imageNamed:@"Bitmap.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openChat:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbutton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barbutton;
}

-(void) openChat:(UIButton *) sender{
    [self performSegueWithIdentifier:@"ShowUsersViewControllerSegue" sender:self];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"ShowUsersViewControllerSegue"]) {
        UsersViewController *vc = (UsersViewController *)[segue destinationViewController];
        vc.trend = self.trend;
    }
}

-(void) webViewDidFinishLoad:(UIWebView *)webView {
    
}

-(void) webViewDidStartLoad:(UIWebView *)webView {
    
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end
