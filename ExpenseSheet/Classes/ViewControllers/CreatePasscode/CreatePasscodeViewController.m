//
//  CreatePasscodeViewController.m
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/22/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import "CreatePasscodeViewController.h"
#import "Utilities.h"
#import "Constants.h"

@interface CreatePasscodeViewController ()

@end

@implementation CreatePasscodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleView.backgroundColor=[[Utilities shareManager] backgroundColor];
    self.doneButton.backgroundColor=[[Utilities shareManager] backgroundColor];
    self.useTouchIDButton.backgroundColor=[[Utilities shareManager] backgroundColor];
    self.titleView.layer.shadowOffset = CGSizeMake(0, 5);
    self.titleView.layer.shadowRadius = 2;
    self.titleView.layer.shadowOpacity = 0.3;
    self.doneButton.layer.cornerRadius=5.0;
     self.useTouchIDButton.layer.cornerRadius=5.0;
    
    self.passcodeTextfield.keyboardType=UIKeyboardTypeNumberPad;
    self.conifrmPasscodeTextfield.keyboardType=UIKeyboardTypeNumberPad;
    self.passcodeTextfield.delegate=self;
    self.conifrmPasscodeTextfield.delegate=self;
    
    
  //  [self.passcodeTextfield becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)doneButtonAction:(id)sender {
    
  //  [[NSUserDefaults standardUserDefaults] setObject:@"1234" forKey:@"Passcode"];
    if([self.passcodeTextfield.text isEqualToString:self.conifrmPasscodeTextfield.text])
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.passcodeTextfield.text forKey:@"Passcode"];
        [self performSegueWithIdentifier:@"homesegue" sender:nil];
    }
    else
    {
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:APP_NAME message:@"Passcode does not match" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:okAction];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
        
    }
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)useTouhIDButtonAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"useTouchID"];
      [self performSegueWithIdentifier:@"homesegue" sender:nil];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
       return YES;
}
-(bool)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
     NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if(currentString.length==0)
    {
        return YES;
    }
    
    if(textField.text.length>3)
    {
        return NO;
    }

    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""] ;
    
    
    if([string isEqualToString:filtered]||[string isEqualToString:@" "])
        
        return YES;
    
   
    
    return YES;

    
}

@end
