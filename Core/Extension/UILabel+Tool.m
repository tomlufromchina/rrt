//
//  UILabel.m
//  ToucanHealthPlatform
//
//  Created by 黄朔 on 14/12/17.
//  Copyright (c) 2014年 KSCloud.Co.,Ltd. All rights reserved.
//

#import "UILabel+Tool.h"

@implementation UILabel(Tool)

-(void)setAttrText:(NSString*)text scaleText:(NSArray*)scaleTexts scaleSize:(CGFloat)scaleSize diffColorText:(NSArray*)diffColorTexts diffColors:(NSArray*)diffColors
{
    if (!text) return;
    
    self.text = text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *scaleText in scaleTexts) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:scaleSize] range:[text rangeOfString:scaleText]];
    }
    
    for (int i=0,j=diffColorTexts.count;i<j;i++) {
        NSString *subStr = [diffColorTexts objectAtIndex:i];
        UIColor *color = [diffColors objectAtIndex:i];
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:[self.text rangeOfString:subStr]];
    }
    
    self.attributedText = attributedString;
}


-(void)setAttrText:(NSString*)text scaleText:(NSArray*)scaleTexts scaleSize:(CGFloat)scaleSize
{
    if (!text) return;
    
    self.text = text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *scaleText in scaleTexts) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:scaleSize] range:[text rangeOfString:scaleText]];
    }
    self.attributedText = attributedString;
}
-(void)setLineSpaceing:(CGFloat)lineSpacing
{
    NSMutableAttributedString * attStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:lineSpacing];
    [attStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,attStr.length)];
    self.attributedText = attStr;
}

-(void)setAttrColor:(NSString*)text scaleText:(NSArray*)scaleTexts Color:(UIColor*)color
{
    if (!text) return;
    
    self.text = text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    for (NSString *scaleText in scaleTexts) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:[text rangeOfString:scaleText]];
    }
    self.attributedText = attributedString;
}

-(void)setAttr:(CGFloat)lineSpacing scaleColorText:(NSArray*)scaleColorTexts color:(UIColor*)color scaleText:(NSArray*)scaleTexts scaleSize:(CGFloat)scaleSize
{
    if (!self.text) return;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    for (NSString *scaleText in scaleColorTexts) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:[self.text rangeOfString:scaleText]];
    }
    self.attributedText = attributedString;
    
    for (NSString *scaleText in scaleTexts) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:scaleSize] range:[self.text rangeOfString:scaleText]];
    }
    self.attributedText = attributedString;
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:lineSpacing];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,attributedString.length)];
    self.attributedText = attributedString;
    
    
}

-(void)setAttrText:(NSString*)text diffColorText:(NSArray*)diffColorTexts diffColors:(NSArray*)diffColors
{
    if (!text) return;
    self.text = text;
    if (diffColorTexts.count != diffColors.count || diffColorTexts.count <= 0 || diffColors.count <= 0) {
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    for (int i=0,j=diffColorTexts.count;i<j;i++) {
        NSString *subStr = [diffColorTexts objectAtIndex:i];
        UIColor *color = [diffColors objectAtIndex:i];
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:[self.text rangeOfString:subStr]];
    }
    self.attributedText = attributedString;
}


@end
