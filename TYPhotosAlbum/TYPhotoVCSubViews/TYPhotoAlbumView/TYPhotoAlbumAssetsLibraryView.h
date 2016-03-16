//
//  TYPhotoAlbumView.h
//  TYPhotoAlbum
//
//  Created by TianYang on 15/12/15.
//  Copyright © 2015年 Tianyang. All rights reserved.
//
/**
 *    iOS8.0 之前
 */

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface TYPhotoAlbumAssetsLibraryView : UICollectionView

@property (nonatomic, strong) NSMutableArray *urlArray;

@end
