//
//  InterestsViewController.m
//  sample-chat
//
//  Created by Atul Manwar on 29/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import "InterestsViewController.h"
#import "GetInterestsResponse.h"
#import "CBCategory.h"
#import "CBUser.h"

@interface InterestsViewController ()
@property (nonatomic, strong) GetInterestsResponse *results;
@property (nonatomic, strong) NSMutableArray *tags;
@end

@implementation InterestsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getInterests];
    self.tags = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
}

-(void) configureView {
    CGRect frame = CGRectMake(20, 150, 120, 44);
    for (int i = 0; i < self.results.categories.count; i++) {
        CBCategory *category = self.results.categories[i];
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        [button setTitle:category.name forState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        [button setTitleColor:[UIColor colorWithRed:(79/255.0) green:(146/255.0) blue:(223/255.0) alpha:1.0] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor colorWithRed:(79/255.0) green:(146/255.0) blue:(223/255.0) alpha:1.0].CGColor;
        button.layer.borderWidth = 1.0;
        
        [button setTag:i];
        [button addTarget:self action:@selector(tagSelected:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 22;
        [self.view addSubview:button];
        frame.origin.x = (i%2==0) ? 180 : 20;
        frame.origin.y = (i%2==0) ? frame.origin.y : (frame.origin.y + 60);
    }
}

-(void) tagSelected:(UIButton*) sender {
    UIColor *color = [UIColor whiteColor];
    UIColor *borderColor = [UIColor colorWithRed:(79/255.0) green:(146/255.0) blue:(223/255.0) alpha:1.0];
    NSString *tag = [NSString stringWithFormat:@"%li", (long)sender.tag];
    if ([self.tags containsObject:tag]) {
        [self.tags removeObject:tag];
        UIColor *temp = color;
        color = borderColor;
        borderColor = temp;
    } else {
        [self.tags addObject:tag];
    }
    sender.backgroundColor = borderColor;
    sender.layer.borderColor = [UIColor colorWithRed:(79/255.0) green:(146/255.0) blue:(223/255.0) alpha:1.0].CGColor;
    [sender setTitleColor:color forState:UIControlStateNormal];
}

-(void) createInterests {
    NSMutableString *string = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < self.tags.count; i++) {
        NSString *tag = self.tags[i];
        if (i == self.tags.count-1) {
            [string appendString:tag];
        } else {
            [string appendFormat:@"%@,", tag];
        }
    }
    NSURL *aUrl = [NSURL URLWithString:@"http://localhost:3000/fetch/create.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSDictionary *postDict = [NSDictionary dictionaryWithObjectsAndKeys:[[CBUser sharedManager] user_id], @"user_id", string, @"interests", nil];
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
//         NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
//                                                              options: NSJSONReadingMutableContainers
//                                                                error: &error];
//         if (!error) {
//             NSString * userId = [[dict valueForKey:@"id"] stringValue];
//             [[CBUser sharedManager]setUser_id: userId];
//             [[CBUser sharedManager] saveData];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self performSegueWithIdentifier:@"login_user" sender:self];
             });
//         }
     }];
    [queue waitUntilAllOperationsAreFinished];
}

-(void) getInterests {
    NSURL *aUrl = [NSURL URLWithString:@"http:/localhost:3000/interests.json"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                              options: NSJSONReadingMutableContainers
                                                                error: &error];
         self.results = [[GetInterestsResponse alloc] initWithDict:dict];
         dispatch_async(dispatch_get_main_queue(), ^{
             [self configureView];
         });
     }];
    [queue waitUntilAllOperationsAreFinished];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)login:(id)sender {
    [self createInterests];
//    [self performSegueWithIdentifier:@"login_user" sender:self];
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
