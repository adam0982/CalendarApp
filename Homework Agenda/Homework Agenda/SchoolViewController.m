//
//  SchoolViewController.m
//  Homework Agenda
//
//  Created by Adam Serruys on 2/21/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implemenation file for the SchoolViewController.
 This class fills the view that allows the user to pick which schooled they are enrolled in.
 
 */


#import "SchoolViewController.h"
#import "DatabaseHelper.h"
#import "TeacherViewController.h"


@interface SchoolViewController ()
@property (nonatomic,strong) DatabaseHelper *dbHelper;

@end

@implementation SchoolViewController

// Method to prepare the view to go to the next view.
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Sending the selected school to the next view.
    if ([segue.identifier isEqualToString:@"schoolToTeacherView"]){
        if ([segue.destinationViewController isKindOfClass:[TeacherViewController class]]){
            TeacherViewController *tvc = (TeacherViewController *) segue.destinationViewController;
            tvc.school = self.chosenSchool;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.navigationItem setHidesBackButton:YES];

    // Initialize the schools array.  This will hold all the schools.
    self.schools = [[NSMutableArray alloc]init];
    
    // Initialize the DatabaseHelper.  This object will bring in all the data for this view.
    self.dbHelper = [[DatabaseHelper alloc]init];
    
    // Get string from server and process it
    [self processServerString];
    
    // Delegate methods for picker view.
    [self.schoolPickerView setDataSource:self];
    [self.schoolPickerView setDelegate:self];
    [self.schoolPickerView reloadAllComponents];
    
    self.schoolPickerViewContainer.hidden = YES;
   
}

// Method to pull JSON using DatabaseHelper class and process the JSON.
- (void)processServerString{
    
    NSMutableArray *tempSchoolArray = [[NSMutableArray alloc]init];

    // Use database helper to get JSON for the schools
    tempSchoolArray = [[self.dbHelper getAllSchoolsJSON] mutableCopy];
    
    // If there was a return from the database call.
    if (tempSchoolArray) {
        
        // If no JSON object present, show alert.
        if([tempSchoolArray[0] isKindOfClass:[NSString class]]){
            [self launchJSONFailAlert];
        }
        else{
            
            // For loop to go through all the objects in the JSON array.
            for (int i = 0; i<tempSchoolArray.count; i++) {
                
                // Initialize a school object
                School *s = [[School alloc]init];
                
                // Make a school object
                [s makeSchool:[[tempSchoolArray objectAtIndex:i] objectForKey:@"SchoolName"]
                           id:[[tempSchoolArray objectAtIndex:i] objectForKey:@"ID"]];
                
                // Add a school to the array for the picker view.
                [self.schools addObject:s];
                [self.schoolPickerView reloadAllComponents];
            }
        }
    }
    else{
        
        [self launchFailAlert];
        
    }
    
    
}

// Method to show an alert for when no schools are registered
-(void)launchJSONFailAlert{
    UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"No Schools!"
                                                        message:@"There are currently no schools registered with the iHapp system.  You can retry now or check back later."
                                                       delegate:self
                                              cancelButtonTitle:@"Retry"
                                              otherButtonTitles:nil];
    [failAlert show];
    
}

// Method to launch an alert for a network failure
-(void)launchFailAlert{
    
    UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error!"
                                                        message:@"Network connection could not be established. \n Make sure you are on WI-FI."
                                                       delegate:self
                                              cancelButtonTitle:@"Retry"
                                              otherButtonTitles:nil];
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
}

// Sets values to nothing when view is going to show.
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.schoolPickerViewContainer.hidden = YES;
    self.schoolDisplayer.text = @"";
    self.chosenSchool = nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Delegate method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
    
}

// Delegate method
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.schools.count;
}

// Method to populate picker view with schools in database.
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [self.schools[row] name];
}

// Method to handle selected row.
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    School *selectedSchool = [self.schools objectAtIndex:row];
    self.chosenSchool = selectedSchool;
    self.schoolDisplayer.text = [NSString stringWithFormat:@"You chose: %@ ",[self.chosenSchool name]];
}

// Method to show the school picker.
- (IBAction)schoolDisplayButton:(id)sender {
    self.schoolPickerViewContainer.hidden = NO;
    [self showSchoolPicker];
    School *selectedSchool = [self.schools objectAtIndex:0];
    self.chosenSchool = selectedSchool;
    self.schoolDisplayer.text = [NSString stringWithFormat:@"You chose: %@ ",[self.chosenSchool name]];
}

// Method to send trigger the segue to the next view
- (IBAction)schoolSubmit:(id)sender {
    if(self.chosenSchool){
        [self performSegueWithIdentifier:@"schoolToTeacherView" sender:self];
    }
    else{
        UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"No School Selected!"
                                                            message:@"Please select a school."
                                                           delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
        [failAlert show];
    }
}

// Method triggered by tap on screen to hide the picker view.
- (IBAction)hidePickerViewWithTap:(id)sender {
    [self hideSchoolPicker];
}

// Method to show the school picker.
- (void)showSchoolPicker{
    [UIView animateWithDuration:0.3 animations:^{
        self.schoolPickerViewContainer.frame = CGRectMake(165, 610, 440, 250);
        
    }];
    
}

// Method to hide the school picker
-(void)hideSchoolPicker{
    [UIView animateWithDuration:0.3 animations:^{
        self.schoolPickerViewContainer.frame = CGRectMake(165, 1100, 440, 250);
    }];
}

@end
