//
//  User.m
//  Homework Agenda
//
//  Created by Adam Serruys on 3/7/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implementation file for the User class.
 It is used to store the name and id of the user.
 
 */

#import "User.h"

@implementation User

@synthesize name = _name;
@synthesize userID = _userID;

// Method to make a user.
-(void) makeUser:(NSString*) username id:(NSString*) userID{

    self.name = username;
    self.userID = userID;
    
}


@end
