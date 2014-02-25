//
//  AAViewController.m
//  Bouncing
//
//  Created by Kyle Oba on 2/24/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AAViewController.h"
@import QuartzCore;

@interface AAViewController ()

@property (weak, nonatomic) IBOutlet UIView *ballView;
@property (strong, nonatomic) CADisplayLink *displayLink;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ballXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ballYConstraint;

@property (assign, nonatomic) CGPoint velocity;
@end

@implementation AAViewController

- (void)tick:(CADisplayLink *)sender
{
    CGPoint vel = self.velocity;
    
    // Bounce of the left and right sides:
    CGFloat width = CGRectGetWidth(self.view.bounds);
    if (CGRectGetMaxX(self.ballView.frame) >= width) {
        vel.x = -ABS(vel.x);
    } else if (CGRectGetMinX(self.ballView.frame) <= 0) {
        vel.x = ABS(vel.x);
    }
    
    // Bounce off the bottom and top:
    CGFloat height = CGRectGetHeight(self.view.bounds);
    if (CGRectGetMaxY(self.ballView.frame) >= height) {
        vel.y = -ABS(vel.y);
    } else if (CGRectGetMinY(self.ballView.frame) <= 0) {
        vel.y = ABS(vel.y);
    }
    self.velocity = vel;
    
    CGPoint pos = CGPointMake(self.ballXConstraint.constant,
                              self.ballYConstraint.constant);
    self.ballXConstraint.constant = pos.x + self.velocity.x;
    self.ballYConstraint.constant = pos.y + self.velocity.y;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.velocity = CGPointMake(10.0, 10.0);
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(tick:)];
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
}

@end
