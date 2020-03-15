//
//  ImageCollectionViewCell.m
//  RenrenTong
//
//  Created by aedu on 15/4/9.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "ImageCollectionViewCell.h"
#define CellWidth (SCREENWIDTH - 70)/4

@implementation ImageCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        //        // 初始化时加载collectionCell.xib文件
//        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PictureCollectionViewCell" owner:self options:nil];
//        
//        // 如果路径不存在，return nil
//        if (arrayOfViews.count < 1)
//        {
//            return nil;
//        }
//        // 如果xib中view不属于UICollectionViewCell类，return nil
//        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
//        {
//            return nil;
//        }
//        // 加载nib
//        self = [arrayOfViews objectAtIndex:0];
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CellWidth, CellWidth)];
        //    addimage
        [self.contentView addSubview:_image];
        
        self.selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(CellWidth-20, 0, 20, 20)];
        [self.contentView addSubview:_selectImage];
        
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    if (_isSelectToDelete) {
        self.image.frame = CGRectMake(0, 0, self.width, self.width);
        _selectImage.frame = CGRectMake(self.width - 20, 0, 20, 20);
        _selectImage.image = [UIImage imageNamed:@"confirm-err72"];
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = _selectImage.frame;
        [deleteBtn addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteBtn];
    }else{
        _selectImage.image = [UIImage imageNamed:@"confirm-ok72"];
        _selectImage.hidden = YES;
    }
}

-(void)deleteEvent:(id)sender
{
    [self.delegate deleteEvent:self];
}
@end
