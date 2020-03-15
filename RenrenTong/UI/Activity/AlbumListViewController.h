//
//  AlbumListViewController.h
//  RenrenTong
//
//  Created by jeffrey on 14-9-1.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^SelectAlbumBlock)(id album);

@interface AlbumListViewController : BaseTableViewController


@property (nonatomic, assign) BOOL isHideRightNavigationButton;
@property (nonatomic, strong) NSString *classId;
@property (nonatomic, copy)SelectAlbumBlock block;

@end
