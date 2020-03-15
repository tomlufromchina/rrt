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



@end

@implementation ChatCell
int tempduration=0;
- (void)awakeFromNib
{
    //设置圆角
    self.timeLabel.layer.masksToBounds = YES;
    self.timeLabel.layer.cornerRadius = 5.0;
    self.timeLabel.backgroundColor = [UIColor colorWithRed:223.0/255 green:223.0/255 blue:223.0/255 alpha:1];;
    [self.timeLabel setTextColor:[UIColor whiteColor]];
    self.avatarImgView.layer.cornerRadius = 5.0;
    self.avatarImgView.layer.masksToBounds = YES;
    self.isAudioPlaying = NO;
    self.voiceView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)initAudioDuration:(NSString*)audiouri{
    NSArray *array = [audiouri componentsSeparatedByString:@"&&"];
    if ([array count]==2) {
        int duration=[[array objectAtIndex:1] intValue];
        self.duration=duration;
        tempduration=self.duration;
        int min=duration/60;
        int sec=duration%60;
        self.voiceLabel.text=[NSString stringWithFormat:@"%i:%i",min,sec];
    }else{
        self.voiceLabel.text=@"0:0";
    }
}



- (IBAction)buttonClicked:(id)sender
{
    if (self.ispic) {
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
    }
    if (self.isaudio) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(cellClicked:)]) {
            [self.delegate cellClicked:self];
        }
    }
}

- (void)setIsAudioPlaying:(BOOL)isAudioPlaying
{
    _isAudioPlaying = isAudioPlaying;
    
    if (isAudioPlaying) {
        if (YES) {
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
        tempduration=self.duration;
//        [self performSelector:@selector(timerFired) withObject:nil afterDelay:1];
    } else {
        int min=self.duration/60;
        int sec=self.duration%60;
        self.voiceLabel.text=[NSString stringWithFormat:@"%i:%i",min,sec];
        if (self.voiceImgView.isAnimating) {
            [self.voiceImgView stopAnimating];
        }
    }
}

//-(void)timerFired{
//    tempduration--;
//    if (tempduration!=0) {
//        int min=tempduration/60;
//        int sec=tempduration%60;
//        self.voiceLabel.text=[NSString stringWithFormat:@"%i:%i",min,sec];
//        [self performSelector:@selector(timerFired) withObject:nil afterDelay:1];
//    }
//}


@end
