//
//  TeacherViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "ChineseString.h"
#import "pinyin.h"

@interface TeacherViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *mainCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UIButton *turnOverButton;
@property (weak, nonatomic) IBOutlet UILabel *teacherName;
@property (weak, nonatomic) IBOutlet UILabel *chooseLabel;

@end
