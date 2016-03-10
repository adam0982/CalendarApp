//
//  HomeworkTableViewCell.m
//  Homework Agenda
//
//  Created by Adam Serruys on 2/14/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implementation file for the homework entry rows in the Agenda View.
 
 */

#import "HomeworkTableViewCell.h"

@implementation HomeworkTableViewCell

// Apple Code
- (void)awakeFromNib {
    // Initialization code
}

// Method to handle selected entries.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Method to set all the label text.
-(void)PopulateRow:(NSString*)subject
          homework:(NSString*)homeworkAssignment
           duedate:(NSString*)dueDate
           hwEntry:(HomeworkEntry*)hwEntry{
    
    //NSString *tempTitle = [NSString stringWithFormat:@"%@ Time Spent: %0.2f",homeworkAssignment,[hwEntry hoursSpentStudying]];
    self.SubjectLabel.text = subject;
    //self.HomeworkDescriptionLabel.text = tempTitle;
    self.HomeworkDescriptionLabel.text = homeworkAssignment;
    self.DueDateLabel.text = dueDate;
    self.homework = hwEntry;
    self.homeworkDone = hwEntry.done;
    NSLog(@"HomeworkDone = %d",self.homeworkDone);
    [self updateDoneButtonUI];
    
}

// Method to update the done button in each row.  It will switch the appearance of the button dependant on what the
// homework isDone BOOL is set to.  This gets called when the homework row is first loaded from the web service.
-(void)updateDoneButtonUI{
    
    if (self.homeworkDone == YES) {
        [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.doneButton setBackgroundColor: [UIColor greenColor]];
    } else {
        [self.doneButton setTitle:@"Not Done" forState:UIControlStateNormal];
        [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.doneButton setBackgroundColor: [UIColor redColor]];
    }
}

// Method to handle the button press and set values accordingly.  This is for handling the pressing of the button.
- (IBAction)pushDoneButton:(UIButton *)sender {
    
    if (!self.homeworkDone) {
        [self.doneButton setTitle:@"Done" forState:UIControlStateNormal];
        [self.doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.doneButton setBackgroundColor: [UIColor greenColor]];
        self.homeworkDone = YES;
        self.homework.done = YES;
    } else {
        [self.doneButton setTitle:@"Not Done" forState:UIControlStateNormal];
        [self.doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.doneButton setBackgroundColor: [UIColor redColor]];
        self.homeworkDone = NO;
        self.homework.done = NO;
    }
}


@end
