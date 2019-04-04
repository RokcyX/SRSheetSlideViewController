# 无代码侵入、基于手势的滑动控制器工具
## 效果
![image](https://github.com/RokcyX/SRSheetSlideViewController/blob/master/gif/1.gif)
![image](https://github.com/RokcyX/SRSheetSlideViewController/blob/master/gif/2.gif)
## 如何使用SRSheetSlide
使用CocoaPods安装：pod 'SRSheetSlide'
## 在需要将控制器变成卡片滑动控制器的地方引入头文件
```
#import "UIViewController+SRSheetSlide.h"
```
## 然后对需要变成卡片控制器的控制器对象调用
```
/**
 将当前控制器变成不支持手势的卡片控制器
 */
- (void)becomeSheet;
```
## 或者调用支持手势的方法即可
```
/**
 将当前控制器变成支持手势滑动的卡片控制器

 @param viewController 需要添加手势的控制器
 */
- (void)becomeSheetSlideOnViewController:(UIViewController *)viewController;
```
