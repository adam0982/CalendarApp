//
//  studentUser.h
//  Homework Agenda
//
//  Created by Adam Serruys on 3/7/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the studentUser class.
 It is used to store the name and id of a student.  It inherits
 from the User class
 
 */

#import <Foundation/Foundation.h>
#import "User.h"

@interface studentUser : User

@property (strong, nonatomic) NSString *studentID;
@property (strong, nonatomic) NSString *userName;

-(void) makeStudentUser:(NSString*) firstName lastName:(NSString*) lastName userID:(NSString*) userID studentID:(NSString *) studentID userName:(NSString*) userName;

@end
