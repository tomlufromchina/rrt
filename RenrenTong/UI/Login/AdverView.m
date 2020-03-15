//
//  AdverView.m
//  RenrenTong
//
//  Created by aedu on 15/3/20.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "AdverView.h"
#import "AlbumList.h"
@interface AdverView()
{
    BOOL isTimerStop;
}
@end
@implementation AdverView
-(id)initWithFrame:(CGRect)frame AdverType:(AdverType)adverType
{
    self.adverType = [NSString stringWithFormat:@"%d",(int)adverType];
    return [self initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.bounces = NO;
        [self addScrollTimer];
    }
    return self;
}

-(void)setAdNameArray:(NSMutableArray *)adNameArray
{
    _adNameArray = adNameArray;
}

-(void)setLinkUrlArray:(NSMutableArray *)linkUrlArray
{
    _linkUrlArray = linkUrlArray;
}
- (void)setPicArray:(NSArray *)picArray
{
    _picArray = picArray;
    CGFloat width = self.scrollView.frame.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    self.scrollView.contentSize = CGSizeMake(picArray.count * width, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    if ([picArray count] > 1) {
        self.pageControl.numberOfPages = picArray.count;
        UIPageControl *control = [[UIPageControl alloc]init];
        control.frame = CGRectMake(SCREENWIDTH / 2 - 20, self.height - 20, 40, 20);
        control.pageIndicatorTintColor = [UIColor lightGrayColor];
        control.currentPageIndicatorTintColor = theLoginButtonColor;
        self.pageControl = control;
        [self addSubview:control];
        control.numberOfPages = picArray.count;
    }
    for (int i = 0; i < picArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.userInteractionEnabled = YES;
        CGFloat imageX = i * width;
        CGFloat imageY = 0.f;
        imageView.tag = i;
        imageView.frame = CGRectMake(imageX, imageY, width, height);
        [imageView setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick:)];
        [imageView addGestureRecognizer:tap];
        [self.scrollView addSubview:imageView];
    }
}
- (void)imageClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(clickTheImages:andWithAdNameArray:andWithLinkUrlArray:)]) {
        [self.delegate clickTheImages:tap.view.tag
                   andWithAdNameArray:_adNameArray
                  andWithLinkUrlArray:_linkUrlArray];
    }
}
- (void)addScrollTimer
{
//    self.timer = [NSTimer timerWithTimeInterval:2.f target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
}
// 下一页
- (void)nextPage
{
    if(!isTimerStop)
    {
        int currentPage = self.pageControl.currentPage;
        currentPage ++;
        if (currentPage == [_picArray count]) {
            currentPage = 0;
        }
    
        CGFloat width = self.scrollView.frame.size.width;
        CGPoint offset = CGPointMake(currentPage * width, 0.f);
        [UIView animateWithDuration:.2f animations:^{
            self.scrollView.contentOffset = offset;
        }];
    }
    
}

#pragma mark - UIScrollViewDelegate实现方法-
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = self.scrollView.contentOffset;
    CGFloat offsetX = offset.x;
    CGFloat width = self.scrollView.frame.size.width;
    int pageNum = (offsetX + .5f *  width) / width;
    
    self.pageControl.currentPage = pageNum;
    isTimerStop = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    isTimerStop = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}



@end
