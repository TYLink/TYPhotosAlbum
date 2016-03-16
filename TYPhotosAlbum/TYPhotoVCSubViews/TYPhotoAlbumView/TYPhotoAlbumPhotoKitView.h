//
//  TYPhotoAlbumCollectionView.h
//  TYPhotoAlbum
//
//  Created by TianYang on 15/12/15.
//  Copyright © 2015年 Tianyang. All rights reserved.
//

/**
 *    iOS8.0 之后
 */

#import <UIKit/UIKit.h>
@import Photos;


@interface TYPhotoAlbumPhotoKitView : UICollectionView

@property (strong, nonatomic) PHFetchResult       *assetsFetchResults;
@property (strong, nonatomic) PHAssetCollection   *assetCollection;

-(void) SetassetsFetchResults:(PHFetchResult *)result;


@end
