//
//  UIViewController+SRSheetSlide.m
//
//  Created by 周家民 on 2019/4/3.
//  Copyright © 2019 STARRAIN. All rights reserved.
//

#import "UIViewController+SRSheetSlide.h"
#import <objc/runtime.h>
#import "SRSheetSlideViewControllerAnimationTransition.h"
#import "SRSheetSlideViewControllerInteractiveTransition.h"

static char * const kSheetPositionKey = "kSheetPositionKey";
static char * const kAnimationTransitionKey = "kAnimationTransitionKey";
static char * const kInteractiveTransitionKey = "kInteractiveTransitionKey";
static char * const kDisplayPercentKey = "kDisplayPercentKey";
static char * const kTranslucentValueKey = "kTranslucentValueKey";

@implementation UIViewController (SRSheetSlide)

- (instancetype)initAndBecomeSheetSlideOnViewController:(UIViewController *)viewController {
    if (self = [self init]) {
        [self becomeSheetSlideOnViewController:viewController];
    }
    return self;
}

- (instancetype)initAndBecomeSheetSlideOnViewController:(UIViewController *)viewController sheetPosition:(SRSheetSlideViewControllerSheetPosition)sheetPosition {
    if (self = [self initAndBecomeSheetSlideOnViewController:viewController]) {
        self.sheetPosition = sheetPosition;
    }
    return self;
}

-(void)becomeSheet {
    self.transitioningDelegate = self;
    self.interactiveTransition.toViewController = self;
}

- (void)becomSheetWithSheetPosition:(SRSheetSlideViewControllerSheetPosition)sheetPosition {
    self.sheetPosition = sheetPosition;
    [self becomeSheet];
}

- (void)becomeSheetSlideOnViewController:(UIViewController *)viewController {
    [self configureEdgeSlideGestureOnViewController:viewController];
    [self becomeSheet];
}

- (void)becomeSheetSlideOnViewController:(UIViewController *)viewController sheetPosition:(SRSheetSlideViewControllerSheetPosition)sheetPosition {
    self.sheetPosition = sheetPosition;
    [self becomeSheetSlideOnViewController:viewController];
}

- (void)configureEdgeSlideGestureOnViewController:(UIViewController *)viewController {
    [[self interactiveTransition] prepareEdgeSlideGestureWithViewController:viewController];
}

- (void)backToNormal {
    self.transitioningDelegate = nil;
}

#pragma mark - setter
- (void)setSheetPosition:(SRSheetSlideViewControllerSheetPosition)sheetPosition {
    objc_setAssociatedObject(self, kAnimationTransitionKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, kSheetPositionKey, @(sheetPosition), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self animationTransition].sheetPosition = sheetPosition;
    [self interactiveTransition].sheetPosition = sheetPosition;
}

- (void)setDisplayPercent:(CGFloat)displayPercent {
    displayPercent = fmaxf(fminf(1, displayPercent), 0);
    objc_setAssociatedObject(self, kDisplayPercentKey, @(displayPercent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTranslucentValue:(CGFloat)translucentValue {
    translucentValue = fmaxf(fminf(1, translucentValue), 0);
    objc_setAssociatedObject(self, kTranslucentValueKey, @(translucentValue), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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

- (SRSheetSlideViewControllerAnimationTransition *)animationTransition {
    SRSheetSlideViewControllerAnimationTransition *animationTransition = objc_getAssociatedObject(self, kAnimationTransitionKey);
    if (!animationTransition) {
        animationTransition = [[SRSheetSlideViewControllerAnimationTransition alloc] init];
        animationTransition.sheetPosition = self.sheetPosition;
        objc_setAssociatedObject(self, kAnimationTransitionKey, animationTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return animationTransition;
}

- (SRSheetSlideViewControllerInteractiveTransition *)interactiveTransition {
    SRSheetSlideViewControllerInteractiveTransition *interactiveTransition = objc_getAssociatedObject(self, kInteractiveTransitionKey);
    if (!interactiveTransition) {
        interactiveTransition = [[SRSheetSlideViewControllerInteractiveTransition alloc] init];
        interactiveTransition.sheetPosition = self.sheetPosition;
        objc_setAssociatedObject(self, kInteractiveTransitionKey, interactiveTransition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return interactiveTransition;
}

#pragma mark - custom
- (void)prepareGestureWithNeedSideSlideController:(UIViewController *)viewController {
//    [self.interactiveTransition prepareGestureWithNeedSideSlideController:viewController];
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    [self animationTransition].actionType = SRSheetSlideViewControllerActionTypePresent;
    return [self animationTransition];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    [self animationTransition].actionType = SRSheetSlideViewControllerActionTypeDismiss;
    return [self animationTransition];
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return [self interactiveTransition].interactiving ? [self interactiveTransition] : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return [self interactiveTransition].interactiving ? [self interactiveTransition] : nil;
}

@end
