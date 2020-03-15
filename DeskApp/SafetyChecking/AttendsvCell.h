//
//  AttendsvCell.h
//  RenrenTong
//
//  Created by 唐彬 on 14-10-8.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttendsvCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timelable;
@property (weak, nonatomic) IBOutlet UIImageView *riliimg;
@property (weak, nonatomic) IBOutlet UIButton *zxbtn;
@property (weak, nonatomic) IBOutlet UILabel *zxlable;
@property (weak, nonatomic) IBOutlet UIButton *zdbtn;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet UILabel *zdlable;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
- (IBAction)zxclick:(id)sender;
- (IBAction)zdclick:(id)sender;
- (IBAction)allClick:(UIButton *)sender;

@end
