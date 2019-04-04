//
//  SRSheetSlideViewControllerInteractiveTransition.m
//
//  Created by 周家民 on 2019/4/3.
//  Copyright © 2019 STARRAIN. All rights reserved.
//

#import "SRSheetSlideViewControllerInteractiveTransition.h"
#import "UIView+SRSheetSlide.h"

@interface SRSheetSlideViewControllerInteractiveTransition () <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer *panGesture;

/**
 从哪个控制器来
 */
@property (nonatomic,weak) UIViewController *fromViewController;


@end

@implementation SRSheetSlideViewControllerInteractiveTransition {
    BOOL shouldComplete;
}

- (void)prepareEdgeSlideGestureWithViewController:(UIViewController *)viewController {
    if (!viewController) return;
    self.fromViewController = viewController;
    UIPanGestureRecognizer *edgePanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanGesture:)];
    [viewController.view addGestureRecognizer:edgePanGesture];
    edgePanGesture.delegate = self;
    shouldComplete = NO;
    self.interactiving = NO;
}

- (CGFloat)completionSpeed {
    return 1 - self.percentComplete;
}

#pragma mark - setter
- (void)setToViewController:(UIViewController *)toViewController {
    if (_toViewController) {
        [_toViewController.view removeGestureRecognizer:self.panGesture];
    }
    _toViewController = toViewController;
    [_toViewController.view addGestureRecognizer:self.panGesture];
}

#pragma mark - getter
- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    }
    return _panGesture;
}

#pragma mark - private
- (void)edgePanGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:recognizer.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            CGPoint location = [recognizer locationInView:self.fromViewController.view];
            switch (self.sheetPosition) {
                case SRSheetSlideViewControllerSheetPositionTop:
                    self.interactiving = location.y < 0.2 * self.fromViewController.view.sr_height;
                    break;
                case SRSheetSlideViewControllerSheetPositionRight:
                    self.interactiving = location.x > self.fromViewController.view.frame.size.width * 0.8;
                    break;
                case SRSheetSlideViewControllerSheetPositionBottom:
                    self.interactiving = location.y > 0.8 * self.fromViewController.view.sr_height;
                    break;
                case SRSheetSlideViewControllerSheetPositionLeft:
                    self.interactiving = location.x < self.fromViewController.view.frame.size.width * 0.2;
                    break;
            }
            if (self.interactiving) {
                [self.fromViewController presentViewController:self.toViewController animated:YES completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat offset;
            switch (self.sheetPosition) {
                case SRSheetSlideViewControllerSheetPositionTop:
                    offset = translation.y / (self.fromViewController.view.sr_height * 0.7);
                    break;
                case SRSheetSlideViewControllerSheetPositionRight:
                    offset = translation.x / (self.fromViewController.view.sr_width * 0.7);
                    break;
                case SRSheetSlideViewControllerSheetPositionBottom:
                    offset = translation.y / (self.fromViewController.view.sr_height * 0.7);
                    break;
                case SRSheetSlideViewControllerSheetPositionLeft:
                    offset = translation.x / (self.fromViewController.view.sr_width * 0.7);
                    break;
            }
            CGFloat percent = fmin(1, fmaxf(0, fabs(offset)));
            shouldComplete = percent > 0.5;
            if (!shouldComplete) {
                switch (self.sheetPosition) {
                    case SRSheetSlideViewControllerSheetPositionLeft:
                    case SRSheetSlideViewControllerSheetPositionRight:
                        shouldComplete = fabs([recognizer velocityInView:self.fromViewController.view].x) > 150;//速率大于150则完成动画
                        break;
                    case SRSheetSlideViewControllerSheetPositionTop:
                    case SRSheetSlideViewControllerSheetPositionBottom:
                        shouldComplete = fabs([recognizer velocityInView:self.fromViewController.view].y) > 150;//速率大于150则完成动画
                        break;
                }
            }
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            self.interactiving = NO;
            if (shouldComplete) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:recognizer.view];
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan: {
            switch (self.sheetPosition) {
                case SRSheetSlideViewControllerSheetPositionTop:
                    self.interactiving = translation.y < 0;
                    break;
                case SRSheetSlideViewControllerSheetPositionRight:
                    self.interactiving = translation.x > 0;
                    break;
                case SRSheetSlideViewControllerSheetPositionBottom:
                    self.interactiving = translation.y > 0;
                    break;
                case SRSheetSlideViewControllerSheetPositionLeft:
                    self.interactiving = translation.x < 0;
                    break;
            }
            if (self.interactiving) {
                [self.toViewController dismissViewControllerAnimated:YES completion:nil];
            }
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGFloat offset;
            switch (self.sheetPosition) {
                case SRSheetSlideViewControllerSheetPositionTop:
                    offset = translation.y;
                    break;
                case SRSheetSlideViewControllerSheetPositionRight:
                    offset = translation.x;
                    break;
                case SRSheetSlideViewControllerSheetPositionBottom:
                    offset = translation.y;
                    break;
                case SRSheetSlideViewControllerSheetPositionLeft:
                    offset = translation.x;
                    break;
            }
            CGFloat percent =fmin(1, fmaxf(0, offset / 200.0));
            shouldComplete = percent > 0.5;
            [self updateInteractiveTransition:percent];
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
            self.interactiving = NO;
            if (shouldComplete) {
                [self finishInteractiveTransition];
            } else {
                [self cancelInteractiveTransition];
            }
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;//避免与SystemBasicVC中的侧滑手势冲突
}

@end
