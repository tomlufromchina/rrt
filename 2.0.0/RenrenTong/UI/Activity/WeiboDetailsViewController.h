//
//  WeiboDetailsViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-8-27.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+MJWebCache.h"
#import "PhotoUITapGestureRecognizer.h"
#import "MicroblogDetail.h"
#import "MLEmojiLabel.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "InputView.h"
#import "FaceBoard.h"

@interface WeiboDetailsViewController : BaseViewController<UIScrollViewDelegate,MLEmojiLabelDelegate,InputViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSString *weiboID;
@property (nonatomic, copy)CommonSuccessBlock block;

@end
