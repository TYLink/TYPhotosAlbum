//
//  TYimageCropView.h
//  TYPhotoAlbum
//
//  Created by TianYang on 16/1/4.
//  Copyright © 2016年 Tianyang. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TYImageCropDelegate <NSObject>

- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage;

- (void)cancelML;

@end


@interface TYimageCropView : UIView
- (id) initWithFrame:(CGRect)frame;


-(void)AddTopView;

//下面俩哪个后面设置，即是哪个有效
@property(nonatomic,strong) UIImage *image;
@property(nonatomic,strong) UIViewController * SuperViewController;


@property(nonatomic,weak) id<TYImageCropDelegate> delegate;
@property(nonatomic,assign) CGFloat ratioOfWidthAndHeight; //截取比例，宽高比

- (void)showWithAnimation:(BOOL)animation;

-(void)onCancel;

-(void)onConfirm;


@end
