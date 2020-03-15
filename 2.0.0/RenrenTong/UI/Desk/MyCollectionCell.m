//
//  MyCollectionCell.m
//  CellectionView
//
//  Created by wpc on 14-7-14.
//  Copyright (c) 2014年 wpc. All rights reserved.
//

#import "MyCollectionCell.h"

@implementation MyCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
        [self.contentView addSubview:self.titleImage];
        
        self.titleName = [[UILabel alloc] initWithFrame:CGRectMake(0, 53, 70, 17)];
        self.titleName.font = [UIFont systemFontOfSize:13];
        self.titleName.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.titleName];
    }
    return self;
}

@end
