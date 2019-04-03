//
//  SRSheetSlideDefine.h
//
//  Created by 周家民 on 2019/4/3.
//  Copyright © 2019 STARRAIN. All rights reserved.
//

#ifndef SRSheetSlideDefine_h
#define SRSheetSlideDefine_h

#define SRDeviceSize [[UIScreen mainScreen] bounds].size

//懒加载属性宏
#define SRLazyProperty(returnClass,propertyName,defaultValue) -(returnClass)propertyName{\
if(!_##propertyName){\
_##propertyName=defaultValue;\
}\
return _##propertyName;\
}

/**
 控制器活动类型

 - SRSheetSlideViewControllerActionTypePresent: 呈现
 - SRSheetSlideViewControllerActionTypeDismiss: 解散
 */
typedef NS_ENUM(NSInteger, SRSheetSlideViewControllerActionType) {
    SRSheetSlideViewControllerActionTypePresent = 0,
    SRSheetSlideViewControllerActionTypeDismiss
};

/**
 卡片位置
 
 - SRSheetSlideViewControllerSheetPositionRight: 屏幕右边
 - SRSheetSlideViewControllerSheetPositionLeft: 屏幕左边
 - SRSheetSlideViewControllerSheetPositionTop: 屏幕顶部
 - SRSheetSlideViewControllerSheetPositionBottom: 屏幕底部
 */
typedef NS_ENUM(NSInteger, SRSheetSlideViewControllerSheetPosition) {
    SRSheetSlideViewControllerSheetPositionRight = 0,
    SRSheetSlideViewControllerSheetPositionLeft,
    SRSheetSlideViewControllerSheetPositionTop,
    SRSheetSlideViewControllerSheetPositionBottom
};

#endif /* SRSheetSlideDefine_h */
