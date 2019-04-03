//
//  UIView+SRSheetSlide.m
//
//  Created by 周家民 on 2019/4/3.
//  Copyright © 2019 STARRAIN. All rights reserved.
//

#import "UIView+SRSheetSlide.h"
#import <objc/runtime.h>

@implementation UIView (SRSheetSlide)

- (CGFloat)sr_x {
    return self.frame.origin.x;
}

- (void)setSr_x:(CGFloat)sr_x {
    self.frame = CGRectMake(sr_x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)sr_y {
    return self.frame.origin.y;
}

- (void)setSr_y:(CGFloat)sr_y {
    if (!isnan(sr_y)) {
        self.frame = CGRectMake(self.frame.origin.x, sr_y, self.frame.size.width, self.frame.size.height);
    }
}

- (CGFloat)sr_width {
    return self.frame.size.width;
}

- (void)setSr_width:(CGFloat)sr_width {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sr_width, self.frame.size.height);
}

- (CGFloat)sr_height {
    return self.frame.size.height;
}

- (void)setSr_height:(CGFloat)sr_height {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, sr_height);
}

- (CGSize)sr_size {
    return self.frame.size;
}

- (void)setSr_size:(CGSize)sr_size {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, sr_size.width, sr_size.height);
}

- (void)setSr_viewClickBlock:(ViewClickBlock)sr_viewClickBlock {
    if (sr_viewClickBlock) {
        objc_setAssociatedObject(self, @"SRClickBlockAssociatedKey", sr_viewClickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sr_viewOnClick)];
        [self addGestureRecognizer:tapGesture];
    }
}

- (ViewClickBlock)sr_viewClickBlock {
    return objc_getAssociatedObject(self, @"SRClickBlockAssociatedKey");
}

- (void)sr_viewOnClick {
    ViewClickBlock viewClickBlock=self.sr_viewClickBlock;
    if (viewClickBlock) {
        viewClickBlock();
    }
}

@end
