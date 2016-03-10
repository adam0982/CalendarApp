//
//  AgendaViewController.m
//  Homework Agenda
//
//  Created by Adam Serruys on 2/7/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implemenation file for the AgendaViewController.
 This class fills the view the agenda view of the app.
 
 */

#import "AgendaViewController.h"
#import "DatabaseHelper.h"
#import "HomeworkTableViewCell.h"
#import "HomeworkEntry.h"
#import "SchoolViewController.h"
#import "OptionMenuViewController.h"
#import "StudyTimeInputViewController.h"

@interface AgendaViewController () <TimeInputDelegate>
@property (nonatomic,strong) DatabaseHelper *dbHelper;
@property (nonatomic) CGPoint center;
@property (nonatomic) int chosenSubjectForTimeInput;
@end

@implementation AgendaViewController

// Method to prepare the view to go to the next view.
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Sending the selected school to the next view.
    if ([segue.identifier isEqualToString:@"agendaToSchoolView"]){
        if ([segue.destinationViewController isKindOfClass:[SchoolViewController class]]){
        }
    }
    // Sending a student, teacher, and school to the options menu view.
    if ([segue.identifier isEqualToString:@"agendaToOptionMenu"]){
        if ([segue.destinationViewController isKindOfClass:[OptionMenuViewController class]]){
            OptionMenuViewController *omvc = (OptionMenuViewController *) segue.destinationViewController;
            omvc.student = self.user;
            omvc.teacher = self.sessionTeacher;
            omvc.school = self.sessionSchool;
        }
    }
    // Sending a homework entry to the time input view.  Also set delegate for that view.
    if ([segue.identifier isEqualToString:@"agendaToStudyTime"]){
        if ([segue.destinationViewController isKindOfClass:[StudyTimeInputViewController class]]){
            StudyTimeInputViewController *stivc = (StudyTimeInputViewController *) segue.destinationViewController;
            stivc.chosenPosition = self.chosenSubjectForTimeInput;
            stivc.hEntry = self.subjectForTimeInput;
            stivc.delegate = self;
            
        }
    }
}

// Method to set up view.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hide back button so user has to sign out if they want to go back to the user sign in page.
    [self.navigationItem setHidesBackButton:YES];
    
    // Code for a logout button in the upper right hand corner of the screen.
    UIBarButtonItem *LogoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Logout"
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                    action:@selector(LogOut:)];
    
    //Code for a button to change the date of the assignments
    UIBarButtonItem *ChooseDateButton = [[UIBarButtonItem alloc] initWithTitle:@"Change Date"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(ChooseDate:)];
    self.navigationItem.leftBarButtonItem = ChooseDateButton;
    
    
    //Code for a button for the options menu.
    UIBarButtonItem *OptionMenuButton = [[UIBarButtonItem alloc] initWithTitle:@"Options"
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(LaunchOptionMenu:)];
    
    NSArray *rightBarButtons = [[NSArray alloc] initWithObjects:LogoutButton, OptionMenuButton, nil];
    
    self.navigationItem.rightBarButtonItems = rightBarButtons;
    
    NSString *barTitle = @"Agenda";
    self.navigationItem.title = barTitle;
    
    //Setting the teacher message box to be uneditable and the parent message box editable.
    [self.ParentMessage setEditable:YES];
    [self.TeacherMessage setEditable:NO];
    
    
    // Initialize the DatabaseHelper.  This object will bring in all the data for this view.
    self.dbHelper = [[DatabaseHelper alloc]init];
    
    // Initialize the homeworkEntries array.  This will hold all the entry objects.
    // Used for populating table view.
    self.homeworkAssignments = [[HomeworkAssignments alloc] init];
    
    // Update the UI
    [self updateUI];
    
    // Delegate methods.
    [self.HomeworkTableView setDataSource:self];
    [self.HomeworkTableView setDelegate:self];
    [self.ParentMessage setDelegate:self];
    [self.HomeworkTableView reloadData];
    
    // Hide the homework date picker
    self.hwDatePickerContainer.hidden = YES;
    
    // Create and register the left and right swipe to switch between homework entries.
    UISwipeGestureRecognizer *rightSwipeOnAgenda = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(rightSwipeEvent)];
    rightSwipeOnAgenda.direction = UISwipeGestureRecognizerDirectionRight;
    [rightSwipeOnAgenda setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:rightSwipeOnAgenda];
    
    UISwipeGestureRecognizer *leftSwipeOnAgenda = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(leftSwipeEvent)];
    leftSwipeOnAgenda.direction = UISwipeGestureRecognizerDirectionLeft;
    [leftSwipeOnAgenda setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:leftSwipeOnAgenda];
    
    // Setting the center CGPoint to the center of the view.  This used to shift the screen when the keyboard is shown.
    self.center = self.view.center;
    
}

// Method to move to one day before current view date.
-(void)rightSwipeEvent{
    
    // Grabbing the current date of the agenda
    NSDate* tempDate = self.dateOfHomework;
    
    // Using NSDateComponents to move the day before the current date of the agenda.
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setDay:-1];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* tomorrow = [calendar dateByAddingComponents:dateComponents toDate:tempDate options:0];
    self.dateOfHomework = tomorrow;
    
    // Update the views with the data of the new date.
    [self updateUI];
    [self.HomeworkTableView reloadData];
    
}

// Method to move to one day after current view date.
-(void)leftSwipeEvent{
    
    // Grabbing the current date of the agenda
    NSDate* tempDate = self.dateOfHomework;
    
    // Using NSDateComponents to move the day before the current date of the agenda.
    NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
    [dateComponents setDay:1];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDate* tomorrow = [calendar dateByAddingComponents:dateComponents toDate:tempDate options:0];
    self.dateOfHomework = tomorrow;
    
    // Update the views with the data of the new date.
    [self updateUI];
    [self.HomeworkTableView reloadData];
}

// Method to update all the views.
-(void)updateViews{
    
    // Clear the homeworkAssingments array so views will not show old data.
    [self.homeworkAssignments clear];
    
    // Clear the signature pad of any signature.
    [self.signaturePad clearThePad];
    
    // Clear the parent and teacher notes boxes.
    [self clearMessageBoxes];
    
    // Open the signature pad to editing.
    self.signaturePad.userInteractionEnabled = YES;

    NSMutableArray *tempAgendaArray = [[NSMutableArray alloc]init];
    
    // Use the databaseHelper to get the homework assignments and notes per chosen student.
    tempAgendaArray = [[self.dbHelper getAgendaJSON:[self.user studentID] date:[self getDateAsStringForAgendaJSON]] mutableCopy];

    // If there was a return from the database call.
    if (tempAgendaArray) {
        
        // If the JSON does not pull a day's agenda.
        if(tempAgendaArray.count <= 1){
            
            // Populate the agenda views with empty data.
            [self makeEmptyAgenda];
        }
        else{
            
            // Grab the values from the JSON for the appropriate keys and set them to the variables of this class.
            
            // Set parent notes.
            self.homeworkAssignments.parentMessageText = [tempAgendaArray valueForKey:@"ParentNotes"];
            
            // Set the teacher notes with both the generic and specific notes.
            self.homeworkAssignments.teacherMessageText = [NSString stringWithFormat:@"%@  %@",
                                                           [tempAgendaArray valueForKey:@"TeacherGeneralNotes"],
                                                           [tempAgendaArray valueForKey:@"TeacherSpecificNotes"]];
            
            // Set the assignment id.
            self.homeworkAssignments.assignmentID = [tempAgendaArray valueForKey:@"AssignmentID"];
            
            // Setting the boolean values for submitted from the JSON data.
            BOOL tempSubmitted;
            
            NSString *tempSubmittedString = [tempAgendaArray valueForKey:@"Signed"];
            
            tempSubmitted = [tempAgendaArray valueForKey:@"Signed"];
            
            if ([tempSubmittedString isEqualToString:@"1"]) {
                tempSubmitted = YES;
            }
            else{
                tempSubmitted = NO;
            }
            
            self.homeworkAssignments.isSubmitted = tempSubmitted;
            
            // Initiate array for assignment data.
            NSMutableArray *tempAssignmentArray = [[NSMutableArray alloc]init];
            
            // Setting the assignment array to the subject assignments array.
            tempAssignmentArray = [tempAgendaArray valueForKey:@"SubjectAssignments"];
            
            // For loop to go through all the objects in the JSON array.
            for (int i = 0; i<tempAssignmentArray.count; i++) {
                
                // Initiate a homework entry object
                HomeworkEntry *hW = [[HomeworkEntry alloc] init];
                
                // Make a homework entry.
                [hW makeEntry:[tempAssignmentArray[i] objectForKey:@"Subject"]
                   assignment:[tempAssignmentArray[i] objectForKey:@"Description"]
                      duedate:[self reformatDateStringFromWebService:[tempAssignmentArray[i] objectForKey:@"DueDate"]]
                       isDone:[tempAssignmentArray[i] objectForKey:@"IsDone"]
                    subjectID:[tempAssignmentArray[i] objectForKey:@"SubAssignID"]
       timeSpentOnThisSubject:[tempAssignmentArray[i] objectForKey:@"TimeSpent"]];
                
                // Add the homework entry to homework assignment array for the table view.
                [self.homeworkAssignments addHomeworkEntry:hW];
                
            }
            
            [self setMessageBoxFontsAndText];
            
            // Setting bool for to signify if there are no homeworks.  It is to stop a homework submission of an empty assignment
            self.homeworkAssignments.isEmpty = NO;
            
            // If an agenda has been signed for the day, the signature pad is disabled.
            if (self.homeworkAssignments.isSubmitted == YES) {
                
                self.signaturePad.userInteractionEnabled = NO;
                self.SubmitButtonLabel.text = @"Already Submitted";
                self.SubmitButton.userInteractionEnabled = NO;
                [self.SubmitButtonLabel setFont:[self.SubmitButtonLabel.font fontWithSize:25]];
                
            }
            else{
                self.SubmitButton.userInteractionEnabled = YES;
                self.SubmitButtonLabel.text = @"Submit";
                [self.SubmitButtonLabel setFont:[self.SubmitButtonLabel.font fontWithSize:28]];

            }
    
        }
    }
    else{
        
        [self launchFailAlert];
        
    }

    
}

// Method to make an empty homework agenda.  This is just to fill the views.
-(void) makeEmptyAgenda{
    self.homeworkAssignments.parentMessageText = @"";
    self.homeworkAssignments.teacherMessageText = @"";
    self.homeworkAssignments.assignmentID = @"-1";
    self.homeworkAssignments.isSubmitted = NO;
    self.homeworkAssignments.isEmpty = YES;
    
    HomeworkEntry *hW = [[HomeworkEntry alloc] init];
    [hW makeEntry:@"N/A" assignment:@"No homework assigned for today." duedate:@"N/A" isDone:@"0" subjectID:@"-1" timeSpentOnThisSubject:@"0.0"];
    [self.homeworkAssignments addHomeworkEntry:hW];
    self.SubmitButton.userInteractionEnabled = YES;
    self.SubmitButtonLabel.text = @"Submit";
    [self.SubmitButtonLabel setFont:[self.SubmitButtonLabel.font fontWithSize:28]];
    [self setMessageBoxFontsAndText];

}

#pragma UITableViewDelegate Methods

// Delegate Method
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

// Delegate Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.homeworkAssignments getCount];
}

// Method to populate each row of the table view from the array data.
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *hSubject = [[self.homeworkAssignments getHomeworkEntryAt:(int)indexPath.row] subject];
    NSString *hAssignement = [[self.homeworkAssignments getHomeworkEntryAt:(int)indexPath.row] assignment];
    NSString *hDueDate = [[self.homeworkAssignments getHomeworkEntryAt:(int)indexPath.row] dueDate];
    
    HomeworkTableViewCell *hCell = (HomeworkTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HomeworkTableRow" forIndexPath:indexPath];
    
    HomeworkEntry *hEntry = [self.homeworkAssignments getHomeworkEntryAt:(int) indexPath.row];
    
    // Filling the rows.
    [hCell PopulateRow:hSubject homework:hAssignement duedate:hDueDate hwEntry:hEntry];
    
    hCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return hCell;
    
}

// Delegate method: Method to make background of row clear.  For UI use.
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setBackgroundColor:[UIColor clearColor]];
}

// Delegate method: Method to go to the input time view.
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // If the agenda is empty, you cannot input time.
    if([[self.homeworkAssignments assignmentID] isEqualToString:@"-1"]){
        [self launchNoHomeworkForTimeInputAlert];
    }
    else{
        self.subjectForTimeInput = [self.homeworkAssignments getHomeworkEntryAt:(int) indexPath.row];
        self.chosenSubjectForTimeInput = (int)indexPath.row;
        [self performSegueWithIdentifier:@"agendaToStudyTime" sender:self];
    }
}


#pragma UITextViewDelegate Methods

// Delegate method for parent notes message box.
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    return YES;
}

// Delegate method for parent notes message box.
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.center = CGPointMake(self.center.x,230);
    }];
    
}

// Delegate method for parent notes message box.
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}

// Delegate method for parent notes message box.
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    self.homeworkAssignments.parentMessageText = [self.ParentMessage text];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.center = CGPointMake(self.center.x,self.center.y);
    }];
    [self.view endEditing:YES];
}

// Delegate method for parent notes message box.
// Keyboard will be hidden and the view will be moved down when the done button is pressed.
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if([text isEqualToString:@"\n"]){
        
        self.homeworkAssignments.parentMessageText = [self.ParentMessage text];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.view.center = CGPointMake(self.center.x,self.center.y);
        }];
        [self.view endEditing:YES];
        return NO;
        
    }
    return YES;
}


#pragma Helper Methods

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

// Method to update the UI.
-(void) updateUI{
    self.StudentNameLabel.text = [NSString stringWithFormat:@"Student Name: %@",[self.user name]];
    self.DateLabel.text = [NSString stringWithFormat:@"Date: %@",[self getDateAsString]];
    [self updateViews];
}


// Method to handle the click on the the logout button.
// This will log a person out.
-(void)LogOut:(id) sender{
    
    // Setting up and showing a alert box to check if the user wanted to logout
    NSString *clickmessage = @"Are you sure you want to logout";
    UIAlertView *logoutPrompt = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                                   message:clickmessage
                                                                  delegate:self
                                                         cancelButtonTitle:@"No"
                                                         otherButtonTitles:@"Yes", nil];
    [logoutPrompt setAlertViewStyle:UIAlertViewStyleDefault];
    
    
    [logoutPrompt show];
   
}

// Method to handle either submitting a password or a cancel on the passwordPrompt alert box.
-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    // Grab the button that was chosen in the alert box.
    NSString *buttonClicked = [alertView buttonTitleAtIndex:buttonIndex];
    // Checking to see if the button that was chosen was the submit button.
    if([buttonClicked isEqualToString:@"Yes"]){
        
        //*************************************************************************************
        // Implemented by Andrew Browning
        // Erasing user defaults from system. (Andrew Browning)
        NSUserDefaults *hwAgendaDefaults = [NSUserDefaults standardUserDefaults];
        NSString *loginStatus = @"NO";
        
        [hwAgendaDefaults setObject:@"" forKey:@"hwAgendaUsername"];
        [hwAgendaDefaults setObject:@"" forKey:@"hwAgendaPassword"];
        [hwAgendaDefaults setObject:loginStatus forKey:@"hwAgendaLoginStatus"];
        [hwAgendaDefaults setObject:@"" forKey:@"hwAgendaSchool"];
        [hwAgendaDefaults setObject:@"" forKey:@"hwAgendaTeacher"];
        [hwAgendaDefaults setObject:@"" forKey:@"hwAgendaSchoolID"];
        [hwAgendaDefaults setObject:@"" forKey:@"hwAgendaTeacherID"];
        [hwAgendaDefaults setObject:@"" forKey:@"hwAgendaUserID"];
        
        [hwAgendaDefaults setObject:@"" forKey:@"hwAgendaUserFirstName"];
        [hwAgendaDefaults setObject:@"" forKey:@"hwAgendaUserLastName"];
        [hwAgendaDefaults setObject:@"" forKey:@"hhwAgendaStudentID"];
        
        
        [hwAgendaDefaults synchronize];
        
        [self performSegueWithIdentifier:@"agendaToSchoolView" sender:self];
        //*************************************************************************************
        
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }
    
    //If a homework is submitted
    if([buttonClicked isEqualToString:@"Submit Homework"]){
        
        // Get the base 64 encoded string of the signature.
        NSString * signaturePNG = [self getSignaturePNG];
        
        // Bool to store if submit was good or not.
        BOOL submitGood;
        
        // Use databaseHelper to submit homework
        submitGood = [self.dbHelper submitUserData:[self.user studentID]
                                      assignmentID:[self.homeworkAssignments assignmentID]
                                   signatureString:signaturePNG
                                    submissionDate:[self getCurrentDateAsStringForSubmittingData]
                                        parentNote:[self.homeworkAssignments parentMessageText]
                                      homeworkJSON:[self.homeworkAssignments getHomeworkJSON]];
        
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        
        // If-else to show that the submit is good or bad.
        if (submitGood) {
            [self submitGoodAlert];
        }
        else{
            [self submitBadAlert];
        }
    }
    
    // If the user wants to retry pulling the data.
    if([buttonClicked isEqualToString:@"Retry"]){
        [self updateUI];
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }

    
}

// Method to launch an alert for a successful homework submit
-(void) submitGoodAlert{
    UIAlertView *submitSuccessAlert = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                             message:@"Your homework submission was successful."
                                                            delegate:self
                                                   cancelButtonTitle:@"Okay"
                                                   otherButtonTitles:nil];
    [submitSuccessAlert show];
    
}

// Method to launch an alert for a failed homework submit
-(void) submitBadAlert{
    UIAlertView *submitFailAlert = [[UIAlertView alloc] initWithTitle:@"Fail!"
                                                             message:@"Your homework submission was not successful."
                                                            delegate:self
                                                   cancelButtonTitle:@"Okay"
                                                   otherButtonTitles:nil];
    [submitFailAlert show];
    
}

// Method to launch an alert for an attempt to imput time for an empty assignment.
-(void)launchNoHomeworkForTimeInputAlert{
    UIAlertView *failInputAlert = [[UIAlertView alloc] initWithTitle:@"Cannot Enter Time"
                                                        message:@"You cannot enter the time when there are no assignments assigned."
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
    [failInputAlert show];
}

// Method to launch an alert for a network failure.
-(void)launchFailAlert{
    
    UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"Connection Error!"
                                                        message:@"Network connection could not be established. \n Make sure you are on WI-FI."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Retry", nil];
    [failAlert show];
    
}

// Method to segue to the options menu.
-(void)LaunchOptionMenu:(id) sender{
    [self performSegueWithIdentifier:@"agendaToOptionMenu" sender:self];
}

// Method to show the date picker to change homework date.
-(void)ChooseDate:(id) sender{
    
    self.hwDatePickerContainer.hidden = NO;
    [self showHWAgendaDatePicker];
}


// Method to change the homework agenda fields by picking a date from a picker view.
- (IBAction)changeHomeworkToThisDate:(UIButton *)sender {
    
    [self hideHWAgendaDatePicker];
    self.dateOfHomework = self.hwDatePicker.date;
    [self updateUI];
    [self.HomeworkTableView reloadData];

}

// Method to send user data to database
- (IBAction)submitUserData:(UIButton *)sender {
    
    // If there are no homeworks to submit
    if (self.homeworkAssignments.isEmpty) {
            NSString *submitDeniedMessage = [NSString stringWithFormat:@"You are not allowed to submit an assignment when there are none to submit."];
        UIAlertView *notAllowedToSubmitPrompt = [[UIAlertView alloc] initWithTitle:@"Cannot Submit"
                                                               message:submitDeniedMessage
                                     
                                                              delegate:self
                                                     cancelButtonTitle:@"Cancel"
                                                     otherButtonTitles:nil];
        [notAllowedToSubmitPrompt show];
    }
    // Launch a message to tell the user that the submission is final.
    else{
        NSString *submitHomeworkMessage = [NSString stringWithFormat:@"Are you sure you want to submit your response for this homework?  The submission will be final."];
        UIAlertView *submitPrompt = [[UIAlertView alloc] initWithTitle:@"Homework Submission"
                                                                  message:submitHomeworkMessage
                                        
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        otherButtonTitles:@"Submit Homework", nil];
        [submitPrompt show];
    }
}

// Method to convert the image in the signature view to a base 64 encoded string.
-(NSString *)getSignaturePNG{
    
    // Set up to grab the image from the signature pad
    UIGraphicsBeginImageContext(self.signaturePad.frame.size);
    [self.signaturePad.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    // Grab the image from the signature image view.
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Make a NSData object from the view image set above.
    NSData *data = UIImagePNGRepresentation(viewImage);
    
    // convert the NSData object to a base 64 encoded string.
    NSString *encodedPNG = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return encodedPNG;
}


// Method to show the homework agenda date picker view for changing daily assignments.
- (void)showHWAgendaDatePicker{
    [UIView animateWithDuration:0.3 animations:^{
        self.hwDatePickerContainer.frame = CGRectMake(224, 150, 320, 236);
    }];
    
}

// Method to hide the homework agenda date picker view for changing daily assignments.
-(void)hideHWAgendaDatePicker{
    [UIView animateWithDuration:0.3 animations:^{
        self.hwDatePickerContainer.frame = CGRectMake(224, 1100, 320, 236);
    }];
}

// Method to get today's date.
-(NSString*)getDateAsString{
    
    NSDate *date = self.dateOfHomework;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

// Method to get today's date for pulling agenda JSON.
-(NSString*)getDateAsStringForAgendaJSON{
    
    NSDate *date = self.dateOfHomework;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

// Method to get today's date for pulling agenda JSON.
-(NSString*)getCurrentDateAsStringForSubmittingData{
    
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *strDate = [dateFormatter stringFromDate:date];
    
    return strDate;
}

// Method to reformat a date to from "YYYY-MM-DD" to "MM-DD-YYYY"
-(NSString*)reformatDateStringFromWebService:(NSString *)date{
    NSArray *dateParts = [date componentsSeparatedByString:@"-"];
    NSLog(@"size of array: %lu",(unsigned long)dateParts.count);
    
    NSString *reformattedString;
    
    if (dateParts.count != 3) {
        reformattedString = @"N/A";
    }
    else {
        reformattedString = [NSString stringWithFormat:@"%@/%@/%@",dateParts[1],dateParts[2],dateParts[0]];
    }
    return reformattedString;
    
}

// Method to hide the keyboard.
-(void)hideKeyboard{
    [self.view endEditing:YES];
}

// Method to set the font and text of both the parent and teacher note message boxes.
// This sets them depending on the data from the JSON pull.
-(void)setMessageBoxFontsAndText{
    UIFont *messageBoxFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    
    [self clearMessageBoxes];
    
    
    if ([[self.homeworkAssignments teacherMessageText] isEqualToString:@""]) {
        
        [self.TeacherMessage setText:@"No message from the teacher."];
        [self.TeacherMessage setFont:messageBoxFont];
    }
    else{
        
        [self.TeacherMessage setText:[self.homeworkAssignments teacherMessageText]];
        [self.TeacherMessage setFont:messageBoxFont];

    }
    
    if ([self.homeworkAssignments parentMessageText] == nil) {
        [self.ParentMessage setText:@""];
        [self.ParentMessage setFont:messageBoxFont];
    }
    else{
        [self.ParentMessage setText:[self.homeworkAssignments parentMessageText]];
        [self.ParentMessage setFont:messageBoxFont];

    }

    
}

// Set the message box texts to an empty string.
-(void)clearMessageBoxes{
    [self.ParentMessage setText:@""];
    [self.TeacherMessage setText:@""];
}

// Custom delegate method.  It sets the times for a certain homewok entry.
-(void) setTimeOfSubject:(StudyTimeInputViewController*) sender time:(float) hTime position:(int) position{
    
    [self.homeworkAssignments getHomeworkEntryAt:position].hoursSpentStudying = hTime;

    [self.HomeworkTableView reloadData];

    [self submitTimeAlert];
    
}

// Method to launch an alert for a successful time submit
-(void) submitTimeAlert{
    UIAlertView *submitTimeAlert = [[UIAlertView alloc] initWithTitle:@"Time Stored"
                                                                 message:@"You have successfully stored the time."
                                                                delegate:self
                                                       cancelButtonTitle:@"Okay"
                                                       otherButtonTitles:nil];
    [submitTimeAlert show];
    
}

@end
