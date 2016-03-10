//
//  UserCollectionViewCell.m
//  Homework Agenda
//
//  Created by Adam Serruys on 2/12/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implementation file for the username cell in the user grid view.
 It has three label properties to represent a homework subject, homework assignment description,
 and a homework due date.
 
 */

#import "UserCollectionViewCell.h"
#import "DatabaseHelper.h"

@implementation UserCollectionViewCell

@synthesize delegate = _delegate;

// Method to set the title of the button in this view.
-(void)PopulateCell:(studentUser *)user{
    self.user = [[studentUser alloc]init];
    self.user = user;
    [self.UserCellButton setTitle:[user name] forState:UIControlStateNormal];
}


// Method to handle a click on the button.
- (IBAction)clickedOnCellButton:(id)sender {
    // Setting up and showing a alert box to prompt the user for their password.
    NSString *clickmessage = [NSString stringWithFormat:@"Hello %@!  Please enter your password",self.UserCellButton.titleLabel.text];
    UIAlertView *passwordPrompt = [[UIAlertView alloc] initWithTitle:@"Password!"
        message:clickmessage

     delegate:self
     cancelButtonTitle:@"Cancel"
     otherButtonTitles:@"Submit", @"Forgot Password", nil];
    passwordPrompt.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [passwordPrompt show];
    
}

// Method to handle either submitting a password or a cancel on the passwordPrompt alert box.
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Grab the button that was chosen in the alert box.
    NSString *buttonClicked = [alertView buttonTitleAtIndex:buttonIndex];
    // Checking to see if the button that was chosen was the submit button.
    if([buttonClicked isEqualToString:@"Submit"]){
        
        // If it was the submit button, get the user name from the button and
        // the text from the field in the password alert box.  Then send them
        // to the checkPassword method in this class.
        NSString *userName = [self.user userName];
        NSString *password = [alertView textFieldAtIndex:0].text;
        [self checkPassword:userName password:password];
        
        NSLog(@"Okay clicked %@ %@",userName,password);
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    if ([buttonClicked isEqualToString:@"Forgot Password"]) {
        
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        [self.delegate resetConfirmedSuccessful:self user:self.user];
        
    }
    
}

// Method to check if a correct password was entered.
-(void)checkPassword:(NSString*) username password:(NSString*)password{
    // Intialize a DatabaseHelper object.
    DatabaseHelper *dbHelper = [[DatabaseHelper alloc]init];
    // Send the username and password to the DatabaseHelper object.  It will handle the database checks.
    if ([dbHelper userLogin:username password:password]) {
        
        //*************************************************************************************
        // Implemented by Andrew Browning
        
        // Saving the username, password, and login status for this session in the standard user defaults
        NSUserDefaults *hwAgendaDefaults = [NSUserDefaults standardUserDefaults];
        NSString *loginStatus = @"YES";
        
        [hwAgendaDefaults setObject:username forKey:@"hwAgendaUsername"];
        [hwAgendaDefaults setObject:password forKey:@"hwAgendaPassword"];
        [hwAgendaDefaults setObject:loginStatus forKey:@"hwAgendaLoginStatus"];
        [hwAgendaDefaults setObject:[self.user userID] forKey:@"hwAgendaUserID"];
        [hwAgendaDefaults setObject:[self.user firstName] forKey:@"hwAgendaUserFirstName"];
        [hwAgendaDefaults setObject:[self.user lastName] forKey:@"hwAgendaUserLastName"];
        [hwAgendaDefaults setObject:[self.user studentID] forKey:@"hwAgendaStudentID"];


        
        [hwAgendaDefaults synchronize];
       
        //*************************************************************************************
        
        // If the login is accepted, the loginConfirmedSuccessful method is called in the delegate.
        // This allows the parent view to perform a segue to the next view.
        [self.delegate loginConfirmedSuccessful:self user:self.user];
        NSLog(@"successs");
    }
    else{
        // Show an alertbox if the login fails.
        UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Login Failed!"
                                                            message:@"You do not have access.  Check your login info."
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
        [failAlert show];
    }
}

@end
