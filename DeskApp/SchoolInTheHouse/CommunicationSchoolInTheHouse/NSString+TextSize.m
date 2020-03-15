//
//  NSString+TextSize.m
//  QQ聊天练习
//
//  Created by chao on 14-7-31.
//  Copyright (c) 2014年 chao. All rights reserved.
//

#import "NSString+TextSize.h"

@implementation NSString (TextSize)
//计算文本文字的矩形的尺寸
- (CGSize)sizeWithFont:(UIFont *)font MaxSize:(CGSize)maxSize
{
    //传入一个字体（大小号）保存到字典
    NSDictionary *attrs = @{NSFontAttributeName : font};
    //maxSize定义他的最大尺寸   当实际比定义的小会返回实际的尺寸，如果实际比定义的大会返回定义的尺寸超出的会剪掉，所以一般要设一个无限大 MAXFLOAT
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
+ (NSString *)flattenHTML:(NSString *)html{
    if (html == nil || [html isEqualToString:@""]) {
        return @"";
    }
    NSString *result = @"";
    NSRange arrowTagStartRange = [html rangeOfString:@"<"];
    if (arrowTagStartRange.location != NSNotFound) {
        NSRange arrowTagEndRange = [html rangeOfString:@">"];
        result = [html stringByReplacingCharactersInRange:NSMakeRange(arrowTagStartRange.location, arrowTagEndRange.location - arrowTagStartRange.location + 1) withString:@""];
        return [self flattenHTML:result];    //递归，过滤下一个标签
    }else{
        result = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];  // 过滤&nbsp等标签
        result = [result stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“"];  // 过滤&ldquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];  // 过滤&rdquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"……"];  // 过滤&rdquo等标签
        result = [result stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];  // 过滤&mdash;等标签
        result = [result stringByReplacingOccurrencesOfString:@"&bull;" withString:@"•"];  // 过滤&mdash;等标签
        result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];  // 过滤&mdash;等标签
        result = [result stringByReplacingOccurrencesOfString:@"&middot;" withString:@"·"];  // 过滤&middot;等标签
        result = [result stringByReplacingOccurrencesOfString:@"middot;" withString:@"·"];
        result = [result stringByReplacingOccurrencesOfString:@"&amp;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"ldquo;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"hellip;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"rdquo;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"mdash;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&gt;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&#160;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"    " withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&quot;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"Isquo;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"rsquo;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&#183;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&#10;" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&lt;/p   xmlns=" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"[attach:1795722]" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&#39" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&lt;p" withString:@""];
        result = [result stringByReplacingOccurrencesOfString:@"&lt;/p" withString:@""];
    }
    return result;
}
@end
