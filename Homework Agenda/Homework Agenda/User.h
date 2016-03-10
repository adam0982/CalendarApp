//
//  User.h
//  Homework Agenda
//
//  Created by Adam Serruys on 3/7/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the User class.
 It is used to store the name and id of the user.
 
 */


#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *userID;

-(void) makeUser:(NSString*) username id:(NSString*) userID;
@end
