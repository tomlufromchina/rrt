//
//  UIImage+Addition.m
//  RenrenTong
//
//  Created by jeffrey on 14-9-4.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "UIImage+Addition.h"

@implementation UIImage (Size)

+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize,
                                           image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0,
                                 image.size.width * scaleSize,
                                 image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end