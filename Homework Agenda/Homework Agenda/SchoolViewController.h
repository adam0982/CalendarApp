//
//  SchoolViewController.h
//  Homework Agenda
//
//  Created by Adam Serruys on 2/21/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the SchoolViewController.
 This controller is for the School View
 
 */

#import <UIKit/UIKit.h>
#import "School.h"

@interface SchoolViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic)NSMutableArray *schools;
@property (weak, nonatomic) IBOutlet UIPickerView *schoolPickerView;
@property (strong,nonatomic) School *chosenSchool;
@property (weak, nonatomic) IBOutlet UILabel *schoolDisplayer;
@property (weak, nonatomic) IBOutlet UIView *schoolPickerViewContainer;

- (IBAction)schoolDisplayButton:(id)sender;
- (IBAction)schoolSubmit:(id)sender;
- (IBAction)hidePickerViewWithTap:(id)sender;

@end
