//
//  VistorModelCell.m
//  RenrenTong
//
//  Created by 符其彬 on 15/3/21.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "VistorModelCell.h"

@implementation VistorModelCell

- (void)awakeFromNib {

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.approvingView.layer.borderWidth = 0.6;
    self.approvingView.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
    
    self.userHeaderView.layer.masksToBounds = YES;
    self.userHeaderView.layer.cornerRadius = self.userHeaderView.width * 0.5;
    
    self.approvingImage1.layer.cornerRadius = 15.0;
    self.approvingImage1.clipsToBounds = YES;
    
    self.approvingImage2.layer.cornerRadius = 15.0;
    self.approvingImage2.clipsToBounds = YES;
    
    self.approvingImage3.layer.cornerRadius = 15.0;
    self.approvingImage3.clipsToBounds = YES;
}

#pragma mark -- 点击评论

- (IBAction)clickCommenttaryButton:(UIButton *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentCellClicked:WithCell:)]) {
        [self.delegate commentCellClicked:self.visitorModel WithCell:self];
    }
}
#pragma mark -- 点击赞

- (IBAction)clickApprovingButton:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(praiseCellClicked:WithCell:)]) {
        [self.delegate praiseCellClicked:self.visitorModel WithCell:self];
    }
}

- (IBAction)clickAllCommentaryButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickAllCommetTarrys:WithCell:)]) {
        [self.delegate clickAllCommetTarrys:self.visitorModel WithCell:self];
    }
    
}
@end
