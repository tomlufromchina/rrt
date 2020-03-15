//
//  ChatViewController.h
//
//
//  Created by Liu Feng on 14-7-10.
//  Copyright (c) 2013年 Jeffrey.liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoodleViewController.h"
#import "UUID.h"
#import "IMCache.h"
#import "MLEmojiLabel.h"
#import "FileDownload.h"
#import "ChatCell.h"
@interface ChatViewController : BaseViewController <DoodleDelegate,MLEmojiLabelDelegate,AVAudioPlayerDelegate>{
    
}


@property (nonatomic, copy) NSString *UserName;
@property (nonatomic, copy) NSString *UserId;
@property(nonatomic, assign)int groupType;

@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UITextView *textField;
@property (weak, nonatomic) IBOutlet UIButton *speekBtn;
@property (weak, nonatomic) IBOutlet UIView *toolView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//for record
@property (weak, nonatomic) IBOutlet UIView *recordBoard;
@property (weak, nonatomic) IBOutlet UIImageView *recordCancelImgView;
@property (weak, nonatomic) IBOutlet UIImageView *recordMicImgView;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;





@end
