//
//  StudentCollectionViewCell.m
//  RenrenTong
//
//  Created by aedu on 15/2/2.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "StudentCollectionViewCell.h"
#import "BaseButton.h"

@implementation StudentCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.btn = [[BaseButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        [self.btn setImage:[UIImage imageNamed:@"check_un"] forState:UIControlStateNormal];
        self.btn.imageView.hidden = YES;
        
        for (id subView in self.contentView.subviews) {
            [subView removeFromSuperview];
         }
        [self.contentView addSubview:self.btn];
    }
    return self;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    if (checked)
    {
        [self.btn setImage:[UIImage imageNamed:@"check_yes"] forState:UIControlStateNormal];
        
    }
    else
    {
        [self.btn setImage:[UIImage imageNamed:@"check_un"] forState:UIControlStateNormal];
    }
}


@end
