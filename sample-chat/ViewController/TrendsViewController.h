//
//  TrendsViewController.h
//  sample-chat
//
//  Created by Atul Manwar on 28/03/15.
//  Copyright (c) 2015 Igor Khomenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrendsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end
