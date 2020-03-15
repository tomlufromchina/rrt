//
//  AllBulletinsDetailsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/4/1.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "MLEmojiLabel.h"

@interface AllBulletinsDetailsViewController : BaseViewController<MLEmojiLabelDelegate>
@property (nonatomic, copy) NSString *archiveId;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic,strong)MLEmojiLabel *emojiLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *readingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *commentStr;
@property (nonatomic, copy) NSString *readingStr;
@property (nonatomic, copy) NSString *timeStr;

@end
