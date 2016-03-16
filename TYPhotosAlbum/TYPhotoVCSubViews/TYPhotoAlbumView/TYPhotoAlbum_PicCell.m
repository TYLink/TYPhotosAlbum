//
//  TYPhotoAlbum_PicCell.m
//  TYPhotoAlbum
//
//  Created by TianYang on 15/12/14.
//  Copyright © 2015年 Tianyang. All rights reserved.
//

#import "TYPhotoAlbum_PicCell.h"
#import "UIColor+Extension.h"

@implementation TYPhotoAlbum_PicCell

//+ (instancetype)cellWithCollectionView:(UICollectionView *)collectionView cellForItemAtIndex:(NSIndexPath *)indexPath {
//    TYPhotoAlbum_PicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_cellIdentifier forIndexPath:indexPath];
//    if ([[cell.contentView.subviews lastObject] isKindOfClass:[UIImageView class]]) {
//        [[cell.contentView.subviews lastObject] removeFromSuperview];
//    }
//    return cell;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _TYPhotosImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _TYPhotosImageView.userInteractionEnabled = YES;
        _TYPhotosImageView.contentMode = UIViewContentModeScaleAspectFill;
        _TYPhotosImageView.clipsToBounds = YES;
        self.backgroundView = _TYPhotosImageView;
        [self addMaskView];
        
    }
    return self;
}

-(void) addMaskView{
     UIView* maskView = ({
        maskView = [[UIView alloc] init];
        maskView.frame = self.bounds;
        maskView.backgroundColor = [UIColor getColor:@"000000" withAlpha:0.7];
        [maskView.layer setBorderWidth:2.5];
        [maskView.layer setBorderColor:[UIColor getColor:@"ff7a64"].CGColor];
        self.selectedBackgroundView = maskView;
        maskView;
    });
}


@end
