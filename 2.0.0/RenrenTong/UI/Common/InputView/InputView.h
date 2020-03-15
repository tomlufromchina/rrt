//
//  InputView.h
//  RenrenTong
//
//  Created by jeffrey on 14-7-11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputView;

@protocol InputViewDelegate <NSObject>

@optional

- (void)faceBtnClicked:(InputView*)inputView;
- (void)beginToRecord:(InputView*)inputView;
- (void)finishRecord:(InputView*)inputView;


@end


@interface InputView : UIView

@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *textBtn;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *speekBtn;

@property (weak, nonatomic) id<InputViewDelegate> delegate;

- (void)setDefault;



@end
