//
//  SettingBackgroundViewController.h
//  ExpenseSheet
//
//  Created by Quratulain on 1/10/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingBackgroundViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UITableView *themesTable;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property NSInteger currentThemeIndex;
@end
