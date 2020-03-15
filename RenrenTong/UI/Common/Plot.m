//
//  Plot.m
//  Plot
//
//  Created by 唐彬 on 14-12-8.
//  Copyright (c) 2014年 唐彬. All rights reserved.
//

#import "Plot.h"

@implementation Plot

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        valview=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0)];
        valview.backgroundColor=[UIColor whiteColor];
        valview.layer.masksToBounds = YES;
        valview.layer.cornerRadius = 10.0;
        [self addSubview:valview];
        
        
        self.backgroundColor=[UIColor colorWithRed:(float)209/255 green:(float)219/255 blue:(float)227/255 alpha:1.0];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10.0;
    }
    return self;
}

-(void)setPlotvalue:(float)plotvalue{
    if (plotvalue<0||plotvalue>100) {
        return;
    }
    
    _plotvalue=plotvalue;
    float height=plotvalue*self.frame.size.height*0.01;
    CGRect rect=CGRectMake(0, self.height-height, self.frame.size.width, height);
    [UIView animateWithDuration:2 animations:^{
        valview.frame=rect;
    }];
}

-(void)setCl:(UIColor *)cl{
    valview.backgroundColor=cl;
}


@end

