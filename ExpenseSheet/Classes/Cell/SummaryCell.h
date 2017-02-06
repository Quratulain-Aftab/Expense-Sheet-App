//
//  SummaryCell.h
//  ExpenseSheet
//
//  Created by Quratuain on 1/26/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;

@end
