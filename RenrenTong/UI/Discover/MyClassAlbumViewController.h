//
//  MyClassAlbumViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/4/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "ASIFormDataRequest.h"

@interface MyClassAlbumViewController : BaseViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, strong) ASIFormDataRequest *request;
@end
