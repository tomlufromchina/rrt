//
//  NewActivityCell.h
//  RenrenTong
//
//  Created by 符其彬 on 14-11-3.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"


@interface NewActivityCell : UITableViewCell
@property (strong, nonatomic) MLEmojiLabel *content;
@property (strong, nonatomic) UIView *photoview;
@property (weak, nonatomic) IBOutlet UILabel *subjectTitle;

@end
