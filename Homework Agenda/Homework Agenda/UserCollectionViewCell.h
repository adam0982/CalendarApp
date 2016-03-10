//
//  UserCollectionViewCell.h
//  Homework Agenda
//
//  Created by Adam Serruys on 2/12/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 Author: Adam Serruys
 Description: This is the header file for the username cell in the user grid view.
 It handles a click on the cell, as well as populating the view.
 
 */


#import <UIKit/UIKit.h>
#import "studentUser.h"



@interface UserCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) id delegate;
@property (weak, nonatomic) IBOutlet UIButton *UserCellButton;
@property (strong,nonatomic) studentUser *user;


-(void)PopulateCell:(studentUser *)user;

- (IBAction)clickedOnCellButton:(id)sender;

@end

// Delegate protocol to allow a cell to send a message back to it's parent view.
@protocol CustomCellDelegate <NSObject>

-(void) loginConfirmedSuccessful:(UICollectionViewCell*) sender user:(studentUser *) user;
-(void) resetConfirmedSuccessful:(UICollectionViewCell*) sender user:(studentUser *) user;

@end



