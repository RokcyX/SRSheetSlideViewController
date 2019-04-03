//
//  UIViewController+SRSheetSlide.m
//
//  Created by 周家民 on 2019/4/3.
//  Copyright © 2019 STARRAIN. All rights reserved.
//

#import "UIViewController+SRSheetSlide.h"
#import <objc/runtime.h>
#import "SRSheetSlideViewControllerAnimationTransition.h"

static char * const kSheetPositionKey = "kSheetPositionKey";
static char * const kAnimationTransitionKey = "kAnimationTransitionKey";
static char * const kInteractiveTransitionKey = "kInteractiveTransitionKey";
static char * const kDisplayPercentKey = "kDisplayPercentKey";
static char * const kTranslucentValueKey = "kTranslucentValueKey";
static char * const kSheetSlideEnableKey = "kSheetSlideEnableKey";

@implementation UIViewController (SRSheetSlide)

#pragma mark - setter
- (void)setSheetPosition:(SRSheetSlideViewControllerSheetPosition)sheetPosition {
    objc_setAssociatedObject(self, kAnimationTransitionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kSheetPositionKey, @(sheetPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDisplayPercent:(CGFloat)displayPercent {
    displayPercent = fmaxf(fminf(1, displayPercent), 0);
    objc_setAssociatedObject(self, kDisplayPercentKey, @(displayPercent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTranslucentValue:(CGFloat)translucentValue {
    translucentValue = fmaxf(fminf(1, translucentValue), 0);
    objc_setAssociatedObject(self, kTranslucentValueKey, @(translucentValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSheetSlideEnable:(BOOL)sheetSlideEnable {
    self.transitioningDelegate = sheetSlideEnable ? self : nil;
    objc_setAssociatedObject(self, kSheetSlideEnableKey, @(sheetSlideEnable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter
- (SRSheetSlideViewControllerSheetPosition)sheetPosition {
    return [objc_getAssociatedObject(self, kSheetPositionKey) integerValue];
}

- (CGFloat)displayPercent {
    CGFloat displayPercent = [objc_getAssociatedObject(self, kDisplayPercentKey) floatValue];
    if (displayPercent == 0) {
        displayPercent = 0.8;
    }
    return displayPercent;
}

- (CGFloat)translucentValue {
    CGFloat translucentValue = [objc_getAssociatedObject(self, kTranslucentValueKey) floatValue];
    if (translucentValue == 0) {
        translucentValue = 0.7;
    }
    return translucentValue;
}

- (BOOL)isSheetSlideEnable {
    return [objc_getAssociatedObject(self, kSheetSlideEnableKey) boolValue];
}

- (SRSheetSlideViewControllerAnimationTransition *)animationTransition {
    SRSheetSlideViewControllerAnimationTransition *animationTransition = objc_getAssociatedObject(self, kAnimationTransitionKey);
    if (!animationTransition) {
        animationTransition = [[SRSheetSlideViewControllerAnimationTransition alloc] init];
        animationTransition.sheetPosition = self.sheetPosition;
        objc_setAssociatedObject(self, kAnimationTransitionKey, animationTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return animationTransition;
}

//- (UIPercentDrivenInteractiveTransition *)interactiveTransition {
//    UIPercentDrivenInteractiveTransition *interactiveTransition = objc_getAssociatedObject(self, kInteractiveTransitionKey);
//    if (!interactiveTransition) {
//        interactiveTransition = [self interactiveTransitionWithSheetPosition:self.sheetPosition];
//        objc_setAssociatedObject(self, kInteractiveTransitionKey, interactiveTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    }
//    return interactiveTransition;
//}

#pragma mark - custom


//- (void)prepareGestureWithNeedSideSlideController:(UIViewController *)viewController {
//    [self.interactiveTransition prepareGestureWithNeedSideSlideController:viewController];
//}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    [self animationTransition].actionType = SRSheetSlideViewControllerActionTypePresent;
    return [self animationTransition];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    [self animationTransition].actionType = SRSheetSlideViewControllerActionTypeDismiss;
    return [self animationTransition];
}

//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
//    return self.interactiveTransition.interactiving ? self.interactiveTransition : nil;
//}
//
//- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
//    return self.interactiveTransition.interactiving ? self.interactiveTransition : nil;
//}

@end
