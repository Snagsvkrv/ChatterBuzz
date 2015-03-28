//
//  ChatMessageTableViewCell.h
//  sample-chat
//
//  Created by Igor Khomenko on 10/19/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trend.h"

@interface TrendTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *trendDescription;
@property (nonatomic, weak) IBOutlet UILabel *trendName;

-(void)configureCellWithTrend:(Trend *) trend;

@end
