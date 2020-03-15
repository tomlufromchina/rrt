//
//  PictureCollectionViewCell.m
//  RenrenTong
//
//  Created by aedu on 15/4/7.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "PictureCollectionViewCell.h"

@implementation PictureCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PictureCollectionViewCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 70)];
        //    addimage
        [self.contentView addSubview:_image];
        
        _imageName = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(_image.frame), 90, 30)];
        _imageName.textColor  = MainTextColor;
        _imageName.font = [UIFont systemFontOfSize:13];
        
        [self.contentView addSubview:_imageName];
        
        _imageNum = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.width - 40, CGRectGetMaxY(_image.frame), 30, 30)];
        
        _imageNum.textAlignment = NSTextAlignmentRight;
        _imageNum.textColor = GrayTextColor;
        _imageName.font = _imageName.font;
        [self.contentView addSubview:_imageNum];
        
        self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 20, 20)];
        _selectImage.image = [UIImage imageNamed:@"confirm-ok72"];
        _selectImage.hidden = YES;
        //    addimage
        [self.contentView addSubview:_selectImage];
        
        self.layer.masksToBounds = YES;
        self.layer.borderColor = LineColor.CGColor;
        self.layer.borderWidth = 1;

    }
    return self;
}
@end
