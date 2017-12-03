//
//  UIView+Anchor.m
//  HHH
//
//  Created by boitx on 02/12/2017.
//  Copyright © 2017 boitx. All rights reserved.
//

#import "UIView+Anchor.h"

@implementation UIView (Anchor)

+ (void)configDefaultAnchorPointForView:(UIView *)view
{
    [UIView configAnchorPoint:CGPointMake(0.5f, 0.5f) forView:view];
}

- (void)configDefaultAnchorPoint
{
    [self configAnchorPoint:CGPointMake(0.5f, 0.5f)];
}

- (void)configAnchorPoint:(CGPoint)anchorPoint
{
    [UIView configAnchorPoint:anchorPoint forView:self];
}

+ (void)configAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;

    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;

    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
}

#pragma mark - 设置旋转中心锚点
- (void)configAnchorPointWithGesture:(UIGestureRecognizer *)gr
{
    [self configAnchorPointWithGesture:gr view:nil];
}

- (void)configAnchorPointWithGesture:(UIGestureRecognizer *)gesture view:(UIView *)view
{
    if (!view) {
        view = gesture.view;
    }
    CGPoint onoPoint = [gesture locationOfTouch:0 inView:view];
    CGPoint twoPoint = [gesture locationOfTouch:1 inView:view];
    
    CGPoint anchorPoint;
    anchorPoint.x = (onoPoint.x + twoPoint.x) / 2 / view.bounds.size.width;
    anchorPoint.y = (onoPoint.y + twoPoint.y) / 2 / view.bounds.size.height;
    
    [UIView configAnchorPoint:anchorPoint forView:view];
}




@end
