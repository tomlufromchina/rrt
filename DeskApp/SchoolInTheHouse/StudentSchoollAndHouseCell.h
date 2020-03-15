//
//  StudentSchoollAndHouseCell.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-30.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

@interface StudentSchoollAndHouseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *sendName;
@property (weak, nonatomic) IBOutlet UILabel *recTime;
@property (strong, nonatomic) MLEmojiLabel *content;

@end
