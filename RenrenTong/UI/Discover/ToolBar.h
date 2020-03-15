//
//  ToolBar.h
//  RenrenTong
//
//  Created by aedu on 15/3/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolBarDelegate <NSObject>

-(void)sendBtnClick;
- (void)chooseImage;

@end

@interface ToolBar : UIView
@property(nonatomic, weak)UIButton *iconBtn;
@property(nonatomic, weak)UITextView *textView;
@property(nonatomic, weak)UIButton *sendBtn;
@property(nonatomic, weak)UILabel *procLable;
@property (nonatomic,strong)UIImageView *commentlIneImage;
@property(nonatomic, weak)id<ToolBarDelegate> delegate;

-(void)showPicture:(NSArray *)pictureArray;
-(void)removePicView;

@end
