//
//  showPhotoVC.m
//  TYPhotosAlbum
//
//  Created by TianYang on 16/3/16.
//  Copyright © 2016年 Tianyang. All rights reserved.
//

#import "showPhotoVC.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface showPhotoVC ()

@end

@implementation showPhotoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * ImageView = [[UIImageView alloc] init];
    ImageView.frame = CGRectMake(0, 100, SCREEN_WIDTH, SCREEN_WIDTH);
    [self.view addSubview:ImageView];
    ImageView.image = _headerImage;
//
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  隐藏状态栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    self.navigationController.navigationBarHidden = NO;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
