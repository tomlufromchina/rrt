//
//  RecordDetailCell.m
//  RenrenTong
//
//  Created by 符其彬 on 14-9-5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "RecordDetailCell.h"


@implementation RecordDetailCell

@synthesize content;
@synthesize photoview;

- (void)awakeFromNib
{
    isanimating = NO;
    self.discuseButton.tag = 100;
    self.praiseAndDiscussView.clipsToBounds=YES;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//show赞、评论view
- (IBAction)praiseAndDiscussButton:(UIButton *)sender {
    if (isanimating) {
        return;
    }
    isanimating = YES;
    if (sender.tag == 0) {
        [UIView animateWithDuration:0.3f animations:^{
            self.praiseAndDiscussView.frame = CGRectMake(145, self.preseBtn.top, 126, 30);
            sender.tag = 1;
        } completion:^(BOOL finished) {
            isanimating = NO;
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            self.praiseAndDiscussView.frame = CGRectMake(self.preseBtn.left, self.preseBtn.top, 0, 30);
            sender.tag = 0;
        } completion:^(BOOL finished) {
            isanimating = NO;
        }];
    }
    
}

- (IBAction)praiseButton:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(praiseCellClicked:)]) {
        [self.delegate praiseCellClicked:self.selfDyamic];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.praiseAndDiscussView.frame = CGRectMake(self.preseBtn.left, self.preseBtn.top, 0, 30);
    } completion:^(BOOL finished) {
        isanimating = NO;
    }];
}

- (IBAction)discussButton:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentCellClicked:)]) {
        [self.delegate commentCellClicked:self.selfDyamic];
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        self.praiseAndDiscussView.frame = CGRectMake(self.preseBtn.left, self.preseBtn.top, 0, 30);
    } completion:^(BOOL finished) {
        isanimating = NO;
    }];
}
@end
