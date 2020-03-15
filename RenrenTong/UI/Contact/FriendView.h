//
//  FriendView.h
//  RenrenTong
//
//  Created by aedu on 15/3/24.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FriendViewDelegate <NSObject>

- (void)addButtonClick:(int)tag;
- (void)phoneButtonClick:(int)tag;


@end
@interface FriendView : UIView
@property(nonatomic, assign)BOOL IsFollowed;

@property(nonatomic, weak)UIImageView *friendIv;
@property(nonatomic, weak)UILabel *friendLabel;
@property(nonatomic, weak)UILabel *classLabel;
@property(nonatomic, weak)UILabel *schoolLabel;

@end
