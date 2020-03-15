//
//  MyView.h
//  画图
//
//  Created by mj on 14-9-4.
//  Copyright (c) 2014年 Mr.Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyView : UIView{
    
}

@property (assign, nonatomic) CGFloat lineWidth;
@property (strong, nonatomic) UIColor *lineColor;

-(void)clean;
-(void)drawImg:(UIImageView*)img;
@end


