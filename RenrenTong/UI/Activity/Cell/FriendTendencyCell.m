//
//  FriendTendencyCell.m
//  RenrenTong
//
//  Created by 唐彬 on 14-8-18.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "FriendTendencyCell.h"
#import "ViewControllerIdentifier.h"

@implementation FriendTendencyCell
@synthesize content;
@synthesize photoview;

- (void)awakeFromNib
{
    isanimating = NO;
    self.dicussButton.tag = 100;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//show赞、评论view
-(IBAction)showPriseView:(UIButton*)sender{
    if (isanimating) {
        return;
    }
    isanimating=YES;
    if (sender.tag==0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.prieseview.frame=CGRectMake(145, self.prieseshowbtn.top, 124, 30);
            sender.tag=1;
        } completion:^(BOOL finished) {
            isanimating=NO;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.prieseview.frame=CGRectMake(self.prieseshowbtn.left, self.prieseshowbtn.top, 0, 30);
            sender.tag=0;
        } completion:^(BOOL finished) {
            isanimating=NO;
        }];
    }
}

- (void)setChatCell:(NSMutableArray *)messsge
{
    
}

- (IBAction)praiseButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(praiseCellClicked:)]) {
        [self.delegate praiseCellClicked:self.dynamicDetail];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.prieseview.frame = CGRectMake(self.prieseshowbtn.left, self.prieseshowbtn.top, 0, 30);
    } completion:^(BOOL finished) {
        isanimating = NO;
    }];
}

- (IBAction)discussButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentCellClicked:)]) {
        [self.delegate commentCellClicked:self.dynamicDetail];
    }

    [UIView animateWithDuration:0.2 animations:^{
        self.prieseview.frame=CGRectMake(self.prieseshowbtn.left, self.prieseshowbtn.top, 0, 30);
    } completion:^(BOOL finished) {
        isanimating=NO;
    }];
}
@end
