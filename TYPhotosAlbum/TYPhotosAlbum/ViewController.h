//
//  ViewController.h
//  TYPhotosAlbum
//
//  Created by TianYang on 16/3/16.
//  Copyright © 2016年 Tianyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController : UIViewController

@property (nonatomic, strong)        ALAssetsLibrary    * library;
@property (nonatomic, strong)        NSMutableArray     * AlassetArray ;

@property (nonatomic, strong)        NSString           * CameraType;


@end

