//
//  CommunityServiceViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-10-17.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "ViewControllerIdentifier.h"
#import "UIImageView+MJWebCache.h"
#import "PhotoUITapGestureRecognizer.h"

#import "MLEmojiLabel.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface CommunityServiceViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UILabel *weiboLabel;
@property (weak, nonatomic) IBOutlet UILabel *journalLabel;
@property (weak, nonatomic) IBOutlet UILabel *AlbumLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end
