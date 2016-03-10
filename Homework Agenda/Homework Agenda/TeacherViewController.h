//
//  TeacherViewController.h
//  Homework Agenda
//
//  Created by Adam Serruys on 2/14/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the TeacherViewController.
 This controller is for the Teacher View
 
 */

#import <UIKit/UIKit.h>
#import "School.h"
#import "teacherUser.h"

@interface TeacherViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource>

- (IBAction)teacherSubmit:(id)sender;
- (IBAction)hideTeacherPickerTap:(id)sender;
- (IBAction)pickTeacherFromPicker:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *pickTeacherButton;
@property (weak, nonatomic) IBOutlet UILabel *teacherDisplayer;

@property (nonatomic,strong) School *school;
@property (nonatomic,strong) teacherUser *chosenTeacher;
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (strong, nonatomic) NSMutableArray *teachers;

@property (weak, nonatomic) IBOutlet UIPickerView *teacherPickerView;
@property (weak, nonatomic) IBOutlet UIView *teacherPickerViewContainer;
@property (weak, nonatomic) IBOutlet UIImageView *schoolLogo;


@end
