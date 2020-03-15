//
//  FeedbackViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14/12/10.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "UMFeedback.h"

@interface FeedbackViewController : BaseViewController<UMFeedbackDataDelegate>
@property (weak, nonatomic) IBOutlet UIView *textFiledView;
@property (weak, nonatomic) IBOutlet UIView *textViewView;
@property (weak, nonatomic) IBOutlet UITextField *textFiled;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *shuiYinLabel;

@end
