//
//  FriendTendencyCell.h
//  RenrenTong
//
//  Created by 唐彬 on 14-8-18.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
@protocol FriendTendencyCellDelegate <NSObject>

@optional
//用来传对象 给评论
- (void)commentCellClicked:(FriendDynamicDetail *)friendDynamicDetail;
- (void)praiseCellClicked: (FriendDynamicDetail *)friendDynamicDetail;

@end

@interface FriendTendencyCell : UITableViewCell
{
    BOOL isanimating;
}

@property (weak, nonatomic) IBOutlet UIImageView *userface;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (strong, nonatomic) MLEmojiLabel *content;
@property (strong, nonatomic) UIView *photoview;
@property (weak, nonatomic) IBOutlet UILabel *timer;
@property (weak, nonatomic) IBOutlet UIButton *morebtn;
@property (weak, nonatomic) IBOutlet UIButton *prieseshowbtn;
@property (weak, nonatomic) IBOutlet UIView *prieseview;
@property (weak, nonatomic) IBOutlet UIView *prieseviewdetail;
@property (weak, nonatomic) IBOutlet UILabel *prieselable;
@property (weak, nonatomic) IBOutlet UIView *commentview;
@property (weak, nonatomic) IBOutlet UIImageView *commentbgview;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UIButton *dicussButton;
@property (nonatomic, strong) FriendDynamicDetail *dynamicDetail;

@property (nonatomic, assign) NSString *typeId;
@property (weak, nonatomic)id<FriendTendencyCellDelegate> delegate;

- (IBAction)showPriseView:(UIButton *)sender;
- (IBAction)praiseButton:(UIButton *)sender;
- (IBAction)discussButton:(UIButton *)sender;


@end
