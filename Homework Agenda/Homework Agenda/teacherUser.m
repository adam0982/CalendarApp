//
//  teacherUser.m
//  Homework Agenda
//
//  Created by Adam Serruys on 3/7/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implementation file of the teacherUser class.
 
 */

#import "teacherUser.h"

@implementation teacherUser

// Method to make a teacher user.  It is basically a setter for all the members of this class.
-(void) makeTeacherUser:(NSString*) firstName lastName:(NSString*) lastName id:(NSString*) userID{
    self.firstName = firstName;
    self.lastName = lastName;
    self.name = [NSString stringWithFormat:@"%@ %@",self.firstName,self.lastName];
    self.userID = userID;
}

@end
