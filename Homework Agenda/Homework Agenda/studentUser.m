//
//  studentUser.m
//  Homework Agenda
//
//  Created by Adam Serruys on 3/7/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implementation file of the studentUser class.
 
 */

#import "studentUser.h"


@implementation studentUser

// Method to make a student user.  It is basically a setter for all the members of this class.
-(void) makeStudentUser:(NSString*) firstName lastName:(NSString*) lastName userID:(NSString*) userID studentID:(NSString *) studentID userName:(NSString*) userName{
    
    self.firstName = firstName;
    self.lastName = lastName;
    self.name = [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
    self.userID = userID;
    self.studentID = studentID;
    self.userName = userName;
}

@end
