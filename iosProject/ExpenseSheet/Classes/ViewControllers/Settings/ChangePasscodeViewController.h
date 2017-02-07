//
//  ChangePasscodeViewController.h
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasscodeViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *previousPasscodeView;
@property (weak, nonatomic) IBOutlet UIView *createNewPasscodeView;
@property (weak, nonatomic) IBOutlet UITextField *enterField;
@property (weak, nonatomic) IBOutlet UITextField *confirmField;
@property (weak, nonatomic) IBOutlet UITextField *previousField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *previousViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *previousPasscodeDoneButton;


@end
