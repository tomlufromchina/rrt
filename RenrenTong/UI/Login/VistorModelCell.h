//
//  VistorModelCell.h
//  RenrenTong
//
//  Created by 符其彬 on 15/3/21.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
@class VistorModelCell;
@protocol VistorModelCellDelegate <NSObject>

@optional
//班级动态用来传对象 给评论
- (void)commentCellClicked:(VisitorModel *)visitorModel WithCell:(VistorModelCell *)cell;
- (void)praiseCellClicked:(VisitorModel *)visitorModel WithCell:(VistorModelCell *)cell;
- (void)clickAllCommetTarrys:(VisitorModel *)visitorModel WithCell:(VistorModelCell *)cell;

@end

@interface VistorModelCell : UITableViewCell
@property (strong, nonatomic) MLEmojiLabel *content;
@property (weak, nonatomic) IBOutlet UIView *commentaryView;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *approvingView;
@property (weak, nonatomic) IBOutlet UIImageView *approvingImage1;
@property (weak, nonatomic) IBOutlet UIImageView *approvingImage2;
@property (weak, nonatomic) IBOutlet UIImageView *approvingImage3;
@property (weak, nonatomic) IBOutlet UILabel *approvingNumberLabel;
@property (weak, nonatomic) IBOutlet UIButton *allcommenttaryButton;
@property (weak, nonatomic) IBOutlet UIView *allCommenttarysView;
@property (weak, nonatomic) IBOutlet UIImageView *praiseImageView;
@property (strong, nonatomic) UIView *photoView;
@property (nonatomic, strong) VisitorModel *visitorModel;
@property (weak, nonatomic) IBOutlet UIButton *commentTaryButton;
@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic)id<VistorModelCellDelegate> delegate;


- (IBAction)clickCommenttaryButton:(UIButton *)sender;
- (IBAction)clickApprovingButton:(id)sender;
- (IBAction)clickAllCommentaryButton:(UIButton *)sender;

@end
