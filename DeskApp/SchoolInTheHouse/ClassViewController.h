//
//  ClassViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface ClassViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *controlClassLabel;
@property (weak, nonatomic) IBOutlet UILabel *allStudentLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *turnOverBtn;

@end
