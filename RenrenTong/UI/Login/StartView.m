//
//  StartView.m
//  RenrenTong
//
//  Created by 符其彬 on 15/4/20.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "StartView.h"
@implementation StartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        [self addSubview:scrollView];
        scrollView.delegate = self;
        self.scrollView = scrollView;
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        _pageControl.center = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT-40);
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = 6;
        
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = theLoginButtonColor;
        [self addSubview:_pageControl];

        
        
        CGFloat width = self.scrollView.frame.size.width;
        CGFloat height = self.scrollView.frame.size.height;
        self.scrollView.contentSize = CGSizeMake(6 * width, 0);
        
        // 拖动分页
        self.scrollView.pagingEnabled = YES;
        // 设置代理
        self.scrollView.delegate = self;
        
        for (int i = 0; i < 6; i++) {
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.userInteractionEnabled = YES;
            CGFloat imageX = i * width;
            CGFloat imageY = 0.f;
            imageView.tag = i;
            imageView.frame = CGRectMake(imageX, imageY, width, height);
            if (SCREENHEIGHT < 500) {
                 imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"启动页%d_smaller.png",i+1]];
                
            }else{
                
                 imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"启动页%d.png",i+1]];
                
            }
           
            [self.scrollView addSubview:imageView];
            
            if (i == 5) {
                UIButton *downButton = [UIButton buttonWithType:UIButtonTypeCustom];
                downButton.frame = CGRectMake(0, 0, SCREENWIDTH,SCREENHEIGHT);
                [downButton setTitle:@"" forState:UIControlStateNormal];
                [downButton addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:downButton];
            }
        }
    }
    return self;
}
#pragma scrollView代理：实现pageControl页面改变
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView //移动一页的宽度后调用此方法
{
    CGFloat floatWidth = scrollView.frame.size.width;
    NSInteger currentPage = floor((scrollView.contentOffset.x-floatWidth/2)/floatWidth)+1; //返回小于或者等于指定表达式的最大整数
    if(currentPage != _pageControl.currentPage){
        _pageControl.currentPage = currentPage;
    }
}
- (void)dismissView
{
    if ([self.delegate respondsToSelector:@selector(clickTheImages)]) {
        [self.delegate clickTheImages];
    }
}
@end
