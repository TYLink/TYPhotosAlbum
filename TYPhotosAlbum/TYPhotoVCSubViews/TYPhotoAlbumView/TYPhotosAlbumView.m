
//
//  TYPhotosAlbumView.m
//  TYPhotoAlbum
//
//  Created by TianYang on 15/12/15.
//  Copyright © 2015年 Tianyang. All rights reserved.
//

#import "TYPhotosAlbumView.h"
#import "TYPhotoAlbum_CameraCell.h"
#import "TYPhotoAlbum_PicCell.h"


#define lineSpacing  6.0

# define TYSCREEN_WIDTH   [[UIScreen mainScreen] bounds].size.width

# define TYSCREEN_HEIGHT  [[UIScreen mainScreen] bounds].size.height

# define IOS8      [[[UIDevice currentDevice] systemVersion] floatValue] > 8.0

#define idenfierCamera @"TYPhotoAlbum_CameraCell"
#define idenfierCommon @"TYPhotoAlbum_PicCell"

@interface TYPhotosAlbumView () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionViewFlowLayout       * TYPhotosAlbumLayout;
    
    float lastContentOffset;
    
}
@property (strong) PHCachingImageManager         *imageManager;
@property (strong, nonatomic) ALAssetsLibrary    *library;

@end

@implementation TYPhotosAlbumView

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        [self CollectionViewLayout];
//        NSInteger selectedIndex = 1;
//        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
                if (IOS8) {
                    [self addSubview:self.TYPhotoKitView];
                    self.imageManager = [[PHCachingImageManager alloc] init];
//                   [self.TYPhotoKitView selectItemAtIndexPath:selectedIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                } else{
                  [self addSubview:self.TYAssetsLibraryView];
                  self.library = [[ALAssetsLibrary alloc] init];
                }
    }
    return self;
}

- (void)returnAlbumImage:(TYPhotosAlbumBlock)block {
    self.returnAlbumImageBlock = block;
}

-(void) returnCameraImage:(TYCameraImageBlock)block{

    self.returnCameraImageBlock = block;
}

-(void)CollectionViewLayout{
    TYPhotosAlbumLayout = [[UICollectionViewFlowLayout alloc]init];
    TYPhotosAlbumLayout.minimumLineSpacing = lineSpacing;
    CGFloat width = TYSCREEN_WIDTH - lineSpacing;
    CGFloat widthHW = width / 4.0;
    TYPhotosAlbumLayout.itemSize = CGSizeMake(widthHW , widthHW);
}

-(TYPhotoAlbumAssetsLibraryView *) TYAssetsLibraryView{
    if (_TYAssetsLibraryView == nil) {
        _TYAssetsLibraryView = [[TYPhotoAlbumAssetsLibraryView alloc] initWithFrame:self.bounds collectionViewLayout:TYPhotosAlbumLayout];
        _TYAssetsLibraryView.delegate = self;
        [_TYAssetsLibraryView registerClass:[TYPhotoAlbum_CameraCell class] forCellWithReuseIdentifier:idenfierCamera];
        [_TYAssetsLibraryView registerClass:[TYPhotoAlbum_PicCell class] forCellWithReuseIdentifier:idenfierCommon];
    }
    return _TYAssetsLibraryView;
}

-(TYPhotoAlbumPhotoKitView *)TYPhotoKitView{
    if (_TYPhotoKitView == nil) {
        _TYPhotoKitView = [[TYPhotoAlbumPhotoKitView alloc] initWithFrame:self.bounds collectionViewLayout:TYPhotosAlbumLayout];
        _TYPhotoKitView.delegate = self;
        [_TYPhotoKitView registerClass:[TYPhotoAlbum_CameraCell class] forCellWithReuseIdentifier:idenfierCamera];
        [_TYPhotoKitView registerClass:[TYPhotoAlbum_PicCell class] forCellWithReuseIdentifier:idenfierCommon];
    }
    return _TYPhotoKitView;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
//        跳转到拍照界面
        SCNavigationController *nav = [[SCNavigationController alloc] init];
        nav.scNaigationDelegate = self;
        [nav showCameraWithParentController:[self viewController]];
    } else{
        if (self.returnAlbumImageBlock != nil) {
                        if (IOS8) {
                            PHAsset *asset = self.assetsFetchResults[indexPath.row - 1];
                            [self.imageManager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                self.returnAlbumImageBlock(result);
                            }];
                        } else{
                            ALAsset * Asset = [[ALAsset alloc] init];
                            Asset = [_AlassetArray objectAtIndex:(indexPath.row - 1)];
                            ALAssetRepresentation *rep = [Asset defaultRepresentation];
                            UIImage *img = [UIImage
                                            imageWithCGImage:[rep fullScreenImage]
                                            scale:[rep scale]
                                            orientation:UIImageOrientationUp];
                            self.returnAlbumImageBlock(img);
                        }
        }
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark - SCNavigationController delegate
// 拍照完成之后的动作
- (void)didTakePicture:(SCNavigationController *)navigationController image:(UIImage *)image {
    if ([_CameraType isEqualToString:@"HeaderImage"]) {
        if (self.returnCameraImageBlock != nil) {
            self.returnCameraImageBlock(image);
        }
        [navigationController dismissViewControllerAnimated:YES completion:^{
            [[self  viewController] dismissViewControllerAnimated:YES completion:nil];
        }];
    }else if ([_CameraType isEqualToString:@"ReleaseImage"]){
        
        NSLog(@"拍照完");
        
//        ReleaseImageViewController *releaseImageVC = [[ReleaseImageViewController alloc] init];
//        releaseImageVC.headerImage = image;
//        [navigationController pushViewController:releaseImageVC animated:YES];
    }
}


-(void)setPHFetchResult:(PHFetchResult*)result{
    _assetsFetchResults =  result;
    [_TYPhotoKitView SetassetsFetchResults:_assetsFetchResults];
}

-(void) setAlassetArray:(NSMutableArray*)Alasset{
    [_TYAssetsLibraryView setUrlArray:Alasset];
    _AlassetArray = Alasset;
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    lastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{ //将要停止前的坐标
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    NSLog(@"停止滑动");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (lastContentOffset < scrollView.contentOffset.y) {
        [self.object performSelector:self.TableScrollSelector withObject:nil];

    }else{
//        [self.object performSelector:self.TableScrollSelector withObject:nil];
        
    }
}


@end
