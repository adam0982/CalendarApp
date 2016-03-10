//
//  ResetPasswordViewController.m
//  Homework Agenda
//
//  Created by Adam Serruys on 3/20/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implementation file for the ResetViewController.
 It displays a message to the user that the password is reset.
 */

#import "ResetPasswordViewController.h"

@interface ResetPasswordViewController ()

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    // Show the reset message to the user.
    NSString *message = [NSString stringWithFormat:@"Hello %@.  Your password was reset to your default password.\n\nIf you cannot remember your default password, please contact your teacher, %@.",[self.student name], [self.teacher name]];
    
    self.resetMessageLabel.text = message;
    
    NSString *barTitle = @"Reset Password";
    
    self.navigationItem.title = barTitle;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
