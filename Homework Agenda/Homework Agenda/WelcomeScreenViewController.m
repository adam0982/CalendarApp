//
//  WelcomeScreenViewController.m
//  Homework Agenda
//
//  Created by Adam Serruys on 2/28/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Andrew Browning
 Description: This is the implemenation file for the WelcomeScreenViewController.
 This class detirmines if a user is logged in and segues to the appropriate view.
 
 */

#import "WelcomeScreenViewController.h"
#import "SchoolViewController.h"
#import "AgendaViewController.h"

@interface WelcomeScreenViewController ()
@property (nonatomic,strong) NSString *userNameFromUserDefaults;
@property (nonatomic,strong) NSString *passwordFromUserDefaults;
@property (nonatomic,strong) NSString *loginStatusFromUserDefaults;
@property (nonatomic,strong) NSString *teacherFromUserDefaults;
@property (nonatomic,strong) NSString *teacherFirstNameFromUserDefaults;
@property (nonatomic,strong) NSString *teacherLastNameFromUserDefaults;
@property (nonatomic,strong) NSString *schoolFromUserDefaults;
@property (nonatomic,strong) NSString *userIDFromUserDefaults;
@property (nonatomic,strong) NSString *teacherIDFromUserDefaults;
@property (nonatomic,strong) NSString *schoolIDFromUserDefaults;
@property (nonatomic,strong) NSString *userFirstNameFromUserDefaults;
@property (nonatomic,strong) NSString *userLastNameFromUserDefaults;
@property (nonatomic,strong) NSString *userStudentIDFromUserDefaults;

@property (nonatomic,strong) studentUser *loggedInStudent;
@property (nonatomic,strong) teacherUser *chosenTeacher;
@property (nonatomic,strong) School *chosenSchool;

@end

@implementation WelcomeScreenViewController

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    // Sending the selected school to the next view.
    if ([segue.identifier isEqualToString:@"welcomeToAgendaView"]){
        if ([segue.destinationViewController isKindOfClass:[AgendaViewController class]]){
            AgendaViewController *avc = (AgendaViewController *) segue.destinationViewController;
            avc.user = self.loggedInStudent;
            avc.sessionTeacher = self.chosenTeacher;
            avc.sessionSchool = self.chosenSchool;
            avc.dateOfHomework = [self getDate];
        }
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setHidesBackButton:YES];
    
    
    //Getting all the saved user defaults and checking them to validate if someone is logged into an existing session.
    
    NSUserDefaults *hwAgendaDefaults = [NSUserDefaults standardUserDefaults];
    self.userNameFromUserDefaults = [hwAgendaDefaults objectForKey:@"hwAgendaUsername"];
    self.passwordFromUserDefaults = [hwAgendaDefaults objectForKey:@"hwAgendaPassword"];
    self.loginStatusFromUserDefaults = [hwAgendaDefaults objectForKey:@"hwAgendaLoginStatus"];
    self.teacherFromUserDefaults = [hwAgendaDefaults objectForKey:@"hwAgendaTeacher"];
    self.schoolFromUserDefaults = [hwAgendaDefaults objectForKey:@"hwAgendaSchool"];
    self.schoolIDFromUserDefaults = [hwAgendaDefaults objectForKey:@"hwAgendaSchoolID"];
    self.teacherIDFromUserDefaults = [hwAgendaDefaults objectForKey:@"hwAgendaTeacherID"];
    self.schoolIDFromUserDefaults =[hwAgendaDefaults objectForKey:@"hwAgendaUserID"];
    self.teacherFirstNameFromUserDefaults = [hwAgendaDefaults objectForKey:@"hwAgendaTeacherFirstName"];
    self.teacherLastNameFromUserDefaults = [hwAgendaDefaults objectForKey:@"hwAgendaTeacherLastName"];
    self.userFirstNameFromUserDefaults = [hwAgendaDefaults objectForKey:@"hwAgendaUserFirstName"];
    self.userLastNameFromUserDefaults = [hwAgendaDefaults objectForKey:@"hwAgendaUserLastName"];
    self.userStudentIDFromUserDefaults = [hwAgendaDefaults objectForKey:@"hwAgendaStudentID"];
    
    self.loggedInStudent = [[studentUser alloc] init];
    self.chosenTeacher = [[teacherUser alloc] init];
    self.chosenSchool = [[School alloc] init];
    
    [self.loggedInStudent makeStudentUser:self.userFirstNameFromUserDefaults
                                 lastName:self.userLastNameFromUserDefaults
                                   userID:self.userIDFromUserDefaults
                                studentID:self.userStudentIDFromUserDefaults
                                 userName:self.userNameFromUserDefaults];
    
    [self.chosenTeacher makeTeacherUser:self.teacherFirstNameFromUserDefaults
                               lastName:self.teacherLastNameFromUserDefaults
                                     id:self.teacherIDFromUserDefaults];
    [self.chosenSchool makeSchool:self.schoolFromUserDefaults id:self.schoolIDFromUserDefaults];
    
    // If-else statement to detirmine which view to go to.
    if ([self.loginStatusFromUserDefaults isEqualToString:@"YES"]) {
        self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome %@ from %@", self.loggedInStudent.name, self.chosenSchool.name];
          
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(segueToAgendaView) userInfo:nil repeats:NO];
    } else {
        self.welcomeLabel.text = [NSString stringWithFormat:@"Welcome!"];
        [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(segueToSchoolView) userInfo:nil repeats:NO];
    }
}

// Method triggered when a user is logged in.
- (void)segueToAgendaView{
    [self performSegueWithIdentifier:@"welcomeToAgendaView" sender:self];
}

// Method triggered when no user is logged in.
- (void)segueToSchoolView{
    [self performSegueWithIdentifier:@"welcomeToSchoolView" sender:self];
}

// Method to get the date
-(NSDate*)getDate{
    NSDate *date = [NSDate date];
    return date;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
