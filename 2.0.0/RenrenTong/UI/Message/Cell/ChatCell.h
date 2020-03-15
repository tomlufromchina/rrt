//
//  ChatCell.h
//  RenrenTong
//
//  Created by jeffrey on 14-8-8.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#define Message_Subject_Pic   @"MSG_PIC_TYPE"
#define Message_Subject_Voice @"MSG_VOICE_TYPE"
#define Message_Subject_Video @"MSG_VODIO_TYPE"

#import <UIKit/UIKit.h>
#import "HBCoreLabel.h"

@class ChatCell;

@protocol ChatCellDelegate <NSObject>
@optional

- (void)cellClicked:(ChatCell*)cell;

@end

@interface ChatCell : UITableViewCell

@property (weak, nonatomic) id<ChatCellDelegate> delegate;
@property (nonatomic, strong) XMPPMessageArchiving_Message_CoreDataObject *xmppMessage;
@property (assign, nonatomic) BOOL isAudioPlaying;

//for commmon
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIButton *contentBtn;

//for text
@property (weak, nonatomic) IBOutlet HBCoreLabel *contentLabel;
//for pic
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
//for voice
@property (weak, nonatomic) IBOutlet UIView *voiceView;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImgView;
@property (weak, nonatomic) IBOutlet UILabel *voiceLabel;


@property (nonatomic, assign) BOOL bShowTime;


- (void)setChatCell:(XMPPMessageArchiving_Message_CoreDataObject*)message;

+ (float)height:(XMPPMessageArchiving_Message_CoreDataObject*)message;

- (NSString*)urlForVoice;
- (int)durationForVoice;

@end
