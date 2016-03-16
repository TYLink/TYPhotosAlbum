//
//  TYPhotoAlbumCollectionView.m
//  TYPhotoAlbum
//
//  Created by TianYang on 15/12/15.
//  Copyright © 2015年 Tianyang. All rights reserved.
//

#import "TYPhotoAlbumPhotoKitView.h"
#import "TYPhotoAlbum_CameraCell.h"
#import "TYPhotoAlbum_PicCell.h"

#define screenW ([UIScreen mainScreen].bounds.size.width)
#define screenH ([UIScreen mainScreen].bounds.size.height)

#define idenfierCamera @"TYPhotoAlbum_CameraCell"
#define idenfierCommon @"TYPhotoAlbum_PicCell"
#define lineSpacing  6.0

# define IOS8      [[[UIDevice currentDevice] systemVersion] floatValue] > 8.0


@interface TYPhotoAlbumPhotoKitView () <UICollectionViewDataSource>

@property (strong) PHCachingImageManager *imageManager;

@end

@implementation TYPhotoAlbumPhotoKitView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        self.imageManager = [[PHCachingImageManager alloc] init];
        [self resetCachedAssets];
        }
    return self;
}

#pragma mark - Asset Caching

- (void)resetCachedAssets
{
    [self.imageManager stopCachingImagesForAllAssets];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = self.assetsFetchResults.count;
    return count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        TYPhotoAlbum_CameraCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:idenfierCamera forIndexPath:indexPath];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame = CGRectMake(0, 0, cell1.bounds.size.width,cell1.bounds.size.height+0.5);
        [cell1 addSubview:effectview];
        
        UIImageView * MaskImageView = [[UIImageView alloc] initWithFrame:CGRectMake((cell1.bounds.size.width)/4, (cell1.bounds.size.width)/4, (cell1.bounds.size.width)/2, (cell1.bounds.size.width)/2)];
        MaskImageView.contentMode = UIViewContentModeScaleAspectFill;
        MaskImageView.backgroundColor = [UIColor clearColor];
        MaskImageView.image = [UIImage imageNamed:@"CameraIcon"];
        [cell1 addSubview:MaskImageView];
        return cell1;
    } else{
        if (indexPath.row == 1) {
            [self selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
    TYPhotoAlbum_PicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenfierCommon forIndexPath:indexPath];
    PHAsset *asset = self.assetsFetchResults[indexPath.item -1];
    [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(150, 150) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        cell.TYPhotosImageView.image = result;
        cell.backgroundColor = [UIColor redColor];
    }];
    return cell;
    }
}

-(void) SetassetsFetchResults:(PHFetchResult *)result{
    self.assetsFetchResults = result;
    [self reloadData];
}



@end
