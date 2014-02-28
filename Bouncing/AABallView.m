//
//  AABallView.m
//  Bouncing
//
//  Created by Kyle Oba on 2/28/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AABallView.h"

@interface AABallView ()
@property (assign, nonatomic) CGPoint velocity;
@property (assign, nonatomic) CGSize worldSize;
@property (assign, nonatomic) CGFloat dampeningFactor;
@end

@implementation AABallView

- (id)initWithFrame:(CGRect)frame worldSize:(CGSize)worldSize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _worldSize = worldSize;
        
        self.backgroundColor = [UIColor magentaColor];
        self.velocity = CGPointMake(10.0, 10.0);
        self.dampeningFactor = 0.9;
    }
    return self;
}

- (void)moveWithGravity:(CGPoint)gravity
{
    CGPoint vel = self.velocity;

    // Bounce of the left and right sides:
    CGFloat width = self.worldSize.width;
    if (CGRectGetMaxX(self.frame) >= width) {
        vel.x = -ABS(vel.x) * self.dampeningFactor;
    } else if (CGRectGetMinX(self.frame) <= 0) {
        vel.x = ABS(vel.x) * self.dampeningFactor;
    }

    // Bounce off the bottom and top:
    CGFloat height = self.worldSize.height;
    if (CGRectGetMaxY(self.frame) >= height) {
        vel.y = -ABS(vel.y) * self.dampeningFactor;
    } else if (CGRectGetMinY(self.frame) <= 0) {
        vel.y = ABS(vel.y) * self.dampeningFactor;
    }

    // Apply gravitational force:
    vel.x += gravity.x;
    vel.y += gravity.y;
    self.velocity = vel;

    // Update location:
    CGPoint currentLoc = self.frame.origin;
    
    // Constrain x-position of the ball:
    CGFloat maxPosX = width - CGRectGetWidth(self.bounds);
    currentLoc.x = MAX(0, MIN(maxPosX, currentLoc.x + self.velocity.x));
    
    // Constrain y-position of the ball:
    CGFloat maxPosY = height - CGRectGetHeight(self.bounds);
    currentLoc.y = MAX(0, MIN(maxPosY, currentLoc.y + self.velocity.y));

    CGRect newFrame = self.frame;
    newFrame.origin = currentLoc;
    self.frame = newFrame;
}

@end
