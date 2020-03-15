//
//  CreateAlbumViewController.h
//  RenrenTong
//
//  Created by jeffrey on 14-9-2.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CreateAlbumBlock)(void);

@interface CreateAlbumViewController : BaseTableViewController

@property (nonatomic, copy) CreateAlbumBlock createAlbumBlock;
@end
