//
//  MyTendencyViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-8-29.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewControllerIdentifier.h"
#import "UIImageView+MJWebCache.h"
#import "PhotoUITapGestureRecognizer.h"
#import "ActivityHeaderCell.h"
#import "MLEmojiLabel.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface MyTendencyViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
