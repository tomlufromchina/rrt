//
//  CommunicationRecordDetailsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/2/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "MLEmojiLabel.h"
#import <AVFoundation/AVFoundation.h>

@protocol CommunicationRecordDetailsViewControllerDelegate <NSObject>

- (void)quotationMessage:(TheTeacherSendRecords*)theMessage;

@end

@interface CommunicationRecordDetailsViewController : BaseViewController<MLEmojiLabelDelegate>
@property(nonatomic,strong)MLEmojiLabel *emojiLabel;
@property (weak, nonatomic) IBOutlet UIView *recordBackGroupView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *addImageView;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) TheTeacherSendRecords *theTeacherSendRecordObj;

@property(nonatomic, weak)id<CommunicationRecordDetailsViewControllerDelegate> delegate;

@end
