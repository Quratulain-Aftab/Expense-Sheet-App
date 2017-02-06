//
//  SummaryViewController.m
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "SummaryViewController.h"
#import "Utilities.h"
#import "Model.h"
#import "SummaryCell.h"
#import "Constants.h"
#import "MBProgressHUD.h"

@interface SummaryViewController ()
@property NSMutableArray *slices;
@property(nonatomic, strong) NSArray *sliceColors;
@end

@implementation SummaryViewController
{
    NSMutableArray *dataSource;
    NSDateFormatter *df;
    NSMutableArray *categoriesList;
    NSMutableArray *occuranceList;
    
    NSDate *currentDate;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUIAdjustments];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.pieChart reloadData];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark === Configuring View ===
#pragma mark -
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)makeUIAdjustments
{
    occuranceList=[[NSMutableArray alloc]init];
    categoriesList=[[NSMutableArray alloc]init];

    currentDate=[self getFirstDateOfMonth:[NSDate date]];
    dataSource=[[Model fetchDataFromTable:ExpenseSheetDetailTable withStartDate:[self getFirstDateOfMonth:[NSDate date]] andEndDate:[self getLastDateOfMonth:[NSDate date]]] mutableCopy];
    
    [self getGraphInfo];
    
    self.titleView.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    
    // ------- Gestures
    UISwipeGestureRecognizer *leftSwipeGestue = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(leftSwipeHandler:)];
    leftSwipeGestue.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGestue];
    
    
    UISwipeGestureRecognizer *rightSwipeGestue = [[UISwipeGestureRecognizer alloc] initWithTarget:self  action:@selector(rightSwipeHandler:)];
    rightSwipeGestue.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGestue];
    

    
    
    // make chart
    self.slices = [NSMutableArray arrayWithCapacity:10];
    
//    for(int i = 0; i < 5; i ++)
//    {
//        NSNumber *one = [NSNumber numberWithInt:rand()%60+20];
//        [_slices addObject:one];
//    }
    self.pieChart.backgroundColor=[UIColor clearColor];
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setShowPercentage:YES];
    [self.pieChart setLabelColor:[UIColor blackColor]];
    
    
    UIColor *color1= [[Utilities shareManager]backgroundColorWithAlpha:0.2];
    UIColor *color2= [[Utilities shareManager]backgroundColorWithAlpha:0.4];
    UIColor *color3= [[Utilities shareManager]backgroundColorWithAlpha:0.6];
    UIColor *color4= [[Utilities shareManager]backgroundColorWithAlpha:0.8];
    UIColor *color5= [[Utilities shareManager]backgroundColorWithAlpha:1.0];
    
    self.sliceColors =[NSArray arrayWithObjects:
                       color1,
                       color2,color3,color4,color5,nil];


    df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"E MM-dd-yy"];
    
    if(dataSource.count<=0)
    {
        self.noExpenseLabel.hidden=NO;
        self.summaryTable.hidden=YES;
        self.pieChart.hidden=YES;
        
    }
    else
    {
        self.noExpenseLabel.hidden=YES;
        self.summaryTable.hidden=NO;
        self.pieChart.hidden=NO;
    }

    
   
}
-(void)adjustTable
{
    
    self.subtitleLabel.text=[[Utilities shareManager]getDateOfMonth:currentDate];
    
    NSLog(@"new date is %@",currentDate);
    
    [dataSource removeAllObjects];
    
    dataSource=[[Model fetchDataFromTable:ExpenseSheetDetailTable withStartDate:[self getFirstDateOfMonth:currentDate] andEndDate:[self getLastDateOfMonth:currentDate]] mutableCopy];
    
    [self getGraphInfo];

    
    [self.summaryTable reloadData];
    [self.pieChart reloadData];

    if(dataSource.count<=0)
    {
        self.noExpenseLabel.hidden=NO;
        self.summaryTable.hidden=YES;
        self.pieChart.hidden=YES;
        
    }
    else
    {
        self.noExpenseLabel.hidden=YES;
        self.summaryTable.hidden=NO;
        self.pieChart.hidden=NO;
    }
    
   

}
#pragma mark -
#pragma mark === Buttons ===
#pragma mark -
- (IBAction)backButtonAction:(id)sender {
    
      [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark === Gestures ===
#pragma mark -
-(void)leftSwipeHandler:(UIGestureRecognizer *)gestureRecognizer
{
 // next
    
    if(![currentDate isEqualToDate:[self getFirstDateOfMonth:[NSDate date]]])
    {
    
    currentDate=[self getPreviousOrNextMonthDateFrom:currentDate andCarry:1];

    [self adjustTable];
    }
    
    
}
-(void)rightSwipeHandler:(UIGestureRecognizer *)gestureRecognizer
{
    // previous
   
    currentDate=[self getPreviousOrNextMonthDateFrom:currentDate andCarry:-1];

    [self adjustTable];
}
#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return categoriesList.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[occuranceList objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
   // if(pieChart == self.pieChart) return nil;
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate
- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}
- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    //self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
    [MBProgressHUD hideHUDForView:self.view animated:NO];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode=MBProgressHUDModeText;
    
    hud.labelFont=[UIFont fontWithName:@"Arial" size:16];
    
    hud.center=self.view.center;
    
    hud.labelText=[categoriesList objectAtIndex:index];
    
    [hud sizeToFit];
    
    hud.removeFromSuperViewOnHide=YES;
    
    [hud hide:YES afterDelay:0.3];

}
#pragma mark - UITableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SummaryCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SummaryCell" forIndexPath:indexPath];
    
    if(indexPath.row==0)
    {
        cell.backgroundColor=[UIColor colorWithRed:234.0/255.0 green:235.0/255.0 blue:240.0/255.0 alpha:1.0];
        cell.dateLabel.text=@"Date";
        cell.categoryLabel.text=@"Expense Type";
        cell.amountLabel.text=@"Amount";
    }
    else
    {
        
        cell.backgroundColor=[UIColor clearColor];
        NSManagedObject *expense=[dataSource objectAtIndex:indexPath.row-1];
        cell.dateLabel.text=[df stringFromDate:[expense valueForKey:ExpenseDate]];
         NSLog(@"expense date is %@",[expense valueForKey:ExpenseDate]);
        cell.categoryLabel.text=[expense valueForKey:ExpenseType];
        cell.amountLabel.text=[NSString stringWithFormat:@"%@",[expense valueForKey:Amount]];
    }
    
   
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return dataSource.count+1;
}
#pragma mark - Date Methods
-(NSDate *)getLastDateOfMonth:(NSDate *)givenDate
{
    NSDate *now = [NSDate new];
    
    // get last day of the current month
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   // [calendar setTimeZone:[NSTimeZone localTimeZone]];
    
    NSRange dayRange = [ calendar rangeOfUnit:NSCalendarUnitDay
                                       inUnit:NSCalendarUnitMonth
                                      forDate:now];
    
    NSInteger numberOfDaysInCurrentMonth = dayRange.length;
    
    NSDateComponents *comp = [calendar components:
                              NSCalendarUnitYear |
                              NSCalendarUnitMonth |
                              NSCalendarUnitDay fromDate:givenDate];
    
    comp.day = numberOfDaysInCurrentMonth;
    comp.hour = 24;
    comp.minute = 0;
    comp.second = 0;
    
    NSDate *endOfMonth = [calendar dateFromComponents:comp];
    
    return endOfMonth;
}
-(NSDate *)getFirstDateOfMonth:(NSDate *)givenDate
{
   // NSDate *now = [NSDate new];
    
    // get last day of the current month
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
  //  [calendar setTimeZone:[NSTimeZone localTimeZone]];
    
   // NSRange dayRange = [ calendar rangeOfUnit:NSCalendarUnitDay
                                  //     inUnit:NSCalendarUnitMonth
                                    //  forDate:now];
    
   // NSInteger numberOfDaysInCurrentMonth = dayRange.length;
    
    
    
    NSDateComponents *comp = [calendar components:
                              NSCalendarUnitYear |
                              NSCalendarUnitMonth |
                              NSCalendarUnitDay fromDate:givenDate];
    
    comp.day = 1;
    comp.hour = 24;
    comp.minute = 0;
    comp.second = 0;
    
    NSDate *startOfMonth = [calendar dateFromComponents:comp];
    
    return startOfMonth;
}

-(void)getGraphInfo
{
    
    [categoriesList removeAllObjects];
    [occuranceList removeAllObjects];
    
    for(int i=0;i<dataSource.count;i++)
    {
        NSManagedObject *expense=[dataSource objectAtIndex:i];
        if(![categoriesList containsObject:[expense valueForKey:ExpenseType]])
        {
            [categoriesList addObject:[expense valueForKey:ExpenseType]];
            [occuranceList addObject:[NSNumber numberWithInt:1]];
            
        }
        else
        {
            NSInteger index=[categoriesList indexOfObject:[expense valueForKey:ExpenseType]];
            int prevOccurance=[[occuranceList objectAtIndex:index] intValue];
            [occuranceList replaceObjectAtIndex:index withObject:[NSNumber numberWithInt:prevOccurance+1]];
            
            
        }
    }
}
-(NSDate *)getPreviousOrNextMonthDateFrom:(NSDate *)date andCarry:(int)carry
{
    NSCalendar *gregorian=[NSCalendar currentCalendar];
    
    NSDateComponents *comps=[[NSDateComponents alloc]init];
    
    [comps setMonth:carry];
    
  NSDate *newDate=[gregorian dateByAddingComponents:comps toDate:date options:0];
    
    NSLog(@"returned date is %@",newDate);
    return newDate;
    
}
@end
