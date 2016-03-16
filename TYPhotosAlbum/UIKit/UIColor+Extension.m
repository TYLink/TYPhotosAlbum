//
//  UIColor+Extension.m
//  test
//
//  Created by XiangqiTu on 14-9-10.
//
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

+ (UIColor *)getColor:(NSString *)hexColor
{
    return [UIColor getColor:hexColor withAlpha:1.0];
}

+ (UIColor *)getColor:(NSString *)hexColor withAlpha:(CGFloat)alpha
{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location =2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location =4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:alpha];
}

#pragma mark - Chat

+ (UIColor *)chatVCBackgroundColor
{
    return [UIColor getColor:@"dedde1"];
}

+ (UIColor *)chatInputViewBackgroundColor
{
    return [UIColor getColor:@"ffffff"];
}

+ (UIColor *)chatTimeStampLabelColor
{
    return [UIColor getColor:@"adadad"];
}

+ (UIColor *)chatComingTextColor
{
    return [UIColor getColor:@"000000"];
}

+ (UIColor *)chatOutingTextColor
{
    return [UIColor getColor:@"ffffff"];
}

#pragma mark - FansFollows
+ (UIColor *)fansVCBackgroundColor
{
    return [UIColor getColor:@"eeeeee"];
}

#pragma mark - Setting
+ (UIColor *)settingVCBackgroundColor
{
    return [UIColor getColor:@"e7e9ef"];
}

+ (UIColor *)settingLineColor
{
    return [UIColor getColor:@"cccccc"];
}
@end
