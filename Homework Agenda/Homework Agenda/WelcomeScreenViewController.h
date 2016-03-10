//
//  WelcomeScreenViewController.h
//  Homework Agenda
//
//  Created by Adam Serruys on 2/28/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Andrew Browning
 Description: This is the header file for the WelcomeViewController.
 This controller is for the Welcome View
 */

#import <UIKit/UIKit.h>

@interface WelcomeScreenViewController : UIViewController
//Comment
@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
