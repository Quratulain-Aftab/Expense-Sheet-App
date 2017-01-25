//
//  TodayViewController.h
//  ExpenseSheetWidget
//
//  Created by Quratulain on 1/4/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *createNewExpenseSheetButton;
@property (weak, nonatomic) IBOutlet UITableViewCell *currentWeekCell;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeight;
@property (weak, nonatomic) IBOutlet UILabel *noExpenseSheetLabel;

@end
