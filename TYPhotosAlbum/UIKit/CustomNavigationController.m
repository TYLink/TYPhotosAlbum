//
//  CustomNavigationController.m
//  FunApplication
//
//  Created by fun on 15/3/30.
//  Copyright (c) 2015年 Fun. All rights reserved.
//

#import "CustomNavigationController.h"
#import "UIViewController+NavigationBarItemFlexiable.h"
#import "UIColor+Extension.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.       021363
    //  导航条文字颜色修改       title 颜色
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor getColor:@"555555"]};
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"common_nav7_bg"] forBarMetrics:UIBarMetricsDefault];
}

- (void)responseToBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
 {
     //如果现在push的不是栈顶控制器，那么久隐藏tabbar工具条
     if (self.viewControllers.count>0) {
             viewController.hidesBottomBarWhenPushed=YES;
         }
     [super pushViewController:viewController animated:YES];
}


@end
