//
//  AlbumListViewController.h
//  RenrenTong
//
//  Created by jeffrey on 14-9-1.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^SelectAlbumBlock)(PhotoList *album);

@interface AlbumListViewController : BaseTableViewController

@property (nonatomic, copy)SelectAlbumBlock block;

@end
