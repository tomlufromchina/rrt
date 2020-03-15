//
//  RecordCell.h
//  RenrenTong
//
//  Created by 符其彬 on 15/2/3.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *boFangButton;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteRecordButton;
@property (weak, nonatomic) IBOutlet UIView *backGroundRecordView;

@end
