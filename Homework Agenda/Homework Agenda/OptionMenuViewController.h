//
//  OptionMenuViewController.h
//  Homework Agenda
//
//  Created by Adam Serruys on 3/18/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "studentUser.h"
#import "teacherUser.h"
#import "School.h"

@interface OptionMenuViewController : UIViewController

@property (nonatomic,strong) studentUser *student;
@property (nonatomic,strong) teacherUser *teacher;
@property (nonatomic,strong) School *school;
@property (weak, nonatomic) IBOutlet UITextField *textFieldForOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldForNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldForConfirmPassword;

@property (weak, nonatomic) IBOutlet UIView *ChangePasswordClusterView;
- (IBAction)ChangePasswordSubmitPressed:(UIButton *)sender;

- (IBAction)contactUsButtonPressed:(UIButton *)sender;

@end
