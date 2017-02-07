//
//  WeekStartDayViewController.m
//  ExpenseSheet
//
//  Created by Quratulain on 1/11/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "WeekStartDayViewController.h"
#import "Constants.h"
#import "Utilities.h"
#import "UIButton+button.h"

@interface WeekStartDayViewController ()

@end

@implementation WeekStartDayViewController
{
    NSArray *weekDaysDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUIAdjustments];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneButtonAction:(id)sender {
    
     [[NSUserDefaults standardUserDefaults] setBool:YES forKey:DidSettingsChangedUserDefault];
    [[Utilities shareManager] updateSettingsstring:[NSString stringWithFormat:@"%ld",self.currentDayIndex+1] forKey:WeekStartDayKey];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)makeUIAdjustments
{
    self.titleView.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    
    self.closeButton.hitTestEdgeInsets=UIEdgeInsetsMake(-5, -5, -5, -10);
    
   
    weekDaysDataSource=[NSArray arrayWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
    self.weekDaysTable.delegate=self;
    self.weekDaysTable.dataSource=self;
    self.weekDaysTable.tableHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    
    self.currentDayIndex=[[[Utilities shareManager] getUpdatedSettingsForString:WeekStartDayKey] integerValue]-1;
    self.doneButton.enabled=false;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WeekDayCell" forIndexPath:indexPath];
    
    cell.textLabel.text=[weekDaysDataSource objectAtIndex:indexPath.row];
    
    if (indexPath.row==self.currentDayIndex)
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView=nil;
    }

      UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
    selectedBackgorundView.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
    cell.selectedBackgroundView=selectedBackgorundView;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return weekDaysDataSource.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (self.currentDayIndex == indexPath.row) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.currentDayIndex inSection:0];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentDayIndex =indexPath.row;
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
     self.doneButton.enabled=true;
    
}


@end
