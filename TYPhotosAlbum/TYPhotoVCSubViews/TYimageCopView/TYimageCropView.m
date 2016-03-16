 //
 //  TYimageCropView.m
 //  TYPhotoAlbum
 //
 //  Created by TianYang on 16/1/4.
 //  Copyright © 2016年 Tianyang. All rights reserved.
 //
 
 #import "TYimageCropView.h"
 
 # define TYSCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width
 
 # define TYSCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
 
 #define kDefualRatioOfWidthAndHeight 1.0f
 
 @interface UIImage (MLImageCrop_Addition)
 
 //将根据所定frame来截取图片
 - (UIImage*)TYImageCrop_imageByCropForRect:(CGRect)targetRect;
 - (UIImage *)TYImageCrop_fixOrientation;
 @end
 
 @implementation UIImage (MLImageCrop_Addition)
 
 
 - (UIImage *)TYImageCrop_fixOrientation {
 
 if (self.imageOrientation == UIImageOrientationUp) return self;
 
 CGAffineTransform transform = CGAffineTransformIdentity;
 
 UIImageOrientation io = self.imageOrientation;
 if (io == UIImageOrientationDown || io == UIImageOrientationDownMirrored) {
 transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
 transform = CGAffineTransformRotate(transform, M_PI);
 }else if (io == UIImageOrientationLeft || io == UIImageOrientationLeftMirrored) {
 transform = CGAffineTransformTranslate(transform, self.size.width, 0);
 transform = CGAffineTransformRotate(transform, M_PI_2);
 }else if (io == UIImageOrientationRight || io == UIImageOrientationRightMirrored) {
 transform = CGAffineTransformTranslate(transform, 0, self.size.height);
 transform = CGAffineTransformRotate(transform, -M_PI_2);
 }
 
 if (io == UIImageOrientationUpMirrored || io == UIImageOrientationDownMirrored) {
 transform = CGAffineTransformTranslate(transform, self.size.width, 0);
 transform = CGAffineTransformScale(transform, -1, 1);
 }else if (io == UIImageOrientationLeftMirrored || io == UIImageOrientationRightMirrored) {
 transform = CGAffineTransformTranslate(transform, self.size.height, 0);
 transform = CGAffineTransformScale(transform, -1, 1);
 }
 
 CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
 CGImageGetBitsPerComponent(self.CGImage), 0,
 CGImageGetColorSpace(self.CGImage),
 CGImageGetBitmapInfo(self.CGImage));
 CGContextConcatCTM(ctx, transform);
 
 if (io == UIImageOrientationLeft || io == UIImageOrientationLeftMirrored || io == UIImageOrientationRight || io == UIImageOrientationRightMirrored) {
 CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
 }else{
 CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
 }
 
 CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
 UIImage *img = [UIImage imageWithCGImage:cgimg];
 CGContextRelease(ctx);
 CGImageRelease(cgimg);
 return img;
 }
 
 - (UIImage*)TYImageCrop_imageByCropForRect:(CGRect)targetRect
 {
 targetRect.origin.x*=self.scale;
 targetRect.origin.y*=self.scale;
 targetRect.size.width*=self.scale;
 targetRect.size.height*=self.scale;
 
 if (targetRect.origin.x<0) {
 targetRect.origin.x = 0;
 }
 if (targetRect.origin.y<0) {
 targetRect.origin.y = 0;
 }
 
 //宽度高度过界就删去
 CGFloat cgWidth = CGImageGetWidth(self.CGImage);
 CGFloat cgHeight = CGImageGetHeight(self.CGImage);
 if (CGRectGetMaxX(targetRect)>cgWidth) {
 targetRect.size.width = cgWidth-targetRect.origin.x;
 }
 if (CGRectGetMaxY(targetRect)>cgHeight) {
 targetRect.size.height = cgHeight-targetRect.origin.y;
 }
 CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, targetRect);
 UIImage *resultImage=[UIImage imageWithCGImage:imageRef];
 CGImageRelease(imageRef);
 //修正回原scale和方向
 resultImage = [UIImage imageWithCGImage:resultImage.CGImage scale:self.scale orientation:self.imageOrientation];
 return resultImage;
 }
 
 @end
 
 @interface TYimageCropView ()<UIScrollViewDelegate>
 
 @property(nonatomic,strong) UIScrollView *scrollView;
 @property(nonatomic,strong) UIView *overlayView; //中心截取区域的View
 
 @property(nonatomic, strong) UIImageView  * imageView;
 @property(nonatomic, strong) UIWindow     * actionWindow;

 
 @end
 
 @implementation TYimageCropView
 
 - (id) initWithFrame:(CGRect)frame{
 
     if ( [super initWithFrame:frame]) {
     self.ratioOfWidthAndHeight = kDefualRatioOfWidthAndHeight;
     
     // Do any additional setup after loading the view.
     self.backgroundColor = [UIColor whiteColor];
     //设置frame,这里需要设置下，这样其会在最下层
     
     self.scrollView = [self ScrollView];
     self.overlayView.layer.borderColor = [UIColor clearColor].CGColor;
     }
     return self;
 }
 
 #pragma mark - show
 - (void)showWithAnimation:(BOOL)animation
 {
     UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
     window.opaque = YES;
     window.windowLevel = UIWindowLevelStatusBar+1.0f;
     window.rootViewController = _SuperViewController;
     [window makeKeyAndVisible];
     self.actionWindow = window;
     if (animation) {
     self.actionWindow.layer.opacity = .01f;
     [UIView animateWithDuration:0.35f animations:^{
     self.actionWindow.layer.opacity = 1.0f;
     }];
     }
 }
 
 #pragma mark - event
 - (void)disappear
 {
     //退出
     [UIView animateWithDuration:0.35f animations:^{
     self.actionWindow.layer.opacity = 0.01f;
     } completion:^(BOOL finished) {
     [self.actionWindow removeFromSuperview];
     [self.actionWindow resignKeyWindow];
     self.actionWindow = nil;
     }];
 }
 
 - (void)onCancel
 {
     [self disappear];
     if (self.delegate && [self.delegate respondsToSelector:@selector(cancelML)]){
     [self.delegate cancelML];
     }
 }
 
 - (void)onConfirm
 {
         if (!self.imageView.image) {
         return;
     }
     //不稳定下来，不让动
     if (self.scrollView.tracking||self.scrollView.dragging||self.scrollView.decelerating||self.scrollView.zoomBouncing||self.scrollView.zooming){
     return;
     }
     //根据区域来截图
     CGPoint startPoint = [self.overlayView convertPoint:CGPointZero toView:self.imageView];
     CGPoint endPoint = [self.overlayView convertPoint:CGPointMake(CGRectGetMaxX(self.overlayView.bounds), CGRectGetMaxY(self.overlayView.bounds)) toView:self.imageView];
     
     //这里获取的是实际宽度和zoomScale为1的frame宽度的比例
     CGFloat wRatio = self.imageView.image.size.width/(self.imageView.frame.size.width/self.scrollView.zoomScale);
     CGFloat hRatio = self.imageView.image.size.height/(self.imageView.frame.size.height/self.scrollView.zoomScale);
     CGRect cropRect = CGRectMake(startPoint.x*wRatio, startPoint.y*hRatio, (endPoint.x-startPoint.x)*wRatio, (endPoint.y-startPoint.y)*hRatio);
     [self disappear];
     
     UIImage *cropImage = [self.imageView.image TYImageCrop_imageByCropForRect:cropRect];
     if (self.delegate && [self.delegate respondsToSelector:@selector(cropImage:forOriginalImage:)]){
     [self.delegate cropImage:cropImage forOriginalImage:self.image];
     }
 }
 
 #pragma mark - getter or setter
 
 - (void)setImage:(UIImage *)image
 {
     if ([image isEqual:_image]) {
            return;
     }
     _image = image;
     self.imageView.image = [image TYImageCrop_fixOrientation];
     //imageView的frame和scrollView的内容
     [self adjustImageViewFrameAndScrollViewContent];
     self.scrollView.scrollEnabled = YES;
 }

 - (void)setRatioOfWidthAndHeight:(CGFloat)ratioOfWidthAndHeight
 {
     if (ratioOfWidthAndHeight<=0) {
     ratioOfWidthAndHeight = kDefualRatioOfWidthAndHeight;
     }
     if (ratioOfWidthAndHeight==_ratioOfWidthAndHeight) {
         return;
     }
     _ratioOfWidthAndHeight = ratioOfWidthAndHeight;
 }
 
 - (UIView*)overlayView
 {
     if (!_overlayView) {
         _overlayView = [[UIView alloc]init];
         _overlayView.frame = CGRectMake(0, 0, TYSCREEN_WIDTH, TYSCREEN_WIDTH);
         _overlayView.backgroundColor = [UIColor clearColor];
         _overlayView.layer.borderColor = [UIColor clearColor].CGColor;
         _overlayView.layer.borderWidth = 1.0f;
         _overlayView.userInteractionEnabled = NO;
         [self addSubview:_overlayView];
     }
     return _overlayView;
 }
 
 - (UIScrollView*)ScrollView
 {
     if (!_scrollView) {
         _scrollView = [[UIScrollView alloc]init];
         _scrollView.frame = CGRectMake(0, 0, TYSCREEN_WIDTH, TYSCREEN_WIDTH);
//         _scrollView.backgroundColor = [UIColor getColor:@"f1f1f1"];
         _scrollView.showsHorizontalScrollIndicator = NO;
         _scrollView.showsVerticalScrollIndicator = NO;
         _scrollView.exclusiveTouch = YES; //防止被触摸的时候还去触摸其他按钮，当然其防不住减速时候的弹跳黑框等特殊的，在onConfirm里面处理了
         _scrollView.delegate = self;
         [self addSubview:_scrollView];
     }
     return _scrollView;
 }
 

 - (UIImageView*)imageView
 {
     if (!_imageView) {
         _imageView = [[UIImageView alloc] init];
         _imageView.contentMode = UIViewContentModeScaleAspectFit;
         [self.scrollView addSubview:_imageView];
     }
     return _imageView;
 }
 
 #pragma mark - other
 //判断是否是以宽度为基准来截取
 - (BOOL)isBaseOnWidthOfOverlayView
 {
 //这里最好不要用＝＝判断，因为是CGFloat类型
     if (self.overlayView.frame.size.width < self.bounds.size.width) {
         return NO;
     }
     return YES;
 }
 
 #pragma mark - adjust image frame and scrollView's  content
 - (void)adjustImageViewFrameAndScrollViewContent
 {
     CGRect frame = self.scrollView.frame;
     if (self.imageView.image) {
         CGSize imageSize = self.imageView.image.size;
         CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
     if (imageFrame.size.width<=imageFrame.size.height) {
     //说白了就是竖屏时候
         CGFloat ratio = frame.size.width/imageFrame.size.width;
         imageFrame.size.height = imageFrame.size.height*ratio;
         imageFrame.size.width = frame.size.width;
     }else{
         CGFloat ratio = frame.size.height/imageFrame.size.height;
         imageFrame.size.width = imageFrame.size.width*ratio;
         imageFrame.size.height = frame.size.height;
     }
     
     self.scrollView.contentSize =  frame.size;
     BOOL isBaseOnWidth = [self isBaseOnWidthOfOverlayView];
     if (isBaseOnWidth) {
       self.scrollView.contentInset = UIEdgeInsetsMake(CGRectGetMinY(self.overlayView.frame), 0, CGRectGetHeight(self.bounds)-CGRectGetMaxY(self.overlayView.frame), 0);
     }else{
       self.scrollView.contentInset = UIEdgeInsetsMake(0, CGRectGetMinX(self.overlayView.frame), 0, CGRectGetWidth(self.bounds)-CGRectGetMaxX(self.overlayView.frame));
     }
     
     self.imageView.frame = imageFrame;
     //初始化,让其不会有黑框出现
     CGFloat minScale = self.overlayView.frame.size.height/imageFrame.size.height;
     CGFloat minScale2 = self.overlayView.frame.size.width/imageFrame.size.width;
     minScale = minScale>minScale2?minScale:minScale2;
     
     self.scrollView.minimumZoomScale = minScale;
     self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale*3<2.0f?2.0f:self.scrollView.minimumZoomScale*3;
     self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
     
     //调整下让其居中
     if (isBaseOnWidth) {
         CGFloat offsetY = (self.scrollView.bounds.size.height > (self.scrollView.contentSize.height))?
         44  : 0.0;
         //            (self.scrollView.bounds.size.height - self.scrollView.contentSize.height) * 0.5
         self.scrollView.contentOffset = CGPointMake(0, -offsetY);
     }else{
         CGFloat offsetX = (self.scrollView.bounds.size.width > self.scrollView.contentSize.width)?
         (self.scrollView.bounds.size.width - self.scrollView.contentSize.width) * 0.5 : 0.0;
         self.scrollView.contentOffset = CGPointMake(-offsetX,0);
       }
     }else{
         frame.origin = CGPointZero;
         self.imageView.frame = frame;
         //重置内容大小
         self.scrollView.contentSize = CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height);
         self.scrollView.minimumZoomScale = 1.0f;
         self.scrollView.maximumZoomScale = self.scrollView.minimumZoomScale; //取消缩放功能
         self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
     }
 }
 #pragma mark - UIScrollViewDelegate
 - (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
 {
     return self.imageView;
 }
 
 @end

 
