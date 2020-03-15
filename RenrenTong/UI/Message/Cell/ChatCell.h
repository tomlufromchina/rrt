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
#import "MLEmojiLabel.h"
#import "FileDownload.h"
@class ChatCell;

@protocol ChatCellDelegate <NSObject>
@optional

- (void)cellClicked:(ChatCell*)cell;

@end

@interface ChatCell : UITableViewCell

@property (weak, nonatomic) id<ChatCellDelegate> delegate;

//for commmon
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UIButton *contentBtn;

//for text
@property (weak, nonatomic) IBOutlet MLEmojiLabel *contentLabel;
//for pic
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
@property (weak, nonatomic) IBOutlet UIImageView *contentbgbox;
//for voice
@property (weak, nonatomic) IBOutlet UIView *voiceView;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImgView;
@property (weak, nonatomic) IBOutlet UILabel *voiceLabel;
@property (assign, nonatomic)  BOOL ispic;
@property (assign, nonatomic)  BOOL isaudio;
@property (assign, nonatomic) BOOL isAudioPlaying;
@property (assign, nonatomic) int duration;


@property (nonatomic, assign) BOOL bShowTime;

-(void)initAudioDuration:(NSString*)audiouri;
@end
