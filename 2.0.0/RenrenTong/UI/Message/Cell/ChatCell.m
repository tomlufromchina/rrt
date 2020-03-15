//
//  ChatCell.m
//  RenrenTong
//
//  Created by jeffrey on 14-8-8.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "ChatCell.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#define Avatar_Rect_R CGRectMake(275, 35, 40, 40)
#define Avatar_Rect_L CGRectMake(5, 35, 40, 40)
#define Avatar_Top_Point 35

@interface ChatCell()

+ (float)heightForContent:(XMPPMessageArchiving_Message_CoreDataObject*)message;

@end

@implementation ChatCell

- (void)awakeFromNib
{
    //设置圆角
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.layer.cornerRadius = 5.0;
    self.timeLabel.layer.borderWidth = 1.0;
    self.timeLabel.layer.borderColor = [[UIColor colorWithRed:250.0/255 green:250.0/255 blue:250.0/255 alpha:1] CGColor];
    
    self.isAudioPlaying = NO;
    self.voiceView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChatCell:(XMPPMessageArchiving_Message_CoreDataObject*)message
{
    self.xmppMessage = message;
    //set time
    if (self.bShowTime) {
        [self.timeLabel setHidden:NO];

        NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
        NSDate *date = message.timestamp;
        fmt.dateFormat = @"MM-dd HH:mm";
        NSString *time = [fmt stringFromDate:date];
        self.timeLabel.text = time;
    } else {
        [self.timeLabel setHidden:YES];
    }
    
    
    //set avatar
    if (message.isOutgoing) {
        CGRect rect = Avatar_Rect_R;
        self.avatarImgView.frame = rect;
        
        [self.avatarImgView setImageWithURL:
         [NSURL URLWithString:[RRTManager manager].loginManager.loginInfo.userAvatar]
                           placeholderImage:[UIImage imageNamed:@"default.png"]];
        
    } else {
        CGRect rect = Avatar_Rect_L;
        [self.avatarImgView setFrame:rect];
        
        NSString *userId = [[RRTManager manager].imManager userIdFromJidStr:message.bareJidStr];
        Contact *contact = [DataManager contactForId:userId];
        if (contact) {
            [self.avatarImgView setImageWithURL:[NSURL URLWithString:contact.avatarUrl]
                   placeholderImage:[UIImage imageNamed:@"default.png"]];
        } else {
            [self.avatarImgView setImage:[UIImage imageNamed:@"default.png"]];
        }
    }
    
    

    //chat text
    if (!message.message.subject) {
        [self.contentImgView setHidden:YES];
        [self.voiceView setHidden:YES];
        [self.contentLabel setHidden:NO];
        
        MatchParser *match = message.match;
        if (message.isOutgoing) {
            CGRect rect = CGRectMake(245 - match.miniWidth,
                                      Avatar_Top_Point,
                                      match.miniWidth + 20,
                                      match.height + 10);
            self.contentBtn.frame = rect;
            
            rect = CGRectMake(245 - match.miniWidth + 10,
                              Avatar_Top_Point + 5,
                              match.miniWidth,
                              match.height);
            self.contentLabel.frame = rect;
            
            
            UIImage *normal = [UIImage imageNamed:@"dialogue_b.png"];
            normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5
                                                 topCapHeight:normal.size.height * 0.7];
            
            [self.contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
            
        } else {
            CGRect rect = CGRectMake(55, Avatar_Top_Point, match.miniWidth + 20, match.height + 10);
            self.contentBtn.frame = rect;
            
            rect = CGRectMake(65, Avatar_Top_Point + 5, match.miniWidth, match.height);
            self.contentLabel.frame = rect;
            
            UIImage *normal = [UIImage imageNamed:@"dialogue_a.png"];
            normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5
                                                 topCapHeight:normal.size.height * 0.7];
            
            [self.contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
        }
        self.contentLabel.match = match;
    } else if ([message.message.subject isEqualToString:Message_Subject_Pic]) { //pic
        [self.contentLabel setHidden:YES];
        [self.voiceView setHidden:YES];
        [self.contentImgView setHidden:NO];

        if (message.isOutgoing) {
            CGRect rect = CGRectMake(245 - 40,
                                     Avatar_Top_Point,
                                     40 + 20,
                                     60 + 10);
            self.contentBtn.frame = rect;
            
            rect = CGRectMake(245 - 40 + 10,
                              Avatar_Top_Point + 5,
                              40,
                              60);
            self.contentImgView.frame = rect;

            UIImage *normal = [UIImage imageNamed:@"dialogue_b.png"];
            normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5
                                                 topCapHeight:normal.size.height * 0.7];
            
            [self.contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
            
        } else {
            CGRect rect = CGRectMake(55, Avatar_Top_Point, 40 + 20, 60 + 10);
            self.contentBtn.frame = rect;
            
            rect = CGRectMake(65, Avatar_Top_Point + 5, 40, 60);
            self.contentImgView.frame = rect;
            
            UIImage *normal = [UIImage imageNamed:@"dialogue_a.png"];
            normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5
                                                 topCapHeight:normal.size.height * 0.7];
            
            [self.contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
        }
        NSURL *url = [NSURL URLWithString:message.body];
        [self.contentImgView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defaultImage.png"]];
    } else if ([message.message.subject isEqualToString:Message_Subject_Voice]) { //voice
        [self.contentLabel setHidden:YES];
        [self.contentImgView setHidden:YES];
        [self.voiceView setHidden:NO];
        
        if (message.isOutgoing) {
            CGRect rect = CGRectMake(245 - 50,
                                     Avatar_Top_Point,
                                     50 + 20,
                                     18 + 10);
            self.contentBtn.frame = rect;
            
            rect = CGRectMake(245 - 50 + 10,
                              Avatar_Top_Point + 5,
                              50,
                              18);
            self.voiceView.frame = rect;
            
            self.voiceImgView.image = [UIImage imageNamed:@"voicePlay_B_0.png"];
            [self.voiceLabel setTextColor:[UIColor whiteColor]];

            UIImage *normal = [UIImage imageNamed:@"dialogue_b.png"];
            normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5
                                                 topCapHeight:normal.size.height * 0.7];
            
            [self.contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
            
        } else {
            CGRect rect = CGRectMake(55, Avatar_Top_Point, 50 + 20, 18 + 10);
            self.contentBtn.frame = rect;
            
            rect = CGRectMake(65, Avatar_Top_Point + 5, 50, 18);
            self.voiceView.frame = rect;
            
            self.voiceImgView.image = [UIImage imageNamed:@"voicePlay_A_0.png"];
            [self.voiceLabel setTextColor:[UIColor grayColor]];
            
            UIImage *normal = [UIImage imageNamed:@"dialogue_a.png"];
            normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5
                                                 topCapHeight:normal.size.height * 0.7];
            
            [self.contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
        }
        
        int duration = [self durationForVoice];
        
        self.voiceLabel.text = [NSString stringWithFormat:@"%d:%02d",
                                duration / 60,
                                duration % 60];
    }
}

+ (float)heightForContent:(XMPPMessageArchiving_Message_CoreDataObject*)message
{
    float height = message.match.height + 10;
    return height  > 40.0f ? height : 40.0f;
}

+ (float)height:(XMPPMessageArchiving_Message_CoreDataObject*)message;
{
    float height = 0;
    
    if (!message.message.subject) {
        height = 5 + 20 + 10 + [self heightForContent:message] + 10;
    } else if ([message.message.subject isEqualToString:Message_Subject_Pic]) {
        height = 5 + 20 + 10 + 60 + 10;
    } else {
        height =  5 + 20 + 10 + 40 + 10;
    }
    
    return height;
}


- (IBAction)buttonClicked:(id)sender
{
    if ([self.xmppMessage.message.subject isEqualToString:Message_Subject_Pic]) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:1];
        
        photo.srcImageView = self.contentImgView;
        photo.image = self.contentImgView.image;
        [photos addObject:photo];
        
        // 2.显示相册
        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        [browser show];
    } if ([self.xmppMessage.message.subject isEqualToString:Message_Subject_Voice]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellClicked:)]) {
            [self.delegate cellClicked:self];
        }
    }
}

- (void)setIsAudioPlaying:(BOOL)isAudioPlaying
{
    _isAudioPlaying = isAudioPlaying;
    
    if (isAudioPlaying) {
        if (_xmppMessage.isOutgoing) {
            NSArray *images = [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"voicePlay_B_0.png"],
                               [UIImage imageNamed:@"voicePlay_B_1.png"],
                               [UIImage imageNamed:@"voicePlay_B_2.png"],
                               [UIImage imageNamed:@"voicePlay_B_3.png"],nil];

            self.voiceImgView.animationImages = images;
        } else {
            NSArray *images = [NSArray arrayWithObjects:
                               [UIImage imageNamed:@"voicePlay_A_0.png"],
                               [UIImage imageNamed:@"voicePlay_A_1.png"],
                               [UIImage imageNamed:@"voicePlay_A_2.png"],
                               [UIImage imageNamed:@"voicePlay_A_3.png"],nil];
            
            self.voiceImgView.animationImages = images;
        }
        self.voiceImgView.animationDuration = 1.2;
        self.voiceImgView.animationRepeatCount = 0;
        
        [self.voiceImgView startAnimating];
        
    } else {
        if (self.voiceImgView.isAnimating) {
            [self.voiceImgView stopAnimating];
        }
    }
}

- (NSString*)urlForVoice
{
    NSString *url = nil;
    if (self.xmppMessage && [self.xmppMessage.message.subject isEqualToString:Message_Subject_Voice]) {
        NSString *body = self.xmppMessage.body;
        
        NSRange range = [body rangeOfString:@"&&"];
        range = NSMakeRange(0, range.location);
        url = [body substringWithRange:range];
        
    }
    
    return url;
}

- (int)durationForVoice
{
    int duration = 0;
    if (self.xmppMessage && [self.xmppMessage.message.subject isEqualToString:Message_Subject_Voice]) {
        NSString *body = self.xmppMessage.body;
        
        NSRange range = [body rangeOfString:@"&&"];
        if (range.length < 2) {
            duration = 0;
        } else {
            duration = [[body substringFromIndex:range.location + 2] intValue];
        }
    }

    return duration;
}

@end
