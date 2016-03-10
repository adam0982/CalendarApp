//
//  HomeworkTableViewCell.h
//  Homework Agenda
//
//  Created by Adam Serruys on 2/14/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the homework entry rows in the Agenda View.
 It has three label properties to represent a homework subject, homework assignment description,
 and a homework due date.
 
 */

#import <UIKit/UIKit.h>
#import "HomeworkEntry.h"

@interface HomeworkTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *SubjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *HomeworkDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *DueDateLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) HomeworkEntry *homework;
@property BOOL homeworkDone;

-(void)PopulateRow:(NSString*)subject
          homework:(NSString*)homeworkAssignment
           duedate:(NSString*)dueDate
           hwEntry:(HomeworkEntry*)hwEntry;

- (IBAction)pushDoneButton:(UIButton *)sender;

@end
