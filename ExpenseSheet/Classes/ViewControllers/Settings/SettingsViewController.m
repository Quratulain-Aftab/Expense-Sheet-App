//
//  SettingsViewController.m
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "SettingsViewController.h"
#import "Utilities.h"
#import "Constants.h"
#import "SettingsCell.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController
{
    
    UIImage *themeImage;
    NSString *startWeek;
    NSString *notification;
    BOOL soundEffects;
    BOOL lock;
    
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:DidSettingsChangedUserDefault])
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:DidSettingsChangedUserDefault];
        [self fetchSettings];
        [self.settingsTable reloadData];
    }
    
     self.titleView.backgroundColor=[[Utilities shareManager]backgroundColor];
    
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
    
    self.settingsTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.settingsTable.bounds.size.width, 0.01f)];
    
    [self fetchSettings];
}
#pragma mark -
#pragma mark === Buttons Action ===
#pragma mark -
- (IBAction)backButtonAction:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark === Tableview ===
#pragma mark -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *cellIdentifier=[NSString stringWithFormat:@"SettingsCell%d",(int)indexPath.row];
    SettingsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(indexPath.row==1)
    {
        cell.themeImage.image=themeImage;
    }
    else if (indexPath.row==2)
    {
        [cell.startDayButton setTitle:startWeek forState:UIControlStateNormal];
    }
    else if (indexPath.row==3)
    {
         [cell.notificationButton setTitle:notification forState:UIControlStateNormal];
    }
    else if (indexPath.row==4)
    {
        cell.soundEffectsSwitch.on=soundEffects;
        cell.soundEffectsSwitch.onTintColor=[[Utilities shareManager] backgroundColor];
    }
    else if (indexPath.row==6)
    {
        cell.lockSwitch.on=lock;
        cell.lockSwitch.onTintColor=[[Utilities shareManager] backgroundColor];
    }
    
    UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
    selectedBackgorundView.backgroundColor=[UIColor clearColor];
    cell.selectedBackgroundView=selectedBackgorundView;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
- (BOOL)tableView:(UITableView *)tableView
shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0 || indexPath.row==5 || indexPath.row==8)
    {
        return NO;
    }
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.row==0 || indexPath.row==5 || indexPath.row==8)
    {
        return 40;
    }
    
    return 55;
}
#pragma mark -
#pragma mark === Helper Methods ===
#pragma mark -
-(void)fetchSettings
{
    themeImage=[UIImage imageNamed:[[Utilities shareManager] getUpdatedSettingsForString:ThemeKey]];
    NSString *weekStartDayString=[[Utilities shareManager] getUpdatedSettingsForString:WeekStartDayKey];
    startWeek=[self stringFromWeekday:[weekStartDayString integerValue]-1];
    
    NSString *notificationType;
    NSString *notificationDay;
    NSString *notificationTime;
    notificationType=[[Utilities shareManager] getUpdatedSettingsForString:NotificationTypeKey];
    notificationDay=[[Utilities shareManager] getUpdatedSettingsForString:NotificationDayKey];
    notificationTime=[[Utilities shareManager] getUpdatedSettingsForString:NotificationTimeKey];
   
    if([notificationType isEqualToString:@"Daily"])
    {
    }
    else if ([notificationType isEqualToString:@"Weekly"])
    {
     notification=[self stringFromWeekday:[notificationDay integerValue]];
        
    }
    else
    {
        // notification type is monthly
        
         notification=notificationDay;
        // notification=[self stringFromMonthDay:[notificationDay integerValue]];
    }
    

    notification=[notification stringByAppendingString:[NSString stringWithFormat:@", %@",notificationTime]];
    
    soundEffects=[[Utilities shareManager]getUpdatedSettings:SoundEffectsKey];
    lock=[[Utilities shareManager]getUpdatedSettings:LockKey];
}
- (NSString *)stringFromWeekday:(NSInteger)weekday {
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return dateFormatter.shortWeekdaySymbols[weekday];
}
- (NSString *)stringFromMonthDay:(NSInteger)monthday {
    NSDateFormatter * dateFormatter = [NSDateFormatter new];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return dateFormatter.shortMonthSymbols[monthday];
}
@end
