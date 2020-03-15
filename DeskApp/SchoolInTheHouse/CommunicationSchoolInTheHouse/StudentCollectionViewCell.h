//
//  StudentCollectionViewCell.h
//  RenrenTong
//
//  Created by aedu on 15/2/2.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseButton;
@interface StudentCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong)BaseButton *btn;
@property(nonatomic, assign)BOOL checked;
@end
