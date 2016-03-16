//
//  TYPhotoAlbum_CameraCell.m
//  TYPhotoAlbum
//
//  Created by TianYang on 15/12/14.
//  Copyright © 2015年 Tianyang. All rights reserved.
//

#import "TYPhotoAlbum_CameraCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UIColor+Extension.h"

# define TYSCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width

# define TYSCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height
@interface TYPhotoAlbum_CameraCell()

@property (nonatomic,strong)AVCaptureSession              *captureSession;
@property (nonatomic,strong)AVCaptureVideoPreviewLayer    *prevLayer;

@end

@implementation TYPhotoAlbum_CameraCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput
                                                  deviceInputWithDevice:[AVCaptureDevice
                                                                         defaultDeviceWithMediaType:AVMediaTypeVideo]  error:nil];
            self.captureSession = [[AVCaptureSession alloc] init];
            [self.captureSession addInput:captureInput];
            [self.captureSession startRunning];
            self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];
            self.prevLayer.frame = self.bounds;
            self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            [self.layer addSublayer: self.prevLayer];
        }else
        {
            self.backgroundColor = [UIColor getColor:@"f4563c"];
        }
    }
    return self;
}



@end
