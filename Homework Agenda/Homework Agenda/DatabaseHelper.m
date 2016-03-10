//
//  DatabaseHelper.m
//  Homework Agenda
//
//  Created by Adam Serruys on 2/7/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implemenation file for the DatabaseHelper class.
 
 */

#import "DatabaseHelper.h"

@implementation DatabaseHelper

// Method to check the validitiy of a login attempt.  Sends info in POST method.
-(BOOL)userLogin:(NSString*) userName password:(NSString*)passWord{
    
    // BOOL value that will be returned by this method.
    BOOL loginGood;
    
    // Set the values and names of the POST variables
    NSString *urlString = [NSString stringWithFormat:@"username=%@&password=%@",userName,passWord];
    NSData *postData = [urlString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // Initialize request object
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    // URL for login script
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ih-app.com/webservice/student-login.php"]];
    
    // Set the parameters of the request object.
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // Response and error objects to handle returns of request
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    // Making the request
    NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *strResult = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    // If-else to set the return BOOL according to the result of the POST request.
    if ([strResult isEqualToString:@"1"]) {

        loginGood = YES;
        
    } else {
    
        loginGood = NO;

    }
    // Return BOOL representing login validity.
    NSLog(@"%d",loginGood);
    return loginGood;
}

// Method to get all the schools in the system in a JSON object.  Sends info in POST method.
-(NSArray *)getAllSchoolsJSON{
    
    // Array object that will be returned by this method.
    NSArray *tempArray;
    
    // Initialize a request object
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // URL for the school script
    NSURL *url = [NSURL URLWithString:@"http://www.ih-app.com/webservice/schools.php"];
    
    // Set the parameters of the request object.
    [request setURL:url];

    // Response and error objects to handle returns of request
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSError *jError = nil;

    // Making the request
    NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // If there is no error
    if (error == nil) {
        
        // make JSON object from request return
        tempArray = [NSJSONSerialization JSONObjectWithData:myData options:0 error:&jError];
        
        // if there is a JSON error
        if (jError) {
            NSString *message = @"ERROR";
            tempArray = [[NSArray alloc] initWithObjects:message, nil];
        }
        
    }

    return tempArray;
    
}

// Method to get all the teachers that are associated with a school.  Sends info in POST method.
-(NSArray *)getTeachersBySchoolJSON:(NSString *)schoolID{
    
    // Array object that will be return by this method
    NSArray *tempArray;
    
    // Set the value and name of the POST variable.
    NSString *urlString = [NSString stringWithFormat:@"school=%@",schoolID];
    NSData *postData = [urlString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // Initialize the request object
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // URL for school script.
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ih-app.com/webservice/teachers.php"]];
    
    // Set the parameters of the request object
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // Response and error objects to handle returns of request
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSError *jError = nil;
    
    // Making the request
    NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // If there is no error from the request
    if (error == nil){
        
        // make JSON object from request return
        tempArray = [NSJSONSerialization JSONObjectWithData:myData options:0 error:&jError];
        
        // if there is a JSON error
       if (jError) {
           NSString *message = @"ERROR";
           tempArray = [[NSArray alloc] initWithObjects:message, nil];
        }
    }
    
    return tempArray;
    
}

// Method to get all the students that are enrolled with a teacher.  Sends info in POST method.
-(NSArray *)getStudentsByTeacherJSON:(NSString *)teacherID{
    
    // Array object to be returned from this method.
    NSArray *tempArray;
    
    //Set the name and value of the POST variable.
    NSString *urlString = [NSString stringWithFormat:@"teacher=%@",teacherID];
    NSData *postData = [urlString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // Initialize the request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // URL for the student script
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ih-app.com/webservice/students.php"]];
    
    // Set the parameters of the request.
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // Response and error objects to handle returns of request
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSError *jError = nil;
    
    // Making the request
    NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    // If there is no error from the request.
    if (error == nil){
        
        // Make a JSON object from the request return.
        tempArray = [NSJSONSerialization JSONObjectWithData:myData options:0 error:&jError];
        
        // If there is a JSON error.
        if (jError) {
            NSString *message = @"ERROR";
            tempArray = [[NSArray alloc] initWithObjects:message, nil];
        }
    }
    
    return tempArray;
    
}

// Method to get all the info to fill the agenda for a certain student and date.  Sends in POST method
-(NSArray *)getAgendaJSON:(NSString *)studentID date:(NSString *)date{
    
    // Array object that is returned from this method.
    NSArray *tempArray;
    
    // Set the names and values of the POST variables
    NSString *urlString = [NSString stringWithFormat:@"student_id=%@&assignment_date=%@",studentID,date];
    NSData *postData = [urlString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // Initialize the request object.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // URL for the agenda script
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ih-app.com/webservice/assignments.php"]];
    
    // Setting the parameters for the request object
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // Response and error objects to handle returns of request
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSError *jError = nil;
    
    // Making the request
    NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSString *strResult = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",strResult);
    // If there was no errors from the request.
    if (error == nil){
        
        // Make a JSON object from the request.
        tempArray = [NSJSONSerialization JSONObjectWithData:myData options:0 error:&jError];

        // If there was a JSON error.
        if (jError) {
            NSString *message = @"ERROR";
            tempArray = [[NSArray alloc] initWithObjects:message, nil];
        }
    }
    
    return tempArray;
}

// Method to write user data (signature image, data) to database.  Send in POST method
-(BOOL)submitUserData:(NSString *) studentID assignmentID:(NSString *)assignmentID signatureString:(NSString *)signature submissionDate:(NSString *) submitDate parentNote:(NSString *) parentNote homeworkJSON:(NSString *)homeworkJSON{
    
    // BOOL to be returned from this method.
    BOOL submitGood;
    
    // Set the names and values of the POST variables.
    NSString *urlString = [NSString stringWithFormat:@"studentID=%@&assignmentID=%@&signature=%@&dateOfSubmission=%@&note=%@&subject_assignments=%@",studentID,assignmentID,signature,submitDate,parentNote,homeworkJSON];
    NSData *postData = [urlString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // Initialize the request object.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // URL for the submit script
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ih-app.com/webservice/submit.php"]];
    
    // Set the parameters of the request object.
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // Response and error objects for the request.
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    // Making the request
    NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *strResult = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];

    // If-else to set the return BOOL according to the result of the POST request.
    if ([strResult isEqualToString:@"1"]) {
        
        submitGood = YES;
        
    } else {
        
        submitGood = NO;
        
    }
    // Return BOOL representing submit success.
    return submitGood;
}




// Method to reset password to default password.  Sent in POST method
-(BOOL)resetPassword:(NSString *) studentID teacherID:(NSString *) teacherID{
    
    // BOOL to be returned by this method
    BOOL passwordReset;
    
    // Setting the values and names of the POST variables.
    NSString *urlString = [NSString stringWithFormat:@"student_id=%@&teacher_id=%@",studentID,teacherID];
    NSData *postData = [urlString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // Initialize the request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // URL for the password reset script
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ih-app.com/webservice/password-reset-default.php"]];
    
    // Setting the parameter of the request.
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // Response and error objects for the request.
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    // Making the request.
    NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *strResult = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];

    // If-else to set the return BOOL according to the result of the POST request.
    if ([strResult isEqualToString:@"1"]) {
        
        passwordReset = YES;

    } else {
        
        passwordReset = NO;
        
    }
    
    return passwordReset;
}

// Method to change password to new password.  Sent in POST method
-(BOOL)changePassword:(NSString *) userID oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword confirmPassword:(NSString *)confirmPassword{
    
    // BOOL to be returned by this method.
    BOOL passwordChanged;
    
    // Setting the names and values of the POST variables.
    NSString *urlString = [NSString stringWithFormat:@"user_id=%@&old_password=%@&new_password=%@&confirm_password=%@",userID,oldPassword,newPassword,confirmPassword];
    NSData *postData = [urlString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // Initialize the request object.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // URL for change password script
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.ih-app.com/webservice/password-update.php"]];
    
    // Set the parameters of the request
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // Response and error objects for the request.
    NSURLResponse *response = nil;
    NSError *error = nil;
    
    // Making the request
    NSData *myData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *strResult = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    
    // If-else to set the return BOOL according to the result of the POST request.
    if ([strResult isEqualToString:@"1"]) {
        
        passwordChanged = YES;

    } else {
        
        passwordChanged = NO;
        
    }

    
    return passwordChanged;
}


@end
