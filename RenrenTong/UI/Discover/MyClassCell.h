//
//  MyClassCell.h
//  RenrenTong
//
//  Created by 符其彬 on 15/3/27.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyClassCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classSloganLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickArticleButton;
@property (weak, nonatomic) IBOutlet UIButton *clickAlbumButton;

@end
