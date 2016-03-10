//
//  StudyTimeInputViewController.m
//  Homework Agenda
//
//  Created by Adam Serruys on 4/8/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

#import "StudyTimeInputViewController.h"

@interface StudyTimeInputViewController ()

@end

@implementation StudyTimeInputViewController

@synthesize delegate = _delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set message of a label.
    NSString *message = [NSString stringWithFormat:@"How long did you spend on your %@ homework?", [self.hEntry subject] ];
    self.messagePrompt.text = message;
    
    // Set the delegate
    self.timeInputField.delegate = self;
    
    // Hide keyboard with tap on background of view
    UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.view addGestureRecognizer:backgroundTap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Method to allow only numbers and a decimal point to be input.
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSCharacterSet *validCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
    
    NSString *newTextFieldValue = [[textField text] stringByReplacingCharactersInRange:range
                                                                   withString:string];
    newTextFieldValue = [[newTextFieldValue componentsSeparatedByCharactersInSet:validCharSet] componentsJoinedByString:@""];
    textField.text = newTextFieldValue;
    return NO;
}

// Method to hide the keyboard when the done button is pressed.
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideKeyboard];
    return NO;
}

// Method to store time in a homeentry object.
- (IBAction)submitTime:(UIButton *)sender {
    
    // Show confirmation message.
    NSString *clickmessage = [NSString stringWithFormat:@"Are you sure you spent %@ minutes on your %@ homework?", [self.timeInputField text], [self.hEntry subject]];
    UIAlertView *timesubmitPrompt = [[UIAlertView alloc] initWithTitle:@"Submit Time"
                                                           message:clickmessage
                                                          delegate:self
                                                 cancelButtonTitle:@"No"
                                                 otherButtonTitles:@"Yes", nil];
    [timesubmitPrompt setAlertViewStyle:UIAlertViewStyleDefault];
    
    [timesubmitPrompt show];
    
}

// Method to show a confirmation message to user.
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // Grab the button that was chosen in the alert box.
    NSString *buttonClicked = [alertView buttonTitleAtIndex:buttonIndex];
    // Checking to see if the button that was chosen was the yes button.
    if([buttonClicked isEqualToString:@"Yes"]){
        
        // Delegate method to pass time back to agenda view.
        [self.delegate setTimeOfSubject:self time:[[self.timeInputField text] floatValue] position:self.chosenPosition];
        
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
}

// Method to hide the keyboard.
-(void)hideKeyboard{
    [self.view endEditing:YES];
}
@end
