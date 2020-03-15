//
//  EditViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-11-3.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"

@interface EditViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *titleUI;
@property (nonatomic, copy) NSString *titleName;

@property (nonatomic, copy) CommonSuccessBlock block;



@end
