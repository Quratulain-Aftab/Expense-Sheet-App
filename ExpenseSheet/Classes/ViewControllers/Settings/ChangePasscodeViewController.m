//
//  ChangePasscodeViewController.m
//  ExpenseSheet
//
//  Created by SISC on 1/1/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "ChangePasscodeViewController.h"
#import "Utilities.h"
#import "Constants.h"

@interface ChangePasscodeViewController ()

@end

@implementation ChangePasscodeViewController
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
    
    self.createNewPasscodeView.hidden=YES;
    self.previousField.delegate=self;
    self.enterField.delegate=self;
    self.confirmField.delegate=self;
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];

    
}
#pragma mark -
#pragma mark === Buttons ===
#pragma mark -
- (IBAction)colseButtonAction:(id)sender {
      [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doneButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -
#pragma mark === UITextfield Delegate ===
#pragma mark -
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
       [textField resignFirstResponder];
        return YES;
}
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //Returning yes allows the entered chars to be processed
    
    if(string.length==0)
    {
        return YES;
    }
    if(self.previousField.text.length>3)
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:PasscodeUserDefault] isEqualToString:self.previousField.text])
        {
            self.previousViewHeight.constant=0;
            self.createNewPasscodeView.hidden=NO;
          //  return NO;
        }
        else
        {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Incorrect Passcode" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            return NO;
        }
      
        }
    return YES;
}
-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    
}

@end
