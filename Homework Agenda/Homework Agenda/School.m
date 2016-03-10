//
//  School.m
//  Homework Agenda
//
//  Created by Adam Serruys on 3/7/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implementation file of the School class.
 
 */

#import "School.h"

@implementation School

@synthesize name = _name;
@synthesize schoolID = _schoolID;

// Method to make a school object.
-(void) makeSchool:(NSString*) schoolName id:(NSString*) schoolID{
    
    self.name = schoolName;
    self.schoolID = schoolID;
    
}


@end
