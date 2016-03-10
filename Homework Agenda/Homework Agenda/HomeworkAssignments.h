//
//  HomeworkAssignments.h
//  Homework Agenda
//
//  Created by Adam Serruys on 2/24/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the HomeworkAssignments object.
 It is used to store the data about the a collection of homework entries.
 
 */


#import <Foundation/Foundation.h>
#import "HomeworkEntry.h"

@interface HomeworkAssignments : NSObject

@property (strong,nonatomic) NSString *teacherMessageText;
@property (strong,nonatomic) NSString *parentMessageText;
@property (strong,nonatomic) NSString *assignmentID;
@property (strong,nonatomic) NSString *date;
@property (nonatomic) BOOL isSubmitted;
@property (nonatomic) BOOL isEmpty;

- (void)addHomeworkEntry:(HomeworkEntry*) entry;
- (HomeworkEntry*)getHomeworkEntryAt:(int) position;
- (NSInteger)getCount;
- (void)clear;
- (NSString*)getHomeworkJSON;


@end
