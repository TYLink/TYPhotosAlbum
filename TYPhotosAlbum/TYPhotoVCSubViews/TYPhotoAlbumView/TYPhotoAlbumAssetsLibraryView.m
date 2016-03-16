//
//  TYPhotoAlbumView.m
//  TYPhotoAlbum
//
//  Created by TianYang on 15/12/15.
//  Copyright © 2015年 Tianyang. All rights reserved.
//

#import "TYPhotoAlbumAssetsLibraryView.h"
#import "TYPhotoAlbum_CameraCell.h"
#import "TYPhotoAlbum_PicCell.h"
#import "UIColor+Extension.h"

#define screenW ([UIScreen mainScreen].bounds.size.width)
#define screenH ([UIScreen mainScreen].bounds.size.height)

#define idenfierCamera @"TYPhotoAlbum_CameraCell"
#define idenfierCommon @"TYPhotoAlbum_PicCell"
#define lineSpacing  6.0

@interface TYPhotoAlbumAssetsLibraryView () <UICollectionViewDataSource>


@end

@implementation TYPhotoAlbumAssetsLibraryView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dataSource = self;
        [self getImgs];
    }
    return self;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return ([_urlArray count]+1);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        TYPhotoAlbum_CameraCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:idenfierCamera forIndexPath:indexPath];
        UIView * MaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cell1.bounds.size.width, cell1.bounds.size.width)];
        MaskView.backgroundColor = [UIColor getColor:@"484947" withAlpha:0.8];
        
        UIImageView * MaskImageView = [[UIImageView alloc] initWithFrame:CGRectMake((cell1.bounds.size.width)/4, (cell1.bounds.size.width)/4, (cell1.bounds.size.width)/2, (cell1.bounds.size.width)/2)];
        MaskImageView.contentMode = UIViewContentModeScaleAspectFill;
        MaskImageView.backgroundColor = [UIColor clearColor];
        MaskImageView.image = [UIImage imageNamed:@"CameraIcon"];
       [cell1 addSubview:MaskView];
        [cell1 addSubview:MaskImageView];
        return cell1;
    } else{
        if (indexPath.row == 1) {
            [self selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        }
        TYPhotoAlbum_PicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenfierCommon forIndexPath:indexPath];
        if (self.urlArray.count) {
            NSURL *url = self.urlArray[indexPath.row - 1];
            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:url resultBlock:^(ALAsset *asset)  {
                UIImage *image=[UIImage imageWithCGImage:asset.thumbnail];
                cell.TYPhotosImageView.image = image;
            }failureBlock:^(NSError *error) {
                NSLog(@"error=%@",error);
            }];
        }else {
            NSLog(@"相册没有图片");
        }
        return cell;
    }
}

- (NSMutableArray *)urlArray
{
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

-(void)getImgs{
    dispatch_async(dispatch_get_main_queue(), ^{
        ALAssetsLibraryAccessFailureBlock failureblock = ^(NSError *myerror){
            NSLog(@"相册访问失败 =%@", [myerror localizedDescription]);
            if ([myerror.localizedDescription rangeOfString:@"Global denied access"].location!=NSNotFound) {
                NSLog(@"无法访问相册.请在'设置->定位服务'设置为打开状态.");
            }else{
                NSLog(@"相册访问失败.");
            }
        };
        ALAssetsGroupEnumerationResultsBlock groupEnumerAtion = ^(ALAsset *result,NSUInteger index, BOOL *stop){
            if (result!=NULL) {                
                if ([[result valueForProperty:ALAssetPropertyType]isEqualToString:ALAssetTypePhoto]) {
                    [self.urlArray addObject:result.defaultRepresentation.url];
                }
            }
        };
        ALAssetsLibraryGroupsEnumerationResultsBlock libraryGroupsEnumeration = ^(ALAssetsGroup* group,BOOL* stop){
            if (group!=nil) {
                [group enumerateAssetsUsingBlock:groupEnumerAtion];
                [self  reloadData];
            }
            
        };
        
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library enumerateGroupsWithTypes:ALAssetsGroupAll
                               usingBlock:libraryGroupsEnumeration
                             failureBlock:failureblock];
    });

//

}


@end
