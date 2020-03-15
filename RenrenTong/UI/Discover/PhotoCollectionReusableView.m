//
//  PhotoCollectionReusableView.m
//  RenrenTong
//
//  Created by aedu on 15/4/10.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "PhotoCollectionReusableView.h"

@implementation PhotoCollectionReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH-20, 40)];
        [self addSubview:_label];
    }
    return self;
}

@end
