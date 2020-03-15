//
//  UILabel.h
//  ToucanHealthPlatform
//
//  Created by 黄朔 on 14/12/17.
//  Copyright (c) 2014年 KSCloud.Co.,Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(Tool)

-(void)setAttrText:(NSString*)text scaleText:(NSArray*)scaleTexts scaleSize:(CGFloat)scaleSize diffColorText:(NSArray*)diffColorTexts diffColors:(NSArray*)diffColors;


-(void)setAttrText:(NSString*)text scaleText:(NSArray*)scaleTexts scaleSize:(CGFloat)scaleSize;

-(void)setAttrText:(NSString*)text diffColorText:(NSArray*)diffColorTexts diffColors:(NSArray*)diffColors;

-(void)setLineSpaceing:(CGFloat)lineSpacing;

-(void)setAttrColor:(NSString*)text scaleText:(NSArray*)scaleTexts Color:(UIColor*)color;

-(void)setAttr:(CGFloat)lineSpacing scaleColorText:(NSArray*)scaleColorTexts color:(UIColor*)color scaleText:(NSArray*)scaleTexts scaleSize:(CGFloat)scaleSize;
@end
