//
//  ImageCollectionViewCell.h
//  RenrenTong
//
//  Created by aedu on 15/4/9.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageCollectionCellDelegate <NSObject>
@optional
-(void)deleteEvent:(id)collectionCell;

@end

@interface ImageCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *image;
@property (nonatomic,strong) UIImageView *selectImage;
@property (nonatomic,assign) BOOL isSelectToDelete;
@property (nonatomic,assign) CGFloat cellWidth;
@property (nonatomic,assign) id <ImageCollectionCellDelegate> delegate;

@end
