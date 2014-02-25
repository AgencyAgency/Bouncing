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

@property (assign, nonatomic) CGFloat theta;
@end

@implementation AAViewController

- (void)draw:(CADisplayLink *)sender
{
    self.theta += 0.1;

    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat x = width/2.0 * sin(self.theta) + width/2.0;
    self.ballXConstraint.constant = x;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
//    CADisplayLink.displayLinkWithTarget( self, @selector(draw:) )
    
    self.displayLink = [CADisplayLink displayLinkWithTarget:self
                                                   selector:@selector(draw:)];
    
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop]
                           forMode:NSDefaultRunLoopMode];
}

@end
