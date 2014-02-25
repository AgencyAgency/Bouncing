//
//  AAViewController.m
//  Bouncing
//
//  Created by Kyle Oba on 2/24/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import "AAViewController.h"
@import QuartzCore;
@import CoreMotion;

@interface AAViewController ()

@property (weak, nonatomic) IBOutlet UIView *ballView;
@property (strong, nonatomic) CADisplayLink *displayLink;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ballXConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ballYConstraint;

@property (assign, nonatomic) CGPoint velocity;
@property (assign, nonatomic) CGFloat gravity;
@property (weak, nonatomic) IBOutlet UILabel *accelXLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelYLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelZLabel;
@property (strong, nonatomic) CMMotionManager *motionManager;
@end

#define DAMPENING_FACTOR 0.9

@implementation AAViewController

- (void)tick:(CADisplayLink *)sender
{
    CGPoint vel = self.velocity;
    
    // Bounce of the left and right sides:
    CGFloat width = CGRectGetWidth(self.view.bounds);
    if (CGRectGetMaxX(self.ballView.frame) >= width) {
        vel.x = -ABS(vel.x) * DAMPENING_FACTOR;
    } else if (CGRectGetMinX(self.ballView.frame) <= 0) {
        vel.x = ABS(vel.x) * DAMPENING_FACTOR;
    }
    
    // Bounce off the bottom and top:
    CGFloat height = CGRectGetHeight(self.view.bounds);
    if (CGRectGetMaxY(self.ballView.frame) >= height) {
        vel.y = -ABS(vel.y) * DAMPENING_FACTOR;
    } else if (CGRectGetMinY(self.ballView.frame) <= 0) {
        vel.y = ABS(vel.y) * DAMPENING_FACTOR;
    }
    
    self.velocity = vel;
    [self updateVelocityWithAcceleration];
    
    CGPoint pos = CGPointMake(self.ballXConstraint.constant,
                              self.ballYConstraint.constant);
    
    // Constrain x-position of the ball:
    CGFloat maxPosX = width - CGRectGetWidth(self.ballView.bounds);
    self.ballXConstraint.constant = MAX(0, MIN(maxPosX, pos.x + self.velocity.x));
    
    // Constrain y-position of the ball:
    CGFloat maxPosY = height - CGRectGetHeight(self.ballView.bounds);
    self.ballYConstraint.constant = MAX(0, MIN(maxPosY, pos.y + self.velocity.y));
}

- (void)updateVelocityWithAcceleration
{
    CMAccelerometerData *accelData = self.motionManager.accelerometerData;
    
    // Update acceleration labels:
    self.accelXLabel.text = [NSString stringWithFormat:@"acceleration x: %.2f", accelData.acceleration.x];
    self.accelYLabel.text = [NSString stringWithFormat:@"acceleration y: %.2f", accelData.acceleration.y];
    self.accelZLabel.text = [NSString stringWithFormat:@"acceleration z: %.2f", accelData.acceleration.z];
    
    // Update velocity:
    CGPoint vel = self.velocity;
    vel.x += accelData.acceleration.x * self.gravity;
    vel.y -= accelData.acceleration.y * self.gravity;
    self.velocity = vel;
}

- (void)setupMotionManager
{
    self.motionManager = [[CMMotionManager alloc] init];
    
    if ([self.motionManager isAccelerometerAvailable]) {
        self.motionManager.accelerometerUpdateInterval = 1.0/60.0;
        [self.motionManager startAccelerometerUpdates];
    } else {
        NSLog(@"Accelerometer is not available.");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.velocity = CGPointMake(10.0, 10.0);
    self.gravity = 5.0;
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(tick:)];
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    
    [self setupMotionManager];
}

@end
