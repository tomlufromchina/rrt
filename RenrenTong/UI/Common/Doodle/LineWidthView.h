//
//  LineWidthView.h
//  画图
//
//  Created by mj on 14-9-4.
//  Copyright (c) 2014年 Mr.Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LineWidthBlock)(CGFloat lineFloat);

@interface LineWidthView : UIView

- (id)initWithFrame:(CGRect)frame afterLineWidthBlock:(LineWidthBlock)lineWidth;

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
