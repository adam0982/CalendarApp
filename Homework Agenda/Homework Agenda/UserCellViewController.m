//
//  UserCellViewController.m
//  Homework Agenda
//
//  Created by Adam Serruys on 2/12/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implementation file for the UserCellViewController.
 This controller is for the UserCell Grid View.  It displays all the users enrolled with
 a specific teacher.  This is for logging in.
 
 */

#import "AgendaViewController.h"
#import "UserCellViewController.h"
#import "UserCollectionViewCell.h"
#import "DatabaseHelper.h"
#import "ResetPasswordViewController.h"

@interface UserCellViewController () <CustomCellDelegate>
@property (strong,nonatomic) studentUser *userSelected;
@property (strong,nonatomic) DatabaseHelper *dbHelper;
@end

@implementation UserCellViewController

// Method to prepare the view to go to the next view.
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Sending the user's name to the next view.
    if ([segue.identifier isEqualToString:@"GridToAgenda"]){
        if ([segue.destinationViewController isKindOfClass:[AgendaViewController class]]){
            AgendaViewController *avc = (AgendaViewController *) segue.destinationViewController;
            avc.user = self.userSelected;
            avc.sessionTeacher = self.teacher;
            avc.sessionSchool = self.school;
            avc.dateOfHomework = [self getDate];
        }
    }
    // Sending a teacher and student to reset view.
    if ([segue.identifier isEqualToString:@"gridToResetSuccess"]){
        if ([segue.destinationViewController isKindOfClass:[ResetPasswordViewController class]]){
            ResetPasswordViewController *rpvc = (ResetPasswordViewController *) segue.destinationViewController;
            rpvc.teacher = self.teacher;
            rpvc.student = self.userSelected;
            
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialize the userNames array.  This will hold all the usernames.
    // Used for populating the grid view.
    self.userNames = [[NSMutableArray alloc]init];

    // Initialize the DatabaseHelper.  This object will bring in all the data for this view.
    self.dbHelper = [[DatabaseHelper alloc]init];
    
    // Method to process the string returned from the database
    [self processServerString];
    
    // Delegate methods
    [self.UserCellTable setDataSource:self];
    [self.UserCellTable setDelegate:self];
    [self.UserCellTable reloadData];
    
    
    //*************************************************************************************
    
    // Implemented by Andrew Browning
    // Saviing the teacher for this session in the standard user defaults (Andrew Browning)
    NSUserDefaults *hwAgendaDefaults = [NSUserDefaults standardUserDefaults];
    [hwAgendaDefaults setObject:[self.teacher name] forKey:@"hwAgendaTeacher"];
    [hwAgendaDefaults setObject:[self.teacher firstName] forKey:@"hwAgendaTeacherFirstName"];
    [hwAgendaDefaults setObject:[self.teacher lastName] forKey:@"hwAgendaTeacherLastName"];
    [hwAgendaDefaults setObject:[self.teacher userID] forKey:@"hwAgendaTeacherID"];

    [hwAgendaDefaults synchronize];
    
    //*************************************************************************************

}

// Method to pull JSON using DatabaseHelper class and process the JSON.
- (void)processServerString{
    
    NSMutableArray *tempStudentArray = [[NSMutableArray alloc]init];
    
    // Use the databaseHelper to get the students per chosen teacher.
    tempStudentArray = [[self.dbHelper getStudentsByTeacherJSON:[self.teacher userID]] mutableCopy];

    // If there was a return from the database call.
    if (tempStudentArray) {
        
        // If no JSON object present, show alert.
        if([tempStudentArray[0] isKindOfClass:[NSString class]]){
            
            [self launchJSONFailAlert];
        }
        else{
            
            // For loop to go through all the objects in the JSON array.
            for (int i = 0; i<tempStudentArray.count; i++) {
                
                // Initiate a new studentUser
                studentUser *sU = [[studentUser alloc] init];
                
                // Make a new studentUser
                [sU makeStudentUser:[[tempStudentArray objectAtIndex:i] objectForKey:@"FirstName"]
                           lastName:[[tempStudentArray objectAtIndex:i] objectForKey:@"LastName"]
                             userID:[[tempStudentArray objectAtIndex:i] objectForKey:@"UserID"]
                          studentID:[[tempStudentArray objectAtIndex:i] objectForKey:@"StudentID"]
                           userName:[[tempStudentArray objectAtIndex:i] objectForKey:@"Username"]];
                
                // Add the student to the user array for the grid view.
                [self.userNames addObject:sU];
                NSLog(@"FirstName: %@ , LastName: %@ , UserID: %@, StudentID: %@, UserName: %@",[sU firstName],[sU lastName],[sU userID],[sU studentID],[sU userName]);
            }
        }
    }
    else{
        
        [self launchFailAlert];
        
    }
    
}

// Method to show an alert for when no users are enrolled.
-(void)launchJSONFailAlert{
    
    UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"No Students!"
                                                        message:@"There are currently no students enrolled in the iHapp system with the teacher that you chose."
                                                       delegate:self
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"Choose another teacher",@"Retry",nil];
    [failAlert show];
    
}

// Method to launch an alert for a failed network connection.
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
    // Checking to see if the button is for choosing another teacher.
    if ([buttonClicked isEqualToString:@"Choose another teacher"]) {
        [self.navigationController popViewControllerAnimated:YES];
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Delegate method
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

// Delegate method
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.userNames.count;
}

// Method to populate each cell of the grid view from the array data.
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // Getting the appropriate data from userNames array
    studentUser *user = self.userNames[indexPath.row];
    UserCollectionViewCell *uCell = (UserCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UserCell" forIndexPath:indexPath];
    uCell.delegate = self;
    uCell.layer.borderColor = [UIColor clearColor].CGColor;
    
    
    // Filling the cells.
    [uCell PopulateCell:user];
    
    return uCell;
}

// Method that is in the protocol of the delegate.  This method is called from userCell and
// is passed the userName.  This method also performs the segue to the next view.
-(void) loginConfirmedSuccessful:(UICollectionViewCell*) sender user:(studentUser *) user{
    self.userSelected = user;
    [self performSegueWithIdentifier:@"GridToAgenda" sender:nil];
}

// Method to launch an alert for a successful password reset.
-(void) resetConfirmedSuccessful:(UICollectionViewCell*) sender user:(studentUser *) user{
    
    if ([self.dbHelper resetPassword:[user studentID] teacherID:[self.teacher userID]]) {
        self.userSelected = user;
        [self performSegueWithIdentifier:@"gridToResetSuccess" sender:nil];
    }
    else{
        [self launchResetFailAlert];
    }
}

// Method to launch an alert for a failed password reset.
-(void) launchResetFailAlert{
    UIAlertView *successFailAlert = [[UIAlertView alloc] initWithTitle:@"Password Reset Failed!"
                                                           message:@"Your password was not able to be reset at this time."
                                                          delegate:self
                                                 cancelButtonTitle:@"Okay"
                                                 otherButtonTitles:nil];
    [successFailAlert show];
    
}

// Method to get the date.
-(NSDate*)getDate{
    NSDate *date = [NSDate date];
    return date;
}


@end
