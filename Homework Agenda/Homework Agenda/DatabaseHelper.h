//
//  DatabaseHelper.h
//  Homework Agenda
//
//  Created by Adam Serruys on 2/7/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the DatabaseHelper class.
 It is used to handle all database calls from the app.
 
 */

#import <Foundation/Foundation.h>

@interface DatabaseHelper : NSObject

-(BOOL)userLogin:(NSString*) userName password:(NSString*)passWord;

-(NSArray *)getAllSchoolsJSON;

-(NSArray *)getTeachersBySchoolJSON:(NSString *)schoolID;

-(NSArray *)getStudentsByTeacherJSON:(NSString *) teacherID;

-(NSArray *)getAgendaJSON:(NSString *)studentID date:(NSString *)date;

-(BOOL)submitUserData:(NSString *) studentID assignmentID:(NSString *)assignmentID signatureString:(NSString *)signature submissionDate:(NSString *) submitDate parentNote:(NSString *) parentNote homeworkJSON:(NSString *)homeworkJSON;

-(BOOL)resetPassword:(NSString *) studentID teacherID:(NSString *) teacherID;

-(BOOL)changePassword:(NSString *) userID oldPassword:(NSString*) oldPassword newPassword:(NSString*) newPassword confirmPassword:(NSString*) confirmPassword;

@end
