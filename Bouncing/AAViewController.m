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
@property (strong, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;
@end

#define NUM_BALLS 20
#define PRESS_FORCE_MAG 5.0
#define GRAVITY_MAG 2.0

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

+ (CGFloat)magnitudeVec:(CGPoint)vec
{
    return sqrtf(powf(vec.x, 2) + powf(vec.y, 2));
}

+ (CGPoint)normalFromPtA:(CGPoint)ptA toPtB:(CGPoint)ptB
{
    CGPoint aToB = CGPointMake(ptB.x - ptA.x,
                               ptB.y - ptA.y);
    CGFloat mag = [self magnitudeVec:aToB];
    return CGPointMake(aToB.x/mag, aToB.y/mag);
}

+ (CGFloat)distancePtA:(CGPoint)ptA toPtB:(CGPoint)ptB
{
    return sqrtf(powf(ptB.x - ptA.x, 2) + powf(ptB.y - ptA.y, 2));
}

- (void)applyPressForceToBall:(AABallView *)ballView pressLocation:(CGPoint)pressLocation
{
    CGFloat d = [self.class distancePtA:ballView.frame.origin
                                  toPtB:pressLocation];

    CGPoint pressUnitVec = [self.class normalFromPtA:ballView.frame.origin
                                                    toPtB:pressLocation];
    
    CGFloat distanceFactor = d / CGRectGetWidth(self.view.bounds);
    CGFloat massFactor = PRESS_FORCE_MAG * (0.7 + arc4random_uniform(7)/10.0);
    CGPoint pressForce = CGPointMake(massFactor * pressUnitVec.x * distanceFactor,
                                     massFactor * pressUnitVec.y * distanceFactor);

    [ballView applyForce:pressForce];
}

- (void)tick:(CADisplayLink *)sender
{
    CMAccelerometerData *accelData = self.motionManager.accelerometerData;

    // Update acceleration labels:
    self.accelXLabel.text = [NSString stringWithFormat:@"acceleration x: %.2f", accelData.acceleration.x];
    self.accelYLabel.text = [NSString stringWithFormat:@"acceleration y: %.2f", accelData.acceleration.y];
    self.accelZLabel.text = [NSString stringWithFormat:@"acceleration z: %.2f", accelData.acceleration.z];
    
    // Update ball position:
    CGPoint gravityForce = CGPointMake( accelData.acceleration.x * GRAVITY_MAG,
                                       -accelData.acceleration.y * GRAVITY_MAG);
    for (AABallView *ballView in self.balls) {
        // Apply Gravity:
        [ballView applyForce:gravityForce];
        
        // Apply Long Press Deflection:
        if (self.longPressGesture.state == UIGestureRecognizerStateBegan ||
            self.longPressGesture.state == UIGestureRecognizerStateChanged) {
            CGPoint pressLoc = [self.longPressGesture locationInView:self.view];
            [self applyPressForceToBall:ballView
                          pressLocation:pressLoc];
        }
        
        // Move the ball:
        [ballView move];
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
    
    // Set up the display loop:
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(tick:)];
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
    
    // Initialize use of accelerometers:
    [self setupMotionManager];
}

@end
