//
//  UIViewController+SRSheetSlide.h
//  SRSheetSlideViewControllerDemo
//
//  Created by 周家民 on 2019/4/3.
//  Copyright © 2019 STARRAIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRSheetSlideDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (SRSheetSlide) <UIViewControllerTransitioningDelegate>

/**
 滑动类型
 */
@property (nonatomic,assign) SRSheetSlideViewControllerSheetPosition sheetPosition;

/**
 显示百分比，取值范围0~1，默认0.8，影响卡片控制器视图最终需要显示的宽度/高度为屏幕宽度/高度的百分之多少，sheetPosition的值为SRSheetSlideViewControllerSheetPositionRight/SRSheetSlideViewControllerSheetPositionLeft时影响宽度，SRSheetSlideViewControllerSheetPositionTop/SRSheetSlideViewControllerSheetPositionRightBottom影响高度
 */
@property (nonatomic,assign) CGFloat displayPercent;

/**
 半透明背景的透明程度，取值范围0~1，默认0.7
 */
@property (nonatomic,assign) CGFloat translucentValue;

/**
 是否启用卡片滑动
 */
@property (nonatomic,assign,getter=isSheetSlideEnable) BOOL sheetSlideEnable;

/**
 在传入的viewController上配置边缘滑动手势

 @param viewController 控制器
 */
- (void)configureEdgeSlideGestureOnViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
