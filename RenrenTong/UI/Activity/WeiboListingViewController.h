//
//  WeiboListingViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14-8-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendTendencyCell.h"
#import "WeiboListCell.h"
#import "RecordDetailsController.h"
#import "UIImageView+MJWebCache.h"
#import "PhotoUITapGestureRecognizer.h"
#import "MLEmojiLabel.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@protocol WeiboListDelegate <NSObject>

- (void)backWeiBoCount:(int)weiboCount;

@end


@interface WeiboListingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,MLEmojiLabelDelegate>{
    NSMutableArray* emjoalablearray;
    NSMutableArray* commentlablearray;
    
}

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic,assign) id<WeiboListDelegate> delegate;

@end
