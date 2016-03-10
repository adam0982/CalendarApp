//
//  SignatureView.m
//  Homework Agenda
//
//  Created by Adam Serruys on 3/26/15.
//  Copyright (c) 2015 Adam Serruys. All rights reserved.
//

/*
 This class was created by Andrew Browning.
 */

#import "SignatureView.h"
#import <QuartzCore/QuartzCore.h>

// Used to draw the path
static CGPoint midpoint(CGPoint p0, CGPoint p1) {
    return (CGPoint) {
        (p0.x + p1.x) / 2.0,
        (p0.y + p1.y) / 2.0
    };
}

@interface SignatureView () {
    UIBezierPath *path;
    CGPoint previousPoint;
}
@end

@implementation SignatureView

// Method when view is created.
- (void)commonInit {
    path = [UIBezierPath bezierPath];
    
    // Adding the ability to draw on the view.  It is known as a pan gesture.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.maximumNumberOfTouches = pan.minimumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
    
    // Erase the view with a long tap.
    [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(erase)]];
    
}

// Initialization method.
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) [self commonInit];
    return self;
}

// Initializatin method.
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) [self commonInit];
    return self;
}

// Erases the drawn paths on the view, if any are there.
- (void)erase {
    path = [UIBezierPath bezierPath];
    [self setNeedsDisplay];
}


// Method for when a touch is moved on the view
- (void)pan:(UIPanGestureRecognizer *)pan {
    
    // Keeps track of the current point.
    CGPoint currentPoint = [pan locationInView:self];
    
    // Gets midpoing of the previous touch and the current touch
    CGPoint midPoint = midpoint(previousPoint, currentPoint);
    
    // If-else to detirmine if touches just began or not.  If they have not, a curve is added between the current and previous point.  A curve is added for a smoother path
    if (pan.state == UIGestureRecognizerStateBegan) {
        [path moveToPoint:currentPoint];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        [path addQuadCurveToPoint:midPoint controlPoint:previousPoint];
    }
    
    // Sets the previous point to the current point for the next move.
    previousPoint = currentPoint;
    
    // Draws the path
    [self setNeedsDisplay];
}

// Called when path is drawn.  Used to different parameter of the stroke.
- (void)drawRect:(CGRect)rect
{
    [[UIColor blackColor] setStroke];
    [path stroke];
}

// Method to clear the signature pad.  Used when the assignments are changed. Added by Adam Serruys
-(void) clearThePad{
    [self erase];
}

@end
