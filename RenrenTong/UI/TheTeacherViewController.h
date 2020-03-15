//
//  TheTeacherViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14/12/6.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImageView+WebCache.h"
#import "UMFeedback.h"
#import "Brage.h"

@interface TheTeacherViewController : BaseViewController<UMFeedbackDataDelegate>{

}

@property (weak, nonatomic) IBOutlet UIImageView *userFaceView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *sevicerTitle;
@property (weak, nonatomic) IBOutlet UILabel *newsLabel;
@property (weak, nonatomic) IBOutlet UILabel *notieLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *interalImageView;
@property (weak, nonatomic) IBOutlet UIButton *theNewsButton;
@property (weak, nonatomic) IBOutlet UIButton *theNoticeButton;
@property (weak, nonatomic) IBOutlet UIView *FGView;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *RedPackageView;

// 按钮和标题
@property (weak, nonatomic) IBOutlet UIButton *FBButton;
@property (weak, nonatomic) IBOutlet UIButton *WPButton;
@property (weak, nonatomic) IBOutlet UIButton *KQButton;
@property (weak, nonatomic) IBOutlet UIButton *CJButton;
@property (weak, nonatomic) IBOutlet UILabel *FBLabel;
@property (weak, nonatomic) IBOutlet UILabel *WPLabel;
@property (weak, nonatomic) IBOutlet UILabel *KQLabel;
@property (weak, nonatomic) IBOutlet UILabel *CJLabel;
@property (weak, nonatomic) IBOutlet UIView *stateView;

- (IBAction)clickHidenViewButton:(id)sender;

- (IBAction)clickNewsButton:(UIButton *)sender;
- (IBAction)clickWeiDianPingButton:(UIButton *)sender;
- (IBAction)clickCheckingButton:(UIButton *)sender;
- (IBAction)clickResultButton:(UIButton *)sender;
- (IBAction)clickFeedbackButton:(UIButton *)sender;
- (IBAction)clickContactButton:(UIButton *)sender;
- (IBAction)clickPersonalInformationButton:(UIButton *)sender;
- (IBAction)clickSchoolNoticeButton:(UIButton *)sender;

- (void)requestData;
- (void)requestServicerData;
@end
