//
//  HomeworkEntry.m
//  Homework Agenda
//
//  Created by Adam Serruys on 2/14/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implementation file for the HomeworkEntry class.
 
 */

#import "HomeworkEntry.h"

@implementation HomeworkEntry

@synthesize subject = _subject;
@synthesize assignment = _assignment;
@synthesize dueDate = _dueDate;

// Method to set the subject, assignment, duedate, isDone, and timeSpent members.
-(void) makeEntry:(NSString*) subjectString assignment:(NSString*) assignmentString duedate:(NSString*) duedateString isDone:(NSString *)isDone subjectID:(NSString *)subjectID timeSpentOnThisSubject:(NSString *)timeSpent{
    
    // Make a BOOL from the isDone parameter
    BOOL tempDone;
    if ([isDone isEqualToString:@"1"]) {
        tempDone = YES;
    }
    else{
        tempDone = NO;
    }
    
    // set all the members.
    self.subject = subjectString;
    self.assignment = assignmentString;
    self.dueDate = duedateString;
    self.hoursSpentStudying = [timeSpent floatValue];
    self.done = tempDone;
    self.subjectID = subjectID;
}
@end
