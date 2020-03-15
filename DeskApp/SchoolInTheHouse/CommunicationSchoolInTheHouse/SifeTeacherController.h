//
//  SifeTeacherController.h
//  RenrenTong
//
//  Created by aedu on 15/1/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
@protocol SifeTeacherControllerDelegate <NSObject>

- (void)selectedArray:(NSMutableArray *)array;

@end

@interface SifeTeacherController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>

/**
 *  原始数据源数组
 */
@property(nonatomic,strong)NSMutableArray *datasoures;

@property (strong, nonatomic)UICollectionView *collectionView;
@property(nonatomic, weak)UIView *footerView;
@property(nonatomic, weak)id<SifeTeacherControllerDelegate> delegate;


@end
