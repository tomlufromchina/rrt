//
//  SiftStudentController.h
//  RenrenTong
//
//  Created by aedu on 15/1/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@protocol SiftStudentControllerDelegate <NSObject>

- (void)selectedArray:(NSMutableArray *)array;

@end

@interface SiftStudentController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>


@property (strong, nonatomic)UICollectionView *collectionView;
@property(nonatomic, weak)UIView *footerView;
@property(nonatomic, assign)BOOL IsSelectAll;
@property(nonatomic, weak)id<SiftStudentControllerDelegate> delegate;

@property(nonatomic, strong)NSNumber *classId;
/**
 *  学生是否住校
 */
@property(nonatomic, assign)int IsOnCampus;

@end
