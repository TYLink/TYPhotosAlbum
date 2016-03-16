//
//  ViewController.m
//  TYPhotosAlbum
//
//  Created by TianYang on 16/3/16.
//  Copyright © 2016年 Tianyang. All rights reserved.
//

#import "ViewController.h"
#import "TYPhotosAlbumView.h"
#import "TYimageCropView.h"
#import "UIViewController+NavigationBarItemFlexiable.h"
#import "SettingLabel.h"
#import "UIColor+Extension.h"
#import "Masonry.h"
#import "showPhotoVC.h"


#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

# define IOS8      [[[UIDevice currentDevice] systemVersion] floatValue] > 8.0
#define DefaultSquareImageName    @"DefaultSquareImageName"
@import Photos;

@interface ViewController ()<TYImageCropDelegate>
{
    TYimageCropView * TYImageView ;
    TYPhotosAlbumView * TYPhotosView;
    UIScrollView * BgScrollView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self AddImageView];
    [self AddNavBarItemBtn];
    if (IOS8) {
        [self GetAlbumResult];
    }else{
        [self GetAlbumPhotos];
    }
    self.navigationItem.title = @"相册";

}

-(void) AddNavBarItemBtn{
    
    UIButton *LeftBtn =({
        LeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [LeftBtn setTitle:@"取消" forState:UIControlStateNormal];
        [SettingLabel SetBtnText:LeftBtn andTextSize:17.0 andColor:[UIColor getColor:@"555555"] and:YES];
        [LeftBtn addTarget:self action:@selector(CancleClick) forControlEvents:UIControlEventTouchUpInside];
        LeftBtn;
    });
    UIButton *RightBtn =({
        RightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
        [RightBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [SettingLabel SetBtnText:RightBtn andTextSize:17.0 andColor:[UIColor getColor:@"ff7a64"] and:YES];
        [RightBtn addTarget:self action:@selector(NextClick) forControlEvents:UIControlEventTouchUpInside];
        RightBtn;
    });
    [self setLeftBarItemWithButton:LeftBtn];
    [self setRightBarItemWithButton:RightBtn];
}


-(void) AddImageView{
    self.view.backgroundColor = [UIColor whiteColor];
    BgScrollView = ({
        BgScrollView = [[UIScrollView alloc] init];
        [self.view addSubview:BgScrollView];
        BgScrollView.showsHorizontalScrollIndicator=NO;
        BgScrollView.showsVerticalScrollIndicator = NO;
        BgScrollView.bounces=NO;
        BgScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT+SCREEN_WIDTH);
        BgScrollView.backgroundColor = [UIColor clearColor];
        [BgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left    .  equalTo (self.view.mas_left);
            make.top     .  equalTo (self.view.mas_top);
            make.width   .  equalTo (@(SCREEN_WIDTH));
            make.height  .  equalTo (@(SCREEN_HEIGHT));
        }];
        BgScrollView;
    });
    
    TYImageView = [[TYimageCropView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    TYImageView.image = [UIImage imageNamed:DefaultSquareImageName];
    TYImageView.delegate = self;
    TYImageView.SuperViewController = self;
    TYImageView.ratioOfWidthAndHeight = 800.0f/600.0f;
    TYImageView.contentMode = UIViewContentModeScaleAspectFill;
    TYImageView.clipsToBounds = YES;
    
    [BgScrollView addSubview:TYImageView];
    TYPhotosView = [[TYPhotosAlbumView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH+2, SCREEN_WIDTH, SCREEN_HEIGHT-42)];
    TYPhotosView.CameraType = _CameraType;
    
    TYPhotosView.object = self;
    TYPhotosView.TableScrollSelector = @selector(DetailViewScrollClick);
    [TYPhotosView returnAlbumImage:^(UIImage *AlbumImage) {
        [TYImageView setImage:AlbumImage];
        CATransition *transition = [CATransition animation];
        transition.duration = 0.35;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = @"fade";
        //        transition.delegate = self;
        [TYImageView.layer addAnimation:transition forKey:nil];
        [UIView animateWithDuration:0.35 animations:^{
            BgScrollView.contentOffset=CGPointMake(0, 0);
        } completion:^(BOOL finished) {
        }];
    }];
    

    [BgScrollView addSubview:TYPhotosView];
}
-(void)GetAlbumPhotos
{
    NSMutableArray *data = [NSMutableArray array];
    self.library = [[ALAssetsLibrary alloc] init];
    [self.library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group != nil) {
            [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                if (result != nil) {
                    [data addObject:result];
                    self.AlassetArray = data;
                }
            }];
        }
        [TYPhotosView setAlassetArray:_AlassetArray];
        ALAsset * Asset = [[ALAsset alloc] init];
        Asset = [_AlassetArray objectAtIndex:0];
        ALAssetRepresentation *rep = [Asset defaultRepresentation];
        UIImage *img = [UIImage
                        imageWithCGImage:[rep fullScreenImage]
                        scale:[rep scale]
                        orientation:UIImageOrientationUp];
        TYImageView.image = img;
        
    } failureBlock:^(NSError *error) {
        
    }];
}

-(void)GetAlbumResult{
    PHCachingImageManager  *imageManager = [[PHCachingImageManager alloc] init];
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    if ([[PHAsset fetchAssetsWithOptions:options] count] == 0) {
        return;
    } else{
        [TYPhotosView setPHFetchResult:[PHAsset fetchAssetsWithOptions:options]];
        PHAsset *asset = [PHAsset fetchAssetsWithOptions:options][0];
        [imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            TYImageView.image = result;
        }];
    }
}
//  隐藏状态栏
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    //    self.navigationController.navigationBarHidden = YES;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - crop delegate
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{

    showPhotoVC * ReleaseImageVC = [[showPhotoVC alloc] init];
    ReleaseImageVC.headerImage = cropImage;
    [self.navigationController pushViewController:ReleaseImageVC animated:YES];

}

-(void)cancelML{
    //    取消
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


-(void)CancleClick{
    [TYImageView onCancel];
}
-(void) NextClick{
    [TYImageView onConfirm];
}

-(void) DetailViewScrollClick{
    
    [UIView animateWithDuration:0.35 animations:^{
        BgScrollView.contentOffset=CGPointMake(0, SCREEN_WIDTH+5);
    } completion:^(BOOL finished) {
        
    }];
    
}



@end
