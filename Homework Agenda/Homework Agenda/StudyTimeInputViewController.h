//
//  StudyTimeInputViewController.h
//  Homework Agenda
//
//  Created by Adam Serruys on 4/8/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeworkEntry.h"
#import "AgendaViewController.h"

@interface StudyTimeInputViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic,strong) id delegate;
@property (weak,nonatomic) HomeworkEntry* hEntry;
@property (nonatomic) int chosenPosition;
@property (weak, nonatomic) IBOutlet UILabel *messagePrompt;
@property (weak, nonatomic) IBOutlet UITextField *timeInputField;
@property (weak,nonatomic) AgendaViewController *parent;

- (IBAction)submitTime:(UIButton *)sender;

@end

// Delegate protocol to allow this view to send a message back to it's parent view.
@protocol TimeInputDelegate <NSObject>

-(void) setTimeOfSubject:(StudyTimeInputViewController*) sender time:(float) hTime position:(int) position;


@end