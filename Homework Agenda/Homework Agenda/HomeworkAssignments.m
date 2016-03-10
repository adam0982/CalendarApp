//
//  HomeworkAssignments.m
//  Homework Agenda
//
//  Created by Adam Serruys on 2/24/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the implementation file for the HomeworkAssignments class.
 
 */

#import "HomeworkAssignments.h"

@interface HomeworkAssignments()
@property (strong, nonatomic) NSMutableArray *homeworkEntries;
@end

@implementation HomeworkAssignments

- (NSMutableArray *) homeworkEntries{
    if (!_homeworkEntries) {
        _homeworkEntries = [[NSMutableArray alloc] init];
    }
    return _homeworkEntries;
}

// Method to add a homework entry to the homework assignments array
- (void)addHomeworkEntry:(HomeworkEntry *)entry{
    [self.homeworkEntries addObject:entry];
}

// Method to get a homework entry object at an index.
- (HomeworkEntry*)getHomeworkEntryAt:(int)position{
    return self.homeworkEntries[position];
}

// Method to get the number of homework entry in this homework assignment class.
- (NSInteger)getCount{
    return self.homeworkEntries.count;
}

// Erase all the homework entries
- (void) clear{
    [self.homeworkEntries removeAllObjects];
}

// Make a JSON object for sumitting the homework
- (NSString*) getHomeworkJSON{
    
    // Array to store the homework assignments.
    NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
    
    // Go through all the all the homework entries in this object and put the time, done, and ID values of each one in a dictionary with the appropriate keys.
    for (int i = 0; i < self.homeworkEntries.count; i++) {
        
        NSString *timeString = [NSString stringWithFormat:@"%f",[self.homeworkEntries[i] hoursSpentStudying]];
        NSString *doneString = [NSString stringWithFormat:@"%d",[self.homeworkEntries[i] done]];
        NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [self.homeworkEntries[i] subjectID],@"SubAssignID",
                                        timeString,@"Time",
                                        doneString, @"Done",nil];
        
        // Add dictionary to the array.
        [jsonArray addObject:jsonDictionary];
    }
    
    // Error to handle the JSON serialization.
    NSError *error = nil;
    
    // Make a JSON object from the jsonArray object above.
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonArray options:NSJSONWritingPrettyPrinted error:&error];
    
    // Make a string from the JSON object.
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}


@end
