//
//  UserCellViewController.h
//  Homework Agenda
//
//  Created by Adam Serruys on 2/12/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the UserCellViewController.
 This controller is for the User Cell View. It displays all the users enrolled with one teacher.
 
 */

#import <UIKit/UIKit.h>
#import "School.h"
#import "teacherUser.h"
#import "studentUser.h"

@interface UserCellViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>

@property (strong, nonatomic)teacherUser *teacher;
@property (strong, nonatomic)School *school;
@property (strong, nonatomic)NSMutableArray *userNames;
@property (weak, nonatomic) IBOutlet UICollectionView *UserCellTable;

@end
