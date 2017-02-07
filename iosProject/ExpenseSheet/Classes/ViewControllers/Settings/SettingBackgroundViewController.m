//
//  SettingBackgroundViewController.m
//  ExpenseSheet
//
//  Created by Quratulain on 1/10/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "SettingBackgroundViewController.h"
#import "ThemeCell.h"
#import "Utilities.h"
#import "Constants.h"

@interface SettingBackgroundViewController ()

@end

@implementation SettingBackgroundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self makeUIAdjustments];
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
    
    self.currentThemeIndex=[[[Utilities shareManager] getUpdatedSettingsForString:ThemeKey] integerValue];
    self.doneButton.enabled=false;
    
}
#pragma mark -
#pragma mark === Buttons ===
#pragma mark -
- (IBAction)closeButtonAction:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doneButtonAction:(id)sender {
    [[Utilities shareManager] updateSettingsstring:[NSString stringWithFormat:@"%ld",self.currentThemeIndex] forKey:ThemeKey];
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:DidSettingsChangedUserDefault];
      [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark === Tableview ===
#pragma mark -
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier=[NSString stringWithFormat:@"ThemeCell"];
    
    ThemeCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.themeImgeView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%ld",indexPath.row]];
    cell.themeLabel.text=[NSString stringWithFormat:@"Theme %ld",indexPath.row];
    
    UIView *selectedBackgorundView=[[UIView alloc]initWithFrame:cell.bounds];
    selectedBackgorundView.backgroundColor=[UIColor clearColor];
    cell.selectedBackgroundView=selectedBackgorundView;
    
    if(self.currentThemeIndex==indexPath.row)
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 7;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (self.currentThemeIndex == indexPath.row) {
        return;
    }
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:self.currentThemeIndex inSection:0];
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.currentThemeIndex = indexPath.row;
    }
    
    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    self.doneButton.enabled=true;

}
@end
