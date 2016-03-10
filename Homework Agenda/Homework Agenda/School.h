//
//  School.h
//  Homework Agenda
//
//  Created by Adam Serruys on 3/7/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the school class.
 It is used to store the name and id of a school.   
 */

#import <Foundation/Foundation.h>

@interface School : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *schoolID;

-(void) makeSchool:(NSString*) schoolName id:(NSString*) schoolID;

@end
