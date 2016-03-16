//
//  UIViewController+NavigationBarItemFlexiable.h
//  iPhone Car Service Master
//
//  Created by Joe on 13-11-1.
//  Copyright (c) 2013年 mlyn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (NavigationBarItemFlexiable)

- (void)setLeftBarItemWithButton:(UIButton *)button;

- (void)setRightBarItemWithButton:(UIButton *)button;

- (void)setRightBarItemWithCustomView:(UIView *)view;

@end
