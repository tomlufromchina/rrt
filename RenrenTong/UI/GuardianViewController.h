//
//  GuardianViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14/12/6.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "Plot.h"
#import "UMFeedback.h"
#import "Brage.h"

@interface GuardianViewController : BaseViewController<UMFeedbackDataDelegate>{


}

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIView *foorderView;
@property (weak, nonatomic) IBOutlet UILabel *footderHeaderTitle;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *integralLable;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UILabel *sevicerTitle;
@property (weak, nonatomic) IBOutlet UIImageView *theIntergralImageView;
@property (weak, nonatomic) IBOutlet UIImageView *RedPackageView;

// 几个按钮和标题
@property (weak, nonatomic) IBOutlet UIButton *ZYButton;
@property (weak, nonatomic) IBOutlet UIButton *TZButton;
@property (weak, nonatomic) IBOutlet UIButton *CJButton;
@property (weak, nonatomic) IBOutlet UIButton *WPButton;
@property (weak, nonatomic) IBOutlet UILabel *ZYLabel;
@property (weak, nonatomic) IBOutlet UILabel *TZLabel;
@property (weak, nonatomic) IBOutlet UILabel *CJLabel;
@property (weak, nonatomic) IBOutlet UILabel *WPLabel;
@property (weak, nonatomic) IBOutlet UIButton *lianxiren;
@property (weak, nonatomic) IBOutlet UIView *endView;
@property (weak, nonatomic) IBOutlet UIImageView *endImageView;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

- (IBAction)clickFeedbackButton:(UIButton *)sender;
- (IBAction)clickContactsButton:(UIButton *)sender;
- (IBAction)clickHomeWorkButton:(UIButton *)sender;
- (IBAction)clickNotieButton:(UIButton *)sender;
- (IBAction)clickResultButton:(UIButton *)sender;
- (IBAction)clickWeiPingButton:(UIButton *)sender;
- (IBAction)clickHidenViewButton:(UIButton *)sender;

- (void)requestUIData;
- (void)requestServicerData;

@end
