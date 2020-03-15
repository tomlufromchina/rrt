//
//  DynamicCellTableViewCell.m
//  RenrenTong
//
//  Created by aedu on 15/4/29.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "DynamicCell.h"
#import "PublishListAndPraiseView.h"
#import "NSString+TextSize.h"
#import "UIimageView+Animation.h"
#import "PicturesScrollerView.h"
#define MainTextFont [UIFont systemFontOfSize:15]
#define SubMainTextFont [UIFont systemFontOfSize:13]
#define Spacing 10

@interface DynamicCell()<PublishListAndPraiseViewDelegate,PictureScrollerViewDelegate>
{
    UIImageView *headImage;
    UILabel *name;
    UILabel *time;
    MLEmojiLabel *messageLabel;// 内容
    PublishListAndPraiseView *publishView;// 内容以下的View
    PicturesScrollerView *picturesScrollerView;// 图片放大View
    BOOL isShowPicScrollView;
}
@end

@implementation DynamicCell

- (void)awakeFromNib {
    [self initView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(id)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    headImage = [[UIImageView alloc] initWithFrame:CGRectMake(Spacing, Spacing, 50, 50)];
    [self.contentView addSubview:headImage];
    [headImage.layer setCornerRadius:(headImage.frame.size.height/2)];
    headImage.layer.masksToBounds = YES;
    headImage .contentMode = UIViewContentModeScaleAspectFit;
    headImage.layer.shadowColor = [UIColor grayColor].CGColor;
    headImage.layer.shadowOffset = CGSizeMake(8, 8);
    headImage.layer.shadowOpacity = 1.0f;
    headImage.layer.shadowRadius = 4.0f;
    headImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    headImage.layer.borderWidth = 2.0f;
    headImage.userInteractionEnabled = YES;
    headImage.backgroundColor = [UIColor clearColor];
    
    name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame) + Spacing, headImage.frame.origin.y, SCREENWIDTH - 40, 30)];
    name.textAlignment = NSTextAlignmentLeft;
    name.textColor = MainTextColor;
    name.font = MainTextFont;
    [self.contentView addSubview:name];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(name.frame), CGRectGetMaxY(name.frame), 200, 20)];
    time.font = SubMainTextFont;
    time.textColor = GrayTextColor;
    time.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:time];
    
    messageLabel = [[MLEmojiLabel alloc] init];
    messageLabel.numberOfLines = 0;
    messageLabel.textColor = name.textColor;
    messageLabel.font = MainTextFont;
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.lineBreakMode = NSLineBreakByCharWrapping;
    messageLabel.isNeedAtAndPoundSign = YES;
    [self.contentView addSubview:messageLabel];
    
    publishView = [[PublishListAndPraiseView alloc] init];
    publishView.delegate = self;
    [self.contentView addSubview:publishView];
}

/**
 *  处理数据和cell高度
 *
 *  @param model 数据源
 */
-(void)setModel:(TheMyTendencyList *)model
{
    _model = model;
    name.text = model.UserName;
    time.text = model.DateTime;
    [headImage setImageWithURL:[NSURL URLWithString:model.PictureUrl] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageRefreshCached];
    [messageLabel setEmojiText:[NSString flattenHTML:model.Body]];
    messageLabel.frame = CGRectMake(Spacing, CGRectGetMaxY(headImage.frame) + Spacing, SCREENWIDTH - 2*Spacing, 0);
    [messageLabel sizeToFit];
    messageLabel.frame = CGRectMake(Spacing, CGRectGetMaxY(headImage.frame) + Spacing, SCREENWIDTH - 2*Spacing, messageLabel.height);
    _height = CGRectGetMaxY(messageLabel.frame) + Spacing;
    
    if ([model.TypeId isEqualToString:@"5"] || [model.TypeId isEqualToString:@"6"]) {
        [publishView hidenPraiseView];
        _height += Spacing;
    }
    _height = CGRectGetMaxY(messageLabel.frame);
    CGFloat startX = 0;
    CGFloat startY = 0;
    
    for (NSInteger i = 0; i < model.ImagesUrl.count; i++) {
        startX = (i%3)*(Spacing+ 90) +Spacing;
        startY = (i/3)*(Spacing+ 90) + CGRectGetMaxY(messageLabel.frame) + Spacing;
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(startX , startY, 90, 90)];
        [view setImageWithUrlStr:[model.ImagesUrl objectAtIndex:i] placholderImage:[UIImage imageNamed:@"defaultImage"]];
        view.tag = i;
        [self.contentView addSubview:view];
        UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
        [view addGestureRecognizer:doubletap];
        view.userInteractionEnabled = YES;
        _height = CGRectGetMaxY(view.frame) + Spacing;
        // 最多显示6张图片
        if (i == 5) {
            break;
        }
    }
    publishView.frame = CGRectMake(0, _height, SCREENWIDTH, publishView.frame.size.height);
    
    if ([model.IsPraise boolValue]) {
        [publishView changePraiseImage];
    }
    BOOL isUploadHeadView = YES;
    /**
     *  赞头像
     */
    for (NSInteger i = 0; i < model.PraiseUsers.count; i++) {
        TheMyTendencyPraiseUsers *commnt = [model.PraiseUsers objectAtIndex:i];
        if (i == 3) {
            /**
             *  添加点赞人数Label
             */
            [publishView addPraiseNumLabel:[NSString stringWithFormat:@"等%d人觉得很赞",model.PraiseUsers.count]];
            break;
        }
        /**
         *  添加点赞人数头像
         */
        [publishView addPraiseHeadImage:commnt.PictureUrl IsupdateView:isUploadHeadView];
        isUploadHeadView = NO;
    }
    /**
     *  评论
     */
    if (model.CommentCentent.count > 0) {
        NSString *comments = @"";
        for (int j = 0; j < model.CommentCentent.count; j ++) {
            TheMyTendencyCommentCentent *bc = [model.CommentCentent objectAtIndex:j];
            NSString* br = @"";
            //换行
            if (j < [model.CommentCentent count] - 1) {
                br = @"\n";
            }
            if (![bc.ParentId isEqualToString:@"0"]) {
                comments = [NSString stringWithFormat:@"%@%@%@", comments,[NSString stringWithFormat:@"U[%@]U%@I%dIC%dC  回复 U[%@]U%@I%dIC%dC :%@", bc.Author,bc.CommenId,j,0,bc.ToUserDisplayName,bc.ParentId,j,0,bc.Body],br];
            }else{
                comments = [NSString stringWithFormat:@"%@%@%@", comments,[NSString stringWithFormat:@"U[%@]U%@I%dIC%dC :%@", bc.Author,bc.CommenId,j,0,bc.Body],br];
            }
        }
        /**
         *  添加评论内容
         */
        [publishView addCommentList:comments];
    }
    _height = publishView.bottom;
}

- (void)Tap:(UIGestureRecognizer *)ges
{
    if (!isShowPicScrollView) {
        isShowPicScrollView = YES;
        if (self.delegate) {
            [self.delegate hidenNavigationBar:NO];
        }
        picturesScrollerView = [[PicturesScrollerView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        [picturesScrollerView setUpNavigation:[NSString stringWithFormat:@"%d/%d",(int)ges.view.tag + 1,_model.ImagesUrl.count] navigationColor:[UIColor clearColor]];
        picturesScrollerView.photoArray = _model.ImagesUrl;
        picturesScrollerView.startIndex = ges.view.tag;
        picturesScrollerView.isShowNavigationBar = YES;
        [picturesScrollerView.navigationRightButton removeFromSuperview];
        picturesScrollerView.pictureScrollerViewDelegate = self;
        // 防止手势冲突
        UITapGestureRecognizer *picturesScrollerViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tap:)];
        picturesScrollerView.tapGestureRecognizer = picturesScrollerViewTap;
        [picturesScrollerView addGestureRecognizer:picturesScrollerViewTap];
        picturesScrollerView.userInteractionEnabled = YES;
        /**
         *  在cell添加一个全屏的view应该找到当前控制器的view作为父视图
         */
        [self.superview.superview.superview.superview addSubview:picturesScrollerView];
        
    } else{
        isShowPicScrollView = NO;
        [UIView animateWithDuration:0.5f animations:^{
            picturesScrollerView.alpha = 0;
            if (self.delegate) {
                [self.delegate hidenNavigationBar:YES];
            }
        } completion:^(BOOL finished) {
            [picturesScrollerView removeFromSuperview];
        }];
    }
}

-(void)back
{
    [self.delegate hidenNavigationBar:YES];
    [picturesScrollerView removeFromSuperview];
}

#pragma PublishListAndPraiseViewDelegate
-(void)praise
{
    [self.delegate DynamicPraise:self];
}
-(void)remark
{
    [self.delegate DynamicComment:self];
}
-(void)getMoreComment
{
    [self.delegate DynamicMoreComment:self];
}
-(void)selectToReply:(NSString*)selectId
{
    [self.delegate DynamicReplayComment:self ReplayID:selectId];
}

@end
