//
//  TrendsViewController.m
//  sample-chat
//
//  Created by Atul Manwar on 28/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import "TrendsViewController.h"
#import "TrendTableViewCell.h"
#import "GetTrendsResponse.h"
#import "CBCategory.h"
#import "Trend.h"
#import "SplashViewController.h"
#import "СhatViewController.h"

@interface TrendsViewController ()
@property (nonatomic, strong) GetTrendsResponse *results;
@end

@implementation TrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getTrends];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) getTrends {
    NSURL *aUrl = [NSURL URLWithString:@"http://api.myjson.com/bins/176rr"];
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
         self.results = [[GetTrendsResponse alloc] initWithDict:dict];
         dispatch_async(dispatch_get_main_queue(), ^{
             [self.tableView reloadData];
         });
     }];
    [queue waitUntilAllOperationsAreFinished];
}

#pragma mark UITableViewDelegate & UITableViewDataSource
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.results) {
        CBCategory *category = self.results.categories[section];
        return category.name;
    } else {
        return @"";
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.results) {
        return self.results.categories.count;
    } else {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.results) {
        CBCategory *category = self.results.categories[section];
        return category.trends.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reusableIdentifier = @"trend_cell";
    TrendTableViewCell *cell = (TrendTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reusableIdentifier];
    if(cell == nil){
        cell = [[TrendTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    CBCategory *category = self.results.categories[indexPath.section];
    Trend *trend = category.trends[indexPath.row];
    [cell configureCellWithTrend:trend];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"ShowChatViewControllerSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier  isEqual: @"ShowChatViewControllerSegue"]) {
        ChatViewController *vc = (ChatViewController *)[segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CBCategory *category = self.results.categories[indexPath.section];
        vc.trend = category.trends[indexPath.row];
    }
}

@end
