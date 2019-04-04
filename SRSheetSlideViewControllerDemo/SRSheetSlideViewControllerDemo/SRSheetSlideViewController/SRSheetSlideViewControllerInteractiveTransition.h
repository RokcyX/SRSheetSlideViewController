//
//  SRSheetSlideViewControllerInteractiveTransition.h
//
//  Created by 周家民 on 2019/4/3.
//  Copyright © 2019 STARRAIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRSheetSlideDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface SRSheetSlideViewControllerInteractiveTransition : UIPercentDrivenInteractiveTransition

/**
 标识是否处于交互动画中
 */
@property (nonatomic,assign) BOOL interactiving;

/**
 到哪个控制器去
 */
@property (nonatomic,weak) UIViewController *toViewController;

/**
 准备边缘滑动手势

 @param viewController 控制器
 */
- (void)prepareEdgeSlideGestureWithViewController:(UIViewController *)viewController;

/**
 卡片位置
 */
@property (nonatomic,assign) SRSheetSlideViewControllerSheetPosition sheetPosition;

@end

NS_ASSUME_NONNULL_END
