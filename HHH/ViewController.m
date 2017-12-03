//
//  ViewController.m
//  HHH
//
//  Created by boitx on 18/11/2017.
//  Copyright © 2017 boitx. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Anchor.h"


@interface ViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

//
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if ([gestureRecognizer isKindOfClass: [UIPinchGestureRecognizer class]] &&
//        [otherGestureRecognizer isKindOfClass: [UIPanGestureRecognizer class]] ) {
//        return YES;
//    }
//    return NO;
//}

- (IBAction)pan:(UIPanGestureRecognizer *)gesture {
    CGFloat scale = self.imageView.transform.a;
    CGPoint point =  [gesture translationInView:gesture.view];
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, point.x / scale , point.y / scale );
    [gesture setTranslation:CGPointZero inView:gesture.view];
}

- (IBAction)configZoomDefault:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:.2 animations:^{
        [self.imageView configDefaultAnchorPoint];
        self.imageView.transform = CGAffineTransformIdentity;
        self.imageView.center = self.view.center;
    }];
}

- (IBAction)pinch:(UIPinchGestureRecognizer *)gesture {
    if (gesture.numberOfTouches < 2) {
        return;
    }
    CGFloat  scale = gesture.scale;

    if (gesture.state == UIGestureRecognizerStateBegan) {
        [gesture.view configAnchorPointWithGesture:gesture view:self.imageView];
    }else if (gesture.state == UIGestureRecognizerStateEnded ||
              gesture.state == UIGestureRecognizerStateCancelled ||
              gesture.state == UIGestureRecognizerStateFailed  ){
        [UIView configDefaultAnchorPointForView:self.imageView];
    }else{
        self.imageView.transform = CGAffineTransformScale(self.imageView.transform, scale, scale);
    }
     gesture.scale = 1;
}


@end
