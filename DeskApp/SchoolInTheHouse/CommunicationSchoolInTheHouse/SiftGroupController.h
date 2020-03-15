//
//  SiftGroupController.h
//  RenrenTong
//
//  Created by aedu on 15/1/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
@protocol SiftGroupControllerDelegate <NSObject>

- (void)selectedArray:(NSMutableArray *)array;

@end

@interface SiftGroupController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>


@property (strong, nonatomic)UICollectionView *collectionView;
@property(nonatomic, weak)UIView *footerView;
@property(nonatomic, weak)id<SiftGroupControllerDelegate> delegate;
@property(nonatomic, strong)NSNumber *groupId;

@end
