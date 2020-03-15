//
//  CommunicationTeacherViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/1/29.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "FileDownload.h"

@interface CommunicationTeacherViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *ZYImageView;
@property (weak, nonatomic) IBOutlet UIImageView *TZImageView;
@property (weak, nonatomic) IBOutlet UIImageView *CJImageView;
@property (weak, nonatomic) IBOutlet UIImageView *BXImageView;
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;
@property (weak, nonatomic) IBOutlet UIView *theRecoedBackGroupView;
@property (weak, nonatomic) IBOutlet UILabel *waterMarkTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *addImageView;
@property (weak, nonatomic) IBOutlet UIButton *addImageButton;
@property (weak, nonatomic) IBOutlet UILabel *titleConmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *chooseObjectsLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteConmentButton;
@property (weak, nonatomic) IBOutlet UIButton *addObjectsImage;
@property (weak, nonatomic) IBOutlet UIView *recordBoard;
@property (weak, nonatomic) IBOutlet UIImageView *recoedMicImgView;
@property (weak, nonatomic) IBOutlet UIView *recordBackGroupView;
@property (weak, nonatomic) IBOutlet UILabel *limiteNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *limiteNumLabel;
@property (weak, nonatomic) IBOutlet UIView *CursorView;

- (IBAction)clickAddTheImageButton:(UIButton *)sender;
- (IBAction)clickAddObjectsButton:(UIButton *)sender;
- (IBAction)clickChooseObjectButton:(UIButton *)sender;
- (IBAction)clickZBButon:(UIButton *)sender;
- (IBAction)clickTZButton:(UIButton *)sender;
- (IBAction)clickCJButton:(UIButton *)sender;
- (IBAction)clickBXButton:(UIButton *)sender;
- (IBAction)clickTitleConmentLabel:(UIButton *)sender;

@end
