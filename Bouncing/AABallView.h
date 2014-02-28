//
//  AABallView.h
//  Bouncing
//
//  Created by Kyle Oba on 2/28/14.
//  Copyright (c) 2014 AgencyAgency. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AABallView : UIView

- (id)initWithFrame:(CGRect)frame worldSize:(CGSize)worldSize;
- (void)moveWithGravity:(CGPoint)gravity;

@end
