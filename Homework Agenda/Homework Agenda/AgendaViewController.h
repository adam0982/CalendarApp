//
//  AgendaViewController.h
//  Homework Agenda
//
//  Created by Adam Serruys on 2/7/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the AgendaViewController.
 This controller is for the Agenda View
 
 */

#import <UIKit/UIKit.h>
#import "HomeworkAssignments.h"
#import "studentUser.h"
#import "teacherUser.h"
#import "School.h"
#import "SignatureView.h"

@interface AgendaViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *HomeworkTableView;
@property (weak, nonatomic) IBOutlet UILabel *StudentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;

@property (strong, nonatomic) NSDate *dateOfHomework;
@property (strong, nonatomic) NSString *dateForFetchingHomework;
@property (strong, nonatomic) HomeworkAssignments *homeworkAssignments;

@property (nonatomic,strong) studentUser *user;
@property (nonatomic,strong) teacherUser *sessionTeacher;
@property (nonatomic,strong) School *sessionSchool;
@property (nonatomic,strong) HomeworkEntry *subjectForTimeInput;

@property (weak, nonatomic) IBOutlet UIView *hwDatePickerContainer;
@property (weak, nonatomic) IBOutlet UIDatePicker *hwDatePicker;
@property (weak, nonatomic) IBOutlet UITextView *ParentMessage;
@property (weak, nonatomic) IBOutlet UITextView *TeacherMessage;
@property (weak, nonatomic) IBOutlet SignatureView *signaturePad;
@property (weak, nonatomic) IBOutlet UIButton *SubmitButton;
@property (weak, nonatomic) IBOutlet UILabel *SubmitButtonLabel;

- (IBAction)changeHomeworkToThisDate:(UIButton *)sender;
- (IBAction)submitUserData:(UIButton *)sender;



@end
