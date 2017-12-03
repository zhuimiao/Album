//
//  UIView+Anchor.h
//  HHH
//
//  Created by boitx on 02/12/2017.
//  Copyright © 2017 boitx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Anchor)


/**
 为参数 view 恢复默认锚点
 */
+ (void)configDefaultAnchorPointForView:(UIView *)view;


/**
 self 恢复默认锚点
 */
- (void)configDefaultAnchorPoint;

/**
 self 设置锚点
 */
- (void)configAnchorPoint:(CGPoint)anchorPoint;


/**
 为 参数 view 设置锚点
 */
+ (void)configAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view;


/**
self 根据手势设置锚点
 */
- (void)configAnchorPointWithGesture:(UIGestureRecognizer *)gr;


/**
 为 参数 view 根据手势设置锚点
 */
- (void)configAnchorPointWithGesture:(UIGestureRecognizer *)gr view:(UIView *)view;




@end
