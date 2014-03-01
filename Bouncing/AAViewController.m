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
#import "AABallView.h"

@interface AAViewController ()

@property (strong, nonatomic) CADisplayLink *displayLink;

@property (strong, nonatomic) NSMutableArray *balls;

@property (assign, nonatomic) CGFloat gravity;
@property (weak, nonatomic) IBOutlet UILabel *accelXLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelYLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelZLabel;
@property (strong, nonatomic) CMMotionManager *motionManager;
@end

#define NUM_BALLS 20

@implementation AAViewController

- (AABallView *)ballAtRandomLocation
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = CGRectGetHeight(self.view.bounds);
    CGFloat x = arc4random() % (int)width;
    CGFloat y = arc4random() % (int)height;
    return [[AABallView alloc] initWithFrame:CGRectMake(x, y, 40, 40)
                                   worldSize:self.view.bounds.size];
}

- (NSMutableArray *)balls
{
    if (!_balls) {
        NSMutableArray *allBalls = [NSMutableArray array];
        for (int i=0; i<NUM_BALLS; i++) {
            AABallView *newBall = [self ballAtRandomLocation];
            [allBalls addObject:newBall];
            [self.view addSubview:newBall];
        }
        _balls = allBalls;
    }
    return _balls;
    
}

- (void)tick:(CADisplayLink *)sender
{
    CMAccelerometerData *accelData = self.motionManager.accelerometerData;

    // Update acceleration labels:
    self.accelXLabel.text = [NSString stringWithFormat:@"acceleration x: %.2f", accelData.acceleration.x];
    self.accelYLabel.text = [NSString stringWithFormat:@"acceleration y: %.2f", accelData.acceleration.y];
    self.accelZLabel.text = [NSString stringWithFormat:@"acceleration z: %.2f", accelData.acceleration.z];

    // Update ball position:
    CGPoint gravityForce = CGPointMake( accelData.acceleration.x * self.gravity,
                                       -accelData.acceleration.y * self.gravity);
    for (AABallView *ballView in self.balls) {
        [ballView moveWithGravity:gravityForce];
    }
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
    
    // Create a ball:


    // Set world gravitational force (to center of earth via accelerometers):
    self.gravity = 5.0;
    
    // Set up the display loop:
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(tick:)];
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    
    // Initialize use of accelerometers:
    [self setupMotionManager];
}

@end
