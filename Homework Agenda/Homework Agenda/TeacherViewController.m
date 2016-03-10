//
//  TeacherViewController.m
//  Homework Agenda
//
//  Created by Adam Serruys on 2/14/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implemenation file for the TeacherViewController.
 This class fills the view that allows the user to pick which teacher they are enrolled in.
 
 */
#import "TeacherViewController.h"
#import "DatabaseHelper.h"
#import "UserCellViewController.h"

@interface TeacherViewController ()

@property (nonatomic,strong) DatabaseHelper *dbHelper;

@end

@implementation TeacherViewController

// Method to prepare the view to go to the next view.
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Sending the selected teacher and school to the next view.
    if ([segue.identifier isEqualToString:@"teacherToGridView"]){
        if ([segue.destinationViewController isKindOfClass:[UserCellViewController class]]){
            UserCellViewController *uvc = (UserCellViewController *) segue.destinationViewController;
            uvc.teacher = self.chosenTeacher;
            uvc.school = self.school;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting the welcome label and picture for the view.
    self.welcomeLabel.text = [NSString stringWithFormat:@"WELCOME TO %@",[[self.school name] uppercaseString]];
    
    if (![[self.school schoolID] isEqualToString:@"1"]) {
        self.schoolLogo.image = nil;
    }
    
    // Initialize the schools array.  This will hold all the schools.
    self.teachers = [[NSMutableArray alloc]init];
    
    // Initialize the DatabaseHelper.  This object will bring in all the data for this view.
    self.dbHelper = [[DatabaseHelper alloc]init];
    
    // Method to process the string that is returned from the database.
    [self processServerString];
    
    // Delegate methods for picker view.
    [self.teacherPickerView setDataSource:self];
    [self.teacherPickerView setDelegate:self];
    [self.teacherPickerView reloadAllComponents];
    
    self.teacherPickerViewContainer.hidden = YES;
    
    //*************************************************************************************
    // Implemented by Andrew Browning
    // Saviing the school for this session in the standard user defaults (Andrew Browning)
    NSUserDefaults *hwAgendaDefaults = [NSUserDefaults standardUserDefaults];
    [hwAgendaDefaults setObject:[self.school name] forKey:@"hwAgendaSchool"];
    [hwAgendaDefaults setObject:[self.school schoolID] forKey:@"hwAgendaSchoolID"];
    [hwAgendaDefaults synchronize];
    //*************************************************************************************

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.teacherPickerViewContainer.hidden = YES;
    self.teacherDisplayer.text = @"";
    self.chosenTeacher = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Method to pull JSON using DatabaseHelper class and process the JSON.
- (void)processServerString{
    
    NSMutableArray *tempTeacherArray = [[NSMutableArray alloc]init];
    
    // Use the databaseHelper to get the teachers per chosen school.
    tempTeacherArray = [[self.dbHelper getTeachersBySchoolJSON:[self.school schoolID]] mutableCopy];
    
    // If there was a return from the database call.
    if (tempTeacherArray) {
        
        // If no JSON object present, show alert.
        if([tempTeacherArray[0] isKindOfClass:[NSString class]]){
            
            [self launchJSONFailAlert];
        }
        else{
            // For loop to go through all the objects in the JSON array.
            for (int i = 0; i<tempTeacherArray.count; i++) {
                
                // Initiate a new teacherUser
                teacherUser *t = [[teacherUser alloc] init];
                // Make a new teacher.
                [t makeTeacherUser:[[tempTeacherArray objectAtIndex:i] objectForKey:@"FirstName"]
                          lastName:[[tempTeacherArray objectAtIndex:i] objectForKey:@"LastName"]
                                id:[[tempTeacherArray objectAtIndex:i] objectForKey:@"TeacherID"]];
                
                // Add the teacher to the teacher array for the picker view.
                [self.teachers addObject:t];
                NSLog(@"teacher name:%@ teacher id:%@",[t name],[t userID]);
                }
    
        }
    }
    else{
        [self launchFailAlert];
    }
    
    
}

// Method to show an alert for when no teachers are enrolled.
-(void)launchJSONFailAlert{
    UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"No Teachers!"
                                                        message:@"There are currently no teachers enrolled in the iHapp system with the school that you chose."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Choose another school",@"Retry",nil];
    [failAlert show];
    
}

// Method to show an alert for a failed network connection.
-(void)launchFailAlert{
    
    UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error!"
                                                        message:@"Network connection could not be established. \n Make sure you are on WI-FI."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Retry",nil];
    [failAlert show];
    
}

// Method to handle either retry fetching schools or exiting app.
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    // Grab the button that was chosen in the alert box.
    NSString *buttonClicked = [alertView buttonTitleAtIndex:buttonIndex];
    
    // Checking to see if the button that was chosen was the retry button.
    if([buttonClicked isEqualToString:@"Retry"]){
        [self processServerString];
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    // Checking to see if the button is for choosing another school
    if ([buttonClicked isEqualToString:@"Choose another school"]) {
        [self.navigationController popViewControllerAnimated:YES];
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];

    }
}

// Delegate Method.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
    
}

// Delegate Method.
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.teachers.count;
}

// Method to populate picker view with teachers in database.  Using NSAttributedString version to change color of text.
- (NSAttributedString*)pickerView:(UIPickerView*)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString* tempName = [self.teachers[row] name];
    return [[NSAttributedString alloc] initWithString:tempName
                                           attributes:@{
                                                        NSForegroundColorAttributeName:[UIColor whiteColor]
                                                        }];
}

// Method to handle selected row.
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    teacherUser *selectedTeacher = [self.teachers objectAtIndex:row];
    self.chosenTeacher = selectedTeacher;
    self.teacherDisplayer.text = [NSString stringWithFormat:@"You chose: %@",[self.chosenTeacher name]];

}

// Method to move the teacher to the next view.
- (IBAction)teacherSubmit:(id)sender {
    if (self.chosenTeacher) {
        [self performSegueWithIdentifier:@"teacherToGridView" sender:self];
    }
    else{
        UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"No Teacher Selected!"
                                                            message:@"Please select a teacher."
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
        [failAlert show];
        
    }
}

// Hide the picker view with background tap.
- (IBAction)hideTeacherPickerTap:(id)sender {
    [self hideTeacherPicker];
}

// Method to show the picker view from button push
- (IBAction)pickTeacherFromPicker:(id)sender {
    self.teacherPickerViewContainer.hidden = NO;
    [self showTeacherPicker];
    teacherUser *selectedTeacher = [self.teachers objectAtIndex:0];
    self.chosenTeacher = selectedTeacher;
    self.teacherDisplayer.text = [NSString stringWithFormat:@"You chose: %@",[self.chosenTeacher name]];
}

// method to show the picker view.
- (void)showTeacherPicker{
    [UIView animateWithDuration:0.3 animations:^{
        self.teacherPickerViewContainer.frame = CGRectMake(160, 810, 450, 180);
    }];
}

// method to hide the picker view.
-(void)hideTeacherPicker{
    [UIView animateWithDuration:0.3 animations:^{
        self.teacherPickerViewContainer.frame = CGRectMake(160, 1100, 450, 180);
    }];
}

@end
