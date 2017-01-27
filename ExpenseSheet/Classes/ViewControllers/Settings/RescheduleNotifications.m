//
//  RescheduleNotifications.m
//  ExpenseSheet
//
//  Created by Quratulain on 1/11/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "RescheduleNotifications.h"
#import "Constants.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "UIButton+button.h"

@interface RescheduleNotifications ()

@end

@implementation RescheduleNotifications
{
    NSArray *weekDaysDataSource;
    NSArray *daysArray;
    NSMutableArray *datesArray;
    
    NSMutableArray *pickerDataSource;
    
    NSDateFormatter *df;
    NSInteger notificationDay;
    NSString *typeString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUIAdjustments];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    notificationDay=[[[Utilities shareManager]getUpdatedSettingsForString:NotificationDayKey] integerValue];
    if([typeString isEqualToString:@"Weekly"])
    {
        [self.dayPicker selectRow:notificationDay inComponent:0 animated:NO];
   
    }
    else
    {
        [self.dayPicker selectRow:notificationDay-1 inComponent:0 animated:NO];

    }
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
    self.titleView.backgroundColor=[[Utilities shareManager]backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    
    self.doneButton.hitTestEdgeInsets=UIEdgeInsetsMake(-5, -5, -5, -10);
    
    self.reminderTextField.delegate=self;
    
    self.dayPicker.delegate=self;
    self.dayPicker.dataSource=self;
    
      daysArray=[NSArray arrayWithObjects:@"Sunday",@"Monday",@"Tuesday",@"Wednesday",@"Thursday",@"Friday",@"Saturday", nil];
    datesArray=[[NSMutableArray alloc]init];
    for(int i=1;i<31;i++)
    {
        [datesArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    pickerDataSource=[[NSMutableArray alloc]init];
    
    
    if([[[Utilities shareManager]getUpdatedSettingsForString:NotificationTypeKey] isEqualToString:@"Daily"])
    {
        self.dayPickerHeight.constant=0;
        self.typeSegmentView.selectedSegmentIndex=0;
        typeString=@"Daily";

        
    }
    else if([[[Utilities shareManager]getUpdatedSettingsForString:NotificationTypeKey] isEqualToString:@"Weekly"])
    {
        self.typeSegmentView.selectedSegmentIndex=1;
        [pickerDataSource removeAllObjects];
        [pickerDataSource addObjectsFromArray:daysArray];
         typeString=@"Weekly";
    }
    else
    {
        // monthly
        self.typeSegmentView.selectedSegmentIndex=2;
        [pickerDataSource removeAllObjects];
        [pickerDataSource addObjectsFromArray:datesArray];
         typeString=@"Monthly";
    
    }
    
    df=[[NSDateFormatter alloc]init];
    [df setDateFormat:@"hh:mm a"];
    
    self.datePicker.date=[df dateFromString:[[Utilities shareManager]getUpdatedSettingsForString:NotificationTimeKey]];
    
  notificationDay=[[[Utilities shareManager]getUpdatedSettingsForString:NotificationDayKey] integerValue];
     [self.dayPicker selectRow:notificationDay inComponent:0 animated:NO];
    
    self.typeSegmentView.tintColor=[[Utilities shareManager]backgroundColor];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];

    }
#pragma mark -
#pragma mark === Buttons ===
#pragma mark -
- (IBAction)doneButtonAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:DidSettingsChangedUserDefault];
    
    [self.reminderTextField resignFirstResponder];
    
    [[Utilities shareManager]updateSettingsstring:[df stringFromDate:self.datePicker.date] forKey:NotificationTimeKey];
    [[Utilities shareManager]updateSettingsstring:[NSString stringWithFormat:@"%ld",notificationDay] forKey:NotificationDayKey];
    
    [[Utilities shareManager]updateSettingsstring:typeString forKey:NotificationTypeKey];
    
    [self performSelectorInBackground:@selector(rescheduleNotifications) withObject:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
  
}
#pragma mark -
#pragma mark === UITextfield Delegate ===
#pragma mark -
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - UIPickerView Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerDataSource.count;
}
// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
       return pickerDataSource[row];
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35.0;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(self.typeSegmentView.selectedSegmentIndex==1)
    {
        // weekly
        notificationDay=row;
        return;
    }
    // monthly
    notificationDay=row+1;
}
#pragma mark - Segment Value Changed
- (IBAction)segmentViewValueChanged:(id)sender {
    
    if(self.typeSegmentView.selectedSegmentIndex==0)
    {
        self.dayPickerHeight.constant=0;
        typeString=@"Daily";
        self.descriptionLabel.hidden=YES;
          //  [self.dayPicker selectRow:notificationDay inComponent:0 animated:NO];
        
    }
    else if (self.typeSegmentView.selectedSegmentIndex==1)
    {
        self.dayPickerHeight.constant=150;
        [pickerDataSource removeAllObjects];
        [pickerDataSource addObjectsFromArray:daysArray];
        [self.dayPicker reloadAllComponents];
        typeString=@"Weekly";
          self.descriptionLabel.hidden=NO;
        self.descriptionLabel.text=@"Notification Day";
    }
    else
    {
        self.dayPickerHeight.constant=150;
        [pickerDataSource removeAllObjects];
        [pickerDataSource addObjectsFromArray:datesArray];
        [self.dayPicker reloadAllComponents];
        typeString=@"Monthly";
          self.descriptionLabel.hidden=NO;
        self.descriptionLabel.text=@"Notification Date";


    }
      [self.dayPicker selectRow:notificationDay inComponent:0 animated:NO];
}
#pragma mark - Gesture
-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.reminderTextField resignFirstResponder];
}
-(void)rescheduleNotifications
{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate setupLocalNotifications];
}
@end
