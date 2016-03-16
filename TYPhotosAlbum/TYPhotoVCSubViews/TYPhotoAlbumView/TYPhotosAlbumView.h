//
//  TYPhotosAlbumView.h
//  TYPhotoAlbum
//
//  Created by TianYang on 15/12/15.
//  Copyright © 2015年 Tianyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCNavigationController.h"
#import "TYPhotoAlbumAssetsLibraryView.h"
#import "TYPhotoAlbumPhotoKitView.h"

@import Photos;

@interface TYPhotosAlbumView : UIView<SCNavigationControllerDelegate>

@property (strong, nonatomic) PHFetchResult       *assetsFetchResults;
@property (strong, nonatomic) PHAssetCollection   *assetCollection;
@property (strong, nonatomic) NSMutableArray      *AlassetArray;

@property (strong, nonatomic) NSString            *CameraType;

@property (nonatomic, strong) TYPhotoAlbumAssetsLibraryView    * TYAssetsLibraryView;
@property (nonatomic, strong) TYPhotoAlbumPhotoKitView         * TYPhotoKitView;


@property (nonatomic, assign) id object;

@property (nonatomic, assign) SEL TableScrollSelector;

@property (nonatomic, assign) SEL TableEndScrollSelector;

- (id) initWithFrame:(CGRect)frame;

typedef void (^TYPhotosAlbumBlock)(UIImage *AlbumImage);

@property (nonatomic, copy) TYPhotosAlbumBlock returnAlbumImageBlock;

- (void)returnAlbumImage:(TYPhotosAlbumBlock)block;



typedef void (^TYCameraImageBlock)(UIImage *CameraImage);

@property (nonatomic, copy) TYCameraImageBlock returnCameraImageBlock;

- (void)returnCameraImage:(TYCameraImageBlock)block;




-(void)setPHFetchResult:(PHFetchResult*)result;

-(void) setAlassetArray:(NSMutableArray*)Alasset;

@end

