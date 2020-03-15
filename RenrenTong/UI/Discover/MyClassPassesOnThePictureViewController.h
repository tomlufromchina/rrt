//
//  MyClassPassesOnThePictureViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/5/12.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface MyClassPassesOnThePictureViewController : BaseViewController
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, copy) CommonSuccessBlock block;
- (IBAction)clickPhotographButton:(UIButton *)sender;
- (IBAction)clickPhotoAlbumButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UIView *addImageView;
@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;
@property (weak, nonatomic) IBOutlet UIView *uploadSelectView;
@property (weak, nonatomic) IBOutlet UIButton *albumButton;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic, assign) BOOL isHideRightNavigationButton;

@end
