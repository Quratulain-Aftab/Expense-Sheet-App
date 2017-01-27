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
    self.doneButton.enabled=false;
    
    [self.previousPasscodeDoneButton setBackgroundColor:[[Utilities shareManager] backgroundColor]];
    
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
    
    [self.previousField resignFirstResponder];
    [self.enterField resignFirstResponder];
    [self.confirmField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)doneButtonAction:(id)sender {
      [self.previousField resignFirstResponder];
    [self.enterField resignFirstResponder];
    [self.confirmField resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setObject:self.enterField.text forKey:@"Passcode"];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)previousPasscodeDoneButtonAction:(id)sender {
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:PasscodeUserDefault] isEqualToString:self.previousField.text])
    {
        self.previousViewHeight.constant=0;
        self.createNewPasscodeView.hidden=NO;
        self.previousPasscodeView.hidden=YES;
        self.previousPasscodeDoneButton.hidden=YES;
        self.previousField.hidden=YES;
        
    }
    else
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Incorrect Passcode" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }

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
    if(textField==self.previousField)
    {
        NSString *currentString = [self.previousField.text stringByReplacingCharactersInRange:range withString:string];
        int length = (int)[currentString length];
        if(self.previousField.text.length>2)
        {
            self.previousPasscodeDoneButton.enabled=true;
        }
        if(self.previousField.text.length>3)
        {
              return NO;
    }
    }

else if (textField==self.enterField)
{
    if(textField.text.length>3)
    {
        [self.confirmField isFocused];
        return NO;
        
    }
}
    else
    {
        if(textField.text.length>2)
        {
            self.doneButton.enabled=true;
        }
        if(textField.text.length>3)
 
            return NO;
         }
    
    return YES;
}
-(void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.previousField resignFirstResponder];
     [self.enterField resignFirstResponder];
     [self.confirmField resignFirstResponder];
}


@end
