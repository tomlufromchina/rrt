//
//  PhotoDetailsController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-8-29.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDetailsController : BaseViewController

@property (nonatomic, strong) PhotoList *photoAlbum;
@property (nonatomic, copy)CommonSuccessBlock block;

@end
