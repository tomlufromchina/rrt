//
//  MyClassArticleReleaseViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 15/4/14.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface MyClassArticleReleaseViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UILabel *watermarkLabel;
@property (nonatomic, copy) NSString *classId;
@property (nonatomic, copy) CommonSuccessBlock block;

@end
