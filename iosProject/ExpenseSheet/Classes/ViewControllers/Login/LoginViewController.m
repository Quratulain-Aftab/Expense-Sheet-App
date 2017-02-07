//
//  LoginViewController.m
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/17/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import "LoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "Utilities.h"
#import "MBProgressHUD.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
       [self makeUIAdjustments];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Do any additional setup after loading the view
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"useTouchID"]==YES)
    {
        [self.emailTextfield resignFirstResponder];
    
        
        [self showLocalAuthenticationAlert];
    }
    else
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"Passcode"])
    {
        self.EnterPasscodeView.frame=self.view.frame;
        [self.view addSubview:self.EnterPasscodeView];
        
    }
  
 }
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"Passcode"])
    {
    }
    else
    {
        self.loginviewTop.constant=50;
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
    self.emailTextfield.delegate=self;
    self.passwordTextfield.delegate=self;
    self.passcodeField.delegate=self;
    
    //self.loginButton.enabled=false;
    
    self.passcodeField.keyboardType=UIKeyboardTypeNumberPad;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"Passcode"])
    {
        [self.passcodeField becomeFirstResponder];
    }
    else
    {
        [self.emailTextfield becomeFirstResponder];
    }
    
    
    self.loginButton.layer.cornerRadius=5.0;
    
    self.loginButton.backgroundColor=[[Utilities shareManager]backgroundColor];
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];

}
#pragma mark -
#pragma mark === Buttons ===
#pragma mark -
- (IBAction)goButtonAction:(id)sender {
    
    if([self.passcodeField.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Passcode"]])
        {
            [self performSegueWithIdentifier:@"homesegue" sender:nil];
        }
        else
        {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Incorrect Passcode" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
    
}
- (IBAction)forgotButtonAction:(id)sender {
    
    [self.passcodeField resignFirstResponder];
    [self.emailTextfield becomeFirstResponder];
    
    [self.EnterPasscodeView setHidden:YES];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)LoginButtonAction:(id)sender {
    
    if([self.emailTextfield.text isEqualToString:@"qurat"] && [self.passwordTextfield.text isEqualToString:@"1234"])
    {
         [self performSegueWithIdentifier:@"craetepasscodesegue" sender:nil];
    }
    else
    {
        
        [self.emailTextfield resignFirstResponder];
        [self.passwordTextfield resignFirstResponder];
        
        
        [MBProgressHUD hideHUDForView:self.view animated:NO];
        
        MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.labelText=@"Invalid user name or password";
        
        hud.mode=MBProgressHUDModeText;
        
        hud.labelFont=[UIFont fontWithName:@"Arial" size:12];
        
        hud.center=self.view.center;
        
        hud.removeFromSuperViewOnHide=YES;
        
        [hud hide:YES afterDelay:0.5];
    }
   
}
#pragma mark -
#pragma mark === Gesture Handler ===
#pragma mark -
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //   CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    [self.emailTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    //Do stuff here...
}

#pragma mark - UITextfield Delegate
-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
        //This'll Show The cancelButton with Animation
    
    self.loginviewTop.constant=20;
    return YES;
}
-(BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
     //   self.loginviewTop.constant=200;
    //This'll Show The cancelButton with Animation
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField==self.emailTextfield)
    {
        [self.passwordTextfield becomeFirstResponder];
        [self.passwordTextfield isFocused];
    }
    else if (self.passwordTextfield==textField)
    {
        [self LoginButtonAction:nil];
    }
    return YES;
}
-(bool)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.loginviewTop.constant=20;
    
    if(textField==self.passcodeField)
    {
        if(string.length==0)
        {
            return YES;
        }
        if(textField.text.length==3)
        {
          NSString *currentString = [self.passcodeField.text stringByReplacingCharactersInRange:range withString:string];
            
             //NSLog(@"passcode textfield text is %@",self.passcodeField.text);
            // NSLog(@"passcode enetered is %@",self.passcodeField.text);
            NSLog(@"passcode enetered is %@",currentString);
            
            if( [currentString isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"Passcode"]])
        {
             [self performSegueWithIdentifier:@"homesegue" sender:nil];
        }
        else
        {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:@"Incorrect Passcode" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
            
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        }
      
        else if (textField.text.length>3)
        {
            return NO;
        }
    }
    else if (self.emailTextfield.text.length>3 && self.passwordTextfield.text.length>3)
    {
        self.loginButton.enabled=true;
    }
    return YES;
}
#pragma mark -
#pragma mark === Helper Methods ===
#pragma mark -
-(void)showLocalAuthenticationAlert
{
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"Authentication is required to access your expense sheets list";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        //  [self performSegueWithIdentifier:@"Success" sender:nil];
                                        NSLog(@"success");
                                        [self performSegueWithIdentifier:@"homesegue" sender:nil];
                                        
                                    });
                                } else {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                            message:error.description
                                                                                           delegate:self
                                                                                  cancelButtonTitle:@"OK"
                                                                                  otherButtonTitles:nil, nil];
                                        [alertView show];
                                        // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
                                    });
                                }
                            }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:authError.description
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
            
        
            [alertView show];
            // Rather than show a UIAlert here, use the error to determine if you should push to a keypad for PIN entry.
        });
    }
}
@end
