//
//  AllBulletinsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/3/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface AllBulletinsViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UILabel *selectionLabel;
@property (nonatomic, copy) NSString *classID;
@property (nonatomic, assign) int pageIndex;
@property (nonatomic, assign) int pageSize;
@property (weak, nonatomic) IBOutlet UIButton *allElectsButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (nonatomic, copy) CommonSuccessBlock block;

- (IBAction)clickDeleteButton:(UIButton *)sender;
- (IBAction)clickAllElectsButton:(UIButton *)sender;

@end
