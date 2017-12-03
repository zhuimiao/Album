# 仿相册
> 1. 以手指中心缩放图片
> 2. 单指和双指拖动图片
> 3. 同时缩放和平移图片
> 4. 双击恢复图片移动缩放前的初始状态

<!--more-->
## anchorPoint

```
/* Defines the anchor point of the layer's bounds rect, as a point in
 * normalized layer coordinates - '(0, 0)' is the bottom left corner of
 * the bounds rect, '(1, 1)' is the top right corner. Defaults to
 * '(0.5, 0.5)', i.e. the center of the bounds rect. Animatable. */
```

layer 默认在 bounds rect的左下角为：(0, 0)， 右上角为：(1, 1)， 默认为： (0.5, 0.5)。

## 1. 以手指中心缩放图片

步骤：
1. 获取缩放手势两个手指在图片上的位置
2. 根据这两个位置设置计算锚点的位置
3. 手势开始时，设置锚点的位置为上一步的计算结果
4. 手势结束时，恢复锚点位置

    计算新锚点

```objc
    CGPoint onoPoint = [gesture locationOfTouch:0 inView:view];
    CGPoint twoPoint = [gesture locationOfTouch:1 inView:view];
    
    CGPoint anchorPoint;
    anchorPoint.x = (onoPoint.x + twoPoint.x) / 2 / view.bounds.size.width;
    anchorPoint.y = (onoPoint.y + twoPoint.y) / 2 / view.bounds.size.height;
```

设置锚点时，view会突然闪现一段距离，为了解决这个问题，我们需要在设置锚点时，同时移动view的中心点。

```objc
 CGPoint oldOrigin = view.frame.origin;
    view.layer.anchorPoint = anchorPoint;
    CGPoint newOrigin = view.frame.origin;

    CGPoint transition;
    transition.x = newOrigin.x - oldOrigin.x;
    transition.y = newOrigin.y - oldOrigin.y;

    view.center = CGPointMake (view.center.x - transition.x, view.center.y - transition.y);
```

实践（缩放图片只需要设置仿射变换属性就可以了）

```objc
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
```

## 2. 单指和双指拖动图片
拖动图片，图片跟随手指在屏幕上移动，只需要设置仿射变换属性就可以了。

注意：如果图片已经缩放了，设置放射变换时，需要考虑缩放比例因子。

实践：

```objc
- (IBAction)pan:(UIPanGestureRecognizer *)gesture {
    CGFloat scale = self.imageView.transform.a;
    CGPoint point =  [gesture translationInView:gesture.view];
    self.imageView.transform = CGAffineTransformTranslate(self.imageView.transform, point.x / scale , point.y / scale );
    [gesture setTranslation:CGPointZero inView:gesture.view];
}
```

## 3. 同时缩放和平移图片
缩放和平移手势同时设置代理，实现如下方法就可以了

```objc
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

```

## 4. 双击恢复图片移动缩放前的初始状态


步骤：
1. 设置仿射变换属性为 CGAffineTransformIdentity
2. 设置图片的中心位置
3. 
提示： 加上动画不生硬比较流畅

```objc
- (IBAction)configZoomDefault:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:.2 animations:^{
        [self.imageView configDefaultAnchorPoint];
        self.imageView.transform = CGAffineTransformIdentity;
        self.imageView.center = self.view.center;
    }];
}
```

## [源码]()

 

