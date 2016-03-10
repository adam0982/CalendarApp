//
//  teacherUser.h
//  Homework Agenda
//
//  Created by Adam Serruys on 3/7/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the teacherUser class.
 It is used to store the name and id of a teacher.  It inherits
 from the User class
 
 */

#import <Foundation/Foundation.h>
#import "User.h"

@interface teacherUser : User

-(void) makeTeacherUser:(NSString*) firstName lastName:(NSString*) lastName id:(NSString*) userID;

@end
