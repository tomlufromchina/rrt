//
//  AlbumDetailViewController.h
//  RenrenTong
//
//  Created by aedu on 15/4/7.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "ASIFormDataRequest.h"

@interface AlbumPictureViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *albumId;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) ASIFormDataRequest *request;

@end
