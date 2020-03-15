//
//  MoreMenuBoard.m
//  RenrenTong
//
//  Created by jeffrey on 14-8-13.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "MoreMenuBoard.h"

@implementation MoreMenuBoard

- (id)init
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"MoreMenuBoard"
                                                owner:self
                                              options:nil];
    
    UIView *view = [nib objectAtIndex:0];
    self = (MoreMenuBoard*)view;

    if (self) {
        //TODO:
        
        
    }
    return self;
}

- (IBAction)itemClicked:(id)sender
{
    UIButton *button = (UIButton*)sender;
    int index = button.tag;//1,2,3,4,5
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemClicked:)]) {
        [self.delegate itemClicked:index];
    }
}


@end
