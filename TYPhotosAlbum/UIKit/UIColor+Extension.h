//
//  UIColor+Extension.h
//  test
//
//  Created by XiangqiTu on 14-9-10.
//
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"

@interface UIColor (Extension)

#pragma mark - Get Color
+ (UIColor *)getColor:(NSString *)hexColor;

+ (UIColor *)getColor:(NSString *)hexColor withAlpha:(CGFloat)alpha;

#pragma mark - Common Color


#pragma mark - Chat
+ (UIColor *)chatVCBackgroundColor;

+ (UIColor *)chatInputViewBackgroundColor;

+ (UIColor *)chatTimeStampLabelColor;

+ (UIColor *)chatComingTextColor;

+ (UIColor *)chatOutingTextColor;

#pragma mark - FansFollows
+ (UIColor *)fansVCBackgroundColor;

#pragma mark - Setting
+ (UIColor *)settingVCBackgroundColor;

+ (UIColor *)settingLineColor;

@end
