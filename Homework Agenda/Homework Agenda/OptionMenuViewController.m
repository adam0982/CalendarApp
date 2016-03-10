//
//  OptionMenuViewController.m
//  Homework Agenda
//
//  Created by Adam Serruys on 3/18/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

#import "OptionMenuViewController.h"
#import "DatabaseHelper.h"

@interface OptionMenuViewController ()

@property (nonatomic,strong) DatabaseHelper *dbHelper;


@end

@implementation OptionMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.dbHelper = [[DatabaseHelper alloc] init];
    
    // Setting the navigation bar title to the string "Options"
    NSString *barTitle = @"Options";
    
    self.navigationItem.title = barTitle;
    
    // Making the submit button on the navigation bar.
  /*  UIBarButtonItem *SubmitButton = [[UIBarButtonItem alloc] initWithTitle:@"Submit"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(changePassword:)];
    
    self.navigationItem.rightBarButtonItem = SubmitButton;*/
    
    // Hide keyboard with tap on background of view
    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:backgroundTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)changePassword:(id) sender{
    // Setting up and showing an alert box to prompt the user for their password.
    NSString *clickmessage = @"Are you sure you want to change your password";
    UIAlertView *changePasswordPrompt = [[UIAlertView alloc] initWithTitle:@"Change Password"
                                                                   message:clickmessage
                                                                  delegate:self
                                                         cancelButtonTitle:@"No"
                                                         otherButtonTitles:@"Yes", nil];
    [changePasswordPrompt setAlertViewStyle:UIAlertViewStyleDefault];
    
    
    [changePasswordPrompt show];
    
    
}

// Method to handle either submitting a password or a cancel on the passwordPrompt alert box.
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Grab the button that was chosen in the alert box.
    NSString *buttonClicked = [alertView buttonTitleAtIndex:buttonIndex];
    // Checking to see if the button that was chosen was the submit button.
    if([buttonClicked isEqualToString:@"Yes"]){
        // If it was the submit button, get the user name from the button and
        // the text from the field in the password alert box.  Then send them
        // to the checkPassword method in this class.
        NSString *userID = [self.student userID];
        NSString *oldPassword = self.textFieldForOldPassword.text;
        NSString *newPassword = self.textFieldForNewPassword.text;
        NSString *confirmPassword = self.textFieldForConfirmPassword.text;
        [self submitPasswordChange:userID oldPassword:oldPassword newPassword:newPassword confirmPassword:confirmPassword];
 
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
        

}

// Method to submit the password change.  A userID, existing password, the new password, and the confirmed password.
-(void)submitPasswordChange:(NSString*)userID oldPassword:(NSString*)oldPassword newPassword:(NSString*)newPassword confirmPassword:(NSString*)confirmPassword{
    
    if([self.dbHelper changePassword:userID oldPassword:oldPassword newPassword:newPassword confirmPassword:confirmPassword]){
        UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Password Change Success!"
                                                            message:@"Your password was succesfully changed."
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
        [successAlert show];
        
    }
    else{
        
        UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Password Change Failed!"
                                                            message:@"Password changed failed.  Check your login info."
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
        [failAlert show];
        
    }
    
}

// Method to hide the keyboard with a background tap.
-(void)hideKeyboard{
    [self.view endEditing:YES];
}

// Method for capturing the contact us button press.
- (IBAction)ChangePasswordSubmitPressed:(UIButton *)sender {
    [self changePassword:sender];
}


- (IBAction)contactUsButtonPressed:(UIButton *)sender {
    
    // Opens up to contact us
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ih-app.com/#contact"]];
}
@end
