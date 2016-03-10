//
//  HomeworkEntry.h
//  Homework Agenda
//
//  Created by Adam Serruys on 2/14/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the HomeworkEntry object.
 It is used to store the data about the homework entries.
 
 */

#import <Foundation/Foundation.h>

@interface HomeworkEntry : NSObject

@property(strong,nonatomic) NSString* subject;
@property(strong,nonatomic) NSString* assignment;
@property(strong,nonatomic) NSString* dueDate;
@property(nonatomic) float hoursSpentStudying;
@property(nonatomic) BOOL done;
@property(strong,nonatomic) NSString* subjectID;

-(void) makeEntry:(NSString*) subjectString assignment:(NSString*) assignmentString duedate:(NSString*) duedateString isDone:(NSString*) isDone subjectID:(NSString*) subjectID timeSpentOnThisSubject:(NSString*) timeSpent;

@end
