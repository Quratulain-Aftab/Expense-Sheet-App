//
//  RescheduleNotifications.h
//  ExpenseSheet
//
//  Created by Quratulain on 1/11/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RescheduleNotifications : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property (weak, nonatomic) IBOutlet UITextField *reminderTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSegmentView;
@property (weak, nonatomic) IBOutlet UIPickerView *dayPicker;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dayPickerHeight;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
