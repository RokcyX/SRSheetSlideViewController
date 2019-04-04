//
//  SRSheetSlideViewControllerAnimationTransition.m
//
//  Created by 周家民 on 2019/4/3.
//  Copyright © 2019 STARRAIN. All rights reserved.
//

#import "SRSheetSlideViewControllerAnimationTransition.h"
#import "UIViewController+SRSheetSlide.h"
#import "UIView+SRSheetSlide.h"

@interface SRSheetSlideViewControllerAnimationTransition ()

/**
 缓存侧滑控制器
 */
@property (nonatomic,weak) UIViewController *sideSlideVC;

/**
 半透明视图
 */
@property (nonatomic,strong) UIView *translucentView;

@end

@implementation SRSheetSlideViewControllerAnimationTransition {
    UIView *snapshotView;//屏幕快照
}

#pragma mark - getter
- (UIView *)translucentView {
    if (!_translucentView) {
        _translucentView = [[UIView alloc] init];
        [_translucentView setBackgroundColor:[UIColor blackColor]];
        //点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(translucentViewOnClick)];
        [_translucentView addGestureRecognizer:tapGesture];
    }
    return _translucentView;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.actionType == SRSheetSlideViewControllerActionTypePresent) {
        [self doPresentAnimation:transitionContext];
    } else {
        [self doDismissAnimation:transitionContext];
    }
}

#pragma mark - custom
/**
 执行呈现动画

 @param transitionContext 上下文
 */
- (void)doPresentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [snapshotView removeFromSuperview];
    snapshotView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
    [containerView addSubview:snapshotView];
    //添加
    [self.translucentView removeFromSuperview];
    self.translucentView.alpha = 0;
    [containerView addSubview:self.translucentView];
    CGRect fromVCViewInitialFrame = [transitionContext initialFrameForViewController:fromVC];
    self.translucentView.frame = fromVCViewInitialFrame;
    //设置目标视图初始尺寸
    CGRect toVCViewFinalFrame = [transitionContext finalFrameForViewController:toVC];
    switch (self.sheetPosition) {
        case SRSheetSlideViewControllerSheetPositionTop:
            toVCViewFinalFrame = CGRectMake(0, -toVCViewFinalFrame.size.height * toVC.displayPercent, toVCViewFinalFrame.size.width, toVCViewFinalFrame.size.height * toVC.displayPercent);
            break;
        case SRSheetSlideViewControllerSheetPositionRight:
            toVCViewFinalFrame = CGRectMake(SRDeviceSize.width, toVCViewFinalFrame.origin.y, SRDeviceSize.width * toVC.displayPercent, toVCViewFinalFrame.size.height);
            break;
        case SRSheetSlideViewControllerSheetPositionBottom:
            toVCViewFinalFrame = CGRectMake(0, SRDeviceSize.height, toVCViewFinalFrame.size.width, toVCViewFinalFrame.size.height * toVC.displayPercent);
            break;
        case SRSheetSlideViewControllerSheetPositionLeft:
            toVCViewFinalFrame = CGRectMake(-toVCViewFinalFrame.size.width * toVC.displayPercent, 0, toVCViewFinalFrame.size.width * toVC.displayPercent, toVCViewFinalFrame.size.height);
            break;
    }
    toVC.view.frame = toVCViewFinalFrame;
    [containerView addSubview:toVC.view];
    self.translucentView.alpha = 0;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.translucentView.alpha = toVC.translucentValue;
        toVC.view.sr_x = SRDeviceSize.width - toVC.view.frame.size.width;
        switch (self.sheetPosition) {
            case SRSheetSlideViewControllerSheetPositionTop:
                toVC.view.sr_y = 0;
                break;
            case SRSheetSlideViewControllerSheetPositionRight:
                toVC.view.sr_x = SRDeviceSize.width - toVC.view.frame.size.width;
                break;
            case SRSheetSlideViewControllerSheetPositionBottom:
                toVC.view.sr_y = SRDeviceSize.height - toVC.view.frame.size.height;
                break;
            case SRSheetSlideViewControllerSheetPositionLeft:
                toVC.view.sr_x = 0;
                break;
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if (![transitionContext transitionWasCancelled]) {
            self.sideSlideVC = toVC;
        }
    }];
}

/**
 执行解散动画
 
 @param transitionContext 上下文
 */
- (void)doDismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CGRect fromVCFrame = [transitionContext finalFrameForViewController:toVC];
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        fromVC.view.sr_x = SRDeviceSize.width;
        switch (self.sheetPosition) {
            case SRSheetSlideViewControllerSheetPositionTop:
                fromVC.view.sr_y = -fromVCFrame.size.height;
                fromVC.view.sr_x = 0;
                break;
            case SRSheetSlideViewControllerSheetPositionRight:
                fromVC.view.sr_x = SRDeviceSize.width;
                break;
            case SRSheetSlideViewControllerSheetPositionBottom:
                fromVC.view.sr_y = SRDeviceSize.height;
                fromVC.view.sr_x = 0;
                break;
            case SRSheetSlideViewControllerSheetPositionLeft:
                fromVC.view.sr_x = -fromVCFrame.size.width;
                break;
        }
        self.translucentView.alpha = 0;
    } completion:^(BOOL finished) {
        if (![transitionContext transitionWasCancelled]) {
            [containerView addSubview:toVC.view];
            [self.translucentView removeFromSuperview];
            self.translucentView = nil;
            [self -> snapshotView removeFromSuperview];
            self -> snapshotView = nil;
            self.sideSlideVC =nil;
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)translucentViewOnClick {
    if (self.sideSlideVC) {
        [self.sideSlideVC dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
