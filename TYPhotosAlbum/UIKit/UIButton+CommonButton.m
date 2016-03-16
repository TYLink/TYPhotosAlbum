//
//  UIButton+CommonButton.m
//  iPhone Car Service Master
//
//  Created by Joe on 13-9-16.
//  Copyright (c) 2013年 Leo. All rights reserved.
//

#import "UIButton+CommonButton.h"

@implementation UIButton (CommonButton)

+(UIButton *)backButton
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 35, 35);
    [btn setContentMode:UIViewContentModeScaleToFill];
    [btn setClipsToBounds:YES];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setImage:[UIImage imageNamed:@"common_back"] forState:UIControlStateNormal];
    //    [btn setImage:[UIImage imageNamed:@"common_backX"] forState:UIControlStateHighlighted];
    return btn;
}


+ (UIButton*) selectedButton {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 80, 35);
    [btn setContentMode:UIViewContentModeScaleToFill];
    [btn setClipsToBounds:YES];
    [btn setTitle:@"附近" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setImage:[UIImage imageNamed:@"Detail_Down_Normal"] forState:UIControlStateNormal];
    
    //    在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets、titleEdgeInsets、imageEdgeInsets
    btn.imageEdgeInsets = UIEdgeInsetsMake(5,80-20,5,0);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    //    [btn setTitle:@"首页" forState:UIControlStateNormal];//设置button的title
    btn.titleLabel.font = [UIFont systemFontOfSize:15];//title字体大小
    btn.titleLabel.textAlignment = NSTextAlignmentLeft;//设置title的字体居中
    
    CGSize detailSize = [@"附近" sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 80-(80-detailSize.width));//设置title在button上的位置（上top，左left，下bottom，右right）
    return btn;
    
}

+ (UIButton *) nextButton {
    
    UIButton* nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"loginButtonImage"] forState:UIControlStateNormal];
    return nextButton;
}


@end
