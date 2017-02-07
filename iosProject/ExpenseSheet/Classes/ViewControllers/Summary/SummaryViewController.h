//
//  SummaryViewController.h
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface SummaryViewController : UIViewController<XYPieChartDelegate,XYPieChartDataSource,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;
@property (weak, nonatomic) IBOutlet UITableView *summaryTable;
@property (weak, nonatomic) IBOutlet UILabel *noExpenseLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
