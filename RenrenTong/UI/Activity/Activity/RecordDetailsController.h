//
//  RecordDetailsController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-8-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"

@interface RecordDetailsController : BaseViewController

@property(nonatomic,readwrite,copy)NSString* rid;

@property (nonatomic, copy)CommonSuccessBlock block;

@end
