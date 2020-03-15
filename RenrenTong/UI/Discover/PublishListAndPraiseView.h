//
//  PublishListAndPraiseView.h
//  RenrenTong
//
//  Created by aedu on 15/4/15.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PublishListAndPraiseViewDelegate <NSObject>

-(void)praise;
-(void)remark;
@optional
-(void)getMoreComment;
-(void)selectToReply:(NSString*)selectId;

@end

@interface PublishListAndPraiseView : UIView

@property (nonatomic,strong) UIButton *praiseButton;
@property (nonatomic,strong) UIButton *remarkButton;
@property (nonatomic,strong) UIButton *moreComment;
@property (nonatomic,strong) UIImageView *remark;
@property (nonatomic,assign) BOOL isReply;
@property (nonatomic,assign) BOOL ispraised;

@property (nonatomic,assign) id <PublishListAndPraiseViewDelegate> delegate;

-(void)addPraiseHeadImage:(NSString*)imageUrl IsupdateView:(BOOL)isupdateView;

-(void)addPraiseNumLabel:(NSString*)text;

-(void)changePraiseImage;

-(void)addCommentList:(NSString*)comment;
/**
 *  班级网状态是5（班级网相册）或者6（班级网微博）
 */
- (void)hidenPraiseView;
@end
