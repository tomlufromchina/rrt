//
//  commentaryToolView.h
//  RenrenTong
//
//  Created by 符其彬 on 15/4/10.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol commentaryToolViewDelegate <NSObject>

- (void)clickSendButton;
@optional
- (void)clickCommentaryButon;

@end

@interface commentaryToolView : UIView
@property (nonatomic, strong) UIButton *iconBtn;
@property (nonatomic, strong) UILabel *commentaryLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIImageView *lineImgView;
@property (nonatomic, strong) UILabel *procLable;
@property (nonatomic, weak) id <commentaryToolViewDelegate> delegate;

-(void)showPicture:(NSArray *)pictureArray;
-(void)removePicView;
-(void)reloadLineImageFrame;
-(void)RecoverFrame;

@end
