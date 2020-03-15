//
//  SendRecordCell.h
//  RenrenTong
//
//  Created by 符其彬 on 15/2/2.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendRecordCell : UITableViewCell
{
    BOOL m_checked;

}
@property (weak, nonatomic) IBOutlet UIImageView *clickImageView;
@property (weak, nonatomic) IBOutlet UILabel *conmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *footTitleLabel;
- (IBAction)clickImageViewAction:(UIButton *)sender;

- (void)setChecked:(BOOL)checked;

@end
