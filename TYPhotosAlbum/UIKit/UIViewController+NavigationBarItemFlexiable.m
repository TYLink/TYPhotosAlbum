//
//  UIViewController+NavigationBarItemFlexiable.m
//  iPhone Car Service Master
//
//  Created by Joe on 13-11-1.
//  Copyright (c) 2013年 mlyn. All rights reserved.
//

#import "UIViewController+NavigationBarItemFlexiable.h"

@implementation UIViewController (NavigationBarItemFlexiable)

- (void)setLeftBarItemWithButton:(id)button
{
    UIBarButtonItem* leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil
                                       action:nil];
    
    negativeSpacer.width = -5;// it was -6 in iOS 6
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftItem, nil] animated:NO];
}

- (void)setRightBarItemWithButton:(UIButton *)button
{
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil
                                       action:nil];
    
    negativeSpacer.width = -6;// it was -6 in iOS 6
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightItem, nil] animated:NO];

}

- (void)setRightBarItemWithCustomView:(UIView *)view
{
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil
                                       action:nil];
    
    negativeSpacer.width = -6;// it was -6 in iOS 6
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightItem, nil] animated:NO];
}



@end
