//
//  ResetPasswordViewController.h
//  Homework Agenda
//
//  Created by Adam Serruys on 3/20/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the ResetPasswordViewController.
 This controller is for the Reset Password View
 
 */
#import <UIKit/UIKit.h>
#import "teacherUser.h"
#import "studentUser.h"

@interface ResetPasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *resetMessageLabel;

@property (strong, nonatomic)teacherUser *teacher;

@property (strong, nonatomic)studentUser *student;

@end
