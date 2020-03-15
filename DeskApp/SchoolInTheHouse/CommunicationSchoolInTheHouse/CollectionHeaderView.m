//
//  CollectionHeaderView.m
//  RenrenTong
//
//  Created by aedu on 15/1/31.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Create a label
        self.backgroundColor = [UIColor colorWithRed:220.0 / 255 green:230.0 / 255  blue:230.0 / 255  alpha:1.0];
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.font = [UIFont systemFontOfSize:17];
        textLabel.textColor = [UIColor blackColor];
        textLabel.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:textLabel];
        self.textLabel = textLabel;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // Layout text label
    self.textLabel.frame = CGRectMake(10,
                                      (self.bounds.size.height - 21.0) / 2.0,
                                      self.bounds.size.width,
                                      21.0);
}



@end
