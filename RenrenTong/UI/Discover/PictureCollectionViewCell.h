//
//  PictureCollectionViewCell.h
//  RenrenTong
//
//  Created by aedu on 15/4/7.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PictureCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UILabel *imageName;
@property (nonatomic,strong) UILabel *imageNum;
@property (nonatomic,strong) UIImageView *selectImage;
@end
