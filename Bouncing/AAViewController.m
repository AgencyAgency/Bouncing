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

@property (strong, nonatomic) AABallView *ballView;

@property (assign, nonatomic) CGFloat gravity;
@property (weak, nonatomic) IBOutlet UILabel *accelXLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelYLabel;
@property (weak, nonatomic) IBOutlet UILabel *accelZLabel;
@property (strong, nonatomic) CMMotionManager *motionManager;
@end

@implementation AAViewController

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
    [self.ballView moveWithGravity:gravityForce];
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
    self.ballView = [[AABallView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)
                                            worldSize:self.view.bounds.size];
    [self.view addSubview:self.ballView];

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
