//
//  UIimageView+Animation.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/19.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "UIimageView+Animation.h"

@implementation UIImageView (Animation)
+(void)animationMethod:(UIImageView *)imageView WithString:(NSString *)string
{
    imageView.layer.contents = (id)[UIImage imageNamed:(string)].CGImage;
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [imageView.layer addAnimation:k forKey:@"SHOW"];

}
@end
