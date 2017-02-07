//
//  CombineViewController.h
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol sendDataBack <NSObject>
-(void)sendDataToPreviousControllerWhereCustomer:(NSString *)customerName andProject:(NSString *)projectName;
@end
@interface CombineViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource>
@property (assign,nonatomic) id delegate;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UITableView *combineViewTable;
@property (weak, nonatomic) IBOutlet UIView *pickerBackView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *pickerviewTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *pickerViewDoneButton;
@property (weak, nonatomic) IBOutlet UIButton *pickerViewCancelButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property NSString *existingCustomer;
@property NSString *existingProject;

@property NSString *selectedCustomer;
@property NSString *selectedProject;

@end
