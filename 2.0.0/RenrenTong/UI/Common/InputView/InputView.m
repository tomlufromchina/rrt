//
//  InputView.m
//  RenrenTong
//
//  Created by jeffrey on 14-7-11.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "InputView.h"

@implementation InputView

- (id)init
{
    CGRect rect = CGRectMake(0, 0, 320, 50);
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"InputView"
                                                owner:self
                                              options:nil];
    
    UIView *inputView = [nib objectAtIndex:0];
    self = (InputView*)inputView;
    
    if (self) {
        self.speekBtn.backgroundColor = appColor;
//        self.backgroundColor = [UIColor grayColor];
        self.frame = frame;
    }
    return self;
}

- (IBAction)voiceBtnClicked:(id)sender
{
    [self.voiceBtn setHidden:YES];
    [self.textField setHidden:YES];
    [self.textField resignFirstResponder];
    
    [self.textBtn setHidden:NO];
    [self.speekBtn setHidden:NO];
    [self.speekBtn setTitle:@"按住说话" forState:UIControlStateNormal];
}

- (IBAction)textBtnClicked:(id)sender
{
    [self.textBtn setHidden:YES];
    [self.speekBtn setHidden:YES];
    [self.speekBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    
    [self.voiceBtn setHidden:NO];
    [self.textField setHidden:NO];
    [self.textField becomeFirstResponder];
}

- (IBAction)faceBtnClicked:(id)sender
{
    [self textBtnClicked:self.textBtn];
    
    [self.textField becomeFirstResponder];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(faceBtnClicked:)]) {
        [self.delegate faceBtnClicked:self];
    }
}

- (IBAction)moreBtnClicked:(id)sender
{
    //todo:
}

- (IBAction)beginToRecord:(id)sender
{
    [self.speekBtn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.speekBtn setTitle:@"松开结束" forState:UIControlStateHighlighted];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(beginToRecord:)]) {
        [self.delegate beginToRecord:self];
    }
}

- (IBAction)finishRecord:(id)sender
{
    [self.speekBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.speekBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishRecord:)]) {
        [self.delegate finishRecord:self];
    }
}

- (void)setDefault
{
    [self.voiceBtn setHidden:YES];
    [self.textBtn setHidden:YES];
    [self.speekBtn setHidden:YES];
    [self.moreBtn setHidden:YES];
    
    CGRect rect = self.textField.frame;
    CGRect newRect = CGRectMake(rect.origin.x - 30,
                                rect.origin.y,
                                rect.size.width + 60,
                                rect.size.height);
    
    self.textField.frame = newRect;
    
    rect = self.faceBtn.frame;
    newRect = CGRectMake(rect.origin.x + 30, rect.origin.y, rect.size.width, rect.size.height);
    self.faceBtn.frame = newRect;
    
}


@end