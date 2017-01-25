//
//  TodayViewController.m
//  ExpenseSheetWidget
//
//  Created by Quratulain on 1/4/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "Constants.h"
#import <CoreData/CoreData.h>

@interface TodayViewController () <NCWidgetProviding>
@property NSMutableArray *dataSource;
@end
// Making changes for the sake of testing GIT Checkin/checkout
@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.createNewExpenseSheetButton.layer.cornerRadius=3.0;
//     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:AppDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    
   
  }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:AppGroupName];
    NSLog(@"desc is %@", [mySharedDefaults objectForKey:@"Description"]);
    NSString *desc= [mySharedDefaults objectForKey:@"Description"];
    NSString *startDate= [mySharedDefaults objectForKey:@"Duration"];
    
    
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"MM-dd-yy"];
    
    
    if([self  isDateBelongsToCurrentWeek:[df dateFromString:startDate]])
    {
        // self.noExpenseSheetLabel.hidden=NO;
        
        self.currentWeekCell.textLabel.text=desc;
        
        self.currentWeekCell.detailTextLabel.text=startDate;
    }
    else
    {
        
        self.noExpenseSheetLabel.hidden=NO;
        
        // self.cellHeight.constant=0;
        
        self.currentWeekCell.hidden=YES;
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    

    completionHandler(NCUpdateResultNewData);
    NSLog(@"widgetPerformUpdateWithCompletionHandler");
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:AppGroupName];
    NSLog(@"desc is %@", [mySharedDefaults objectForKey:@"Description"]);
   NSString *desc= [mySharedDefaults objectForKey:@"Description"];
   NSString *startDate= [mySharedDefaults objectForKey:@"Duration"];
    
    
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    
    [df setDateFormat:@"MM-dd-yy"];
    
    
if([self  isDateBelongsToCurrentWeek:[df dateFromString:startDate]])
{
   // self.noExpenseSheetLabel.hidden=NO;
    
    self.currentWeekCell.textLabel.text=desc;
    
    self.currentWeekCell.detailTextLabel.text=startDate;
}
else
{
   
    self.noExpenseSheetLabel.hidden=NO;
    
   // self.cellHeight.constant=0;
    
    self.currentWeekCell.hidden=YES;
}
 }
- (IBAction)createNewExpenseSheetButtonAction:(id)sender {
    
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:AppGroupName];
    // Use the shared user defaults object to update the user's account
    [mySharedDefaults setObject:@"OpenCreateSheetView" forKey:@"task"];
    NSURL *pjURL = [NSURL URLWithString:@"expensesheet://expensesheet"];
    [self.extensionContext openURL:pjURL completionHandler:nil];
}
-(void)refreshData:(NSNotification *)notification
{
    NSLog(@"refresh data");
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:AppGroupName];
    NSLog(@"desc is %@", [mySharedDefaults objectForKey:@"Description"]);
    [mySharedDefaults objectForKey:@"Description"];
   //  [self.createNewExpenseSheetButton setTitle: [mySharedDefaults objectForKey:@"Description"] forState:UIControlStateNormal] ;
}
-(BOOL)isDateBelongsToCurrentWeek:(NSDate *)date
{
    if ([self numberOfWeek:[NSDate date]] == [self numberOfWeek:date])
    {
        NSLog(@"Same Week");
        return YES;
    }
    else
    {
        NSLog(@"Different Week");
        return false;
    }
    
}
- (NSInteger)numberOfWeek:(NSDate *)date
{
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDateComponents *components = [calender components:NSCalendarUnitWeekOfYear fromDate:date];
    return [components weekOfYear];
}
-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    NSLog(@"tapped");
    NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:AppGroupName];
    // Use the shared user defaults object to update the user's account
    [mySharedDefaults setObject:@"OpenCurrentSheetDetaiView" forKey:@"task"];

    
    NSURL *pjURL = [NSURL URLWithString:@"expensesheet://expensesheet"];
    [self.extensionContext openURL:pjURL completionHandler:nil];
}
@end
