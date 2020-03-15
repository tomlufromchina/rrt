//
//  PicturesScrollerView.m
//  HLJApp
//
//  Created by 何丽娟 on 15/4/7.
//  Copyright (c) 2015年 何丽娟. All rights reserved.
//

#import "PicturesScrollerView.h"
@interface PicturesScrollerView()<UIGestureRecognizerDelegate>
{
    CGFloat lastScale;
    UIPinchGestureRecognizer *pinchRecognizer;
    NSInteger currentIndex;
}
@end
@implementation PicturesScrollerView
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.photoArray = [[NSMutableArray alloc] init];
    }
    return self;
}
-(id)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-0);
        self.photoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.photoArray = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGFloat startY = 0;
    if (!self.scrollview) {
        if (self.isShowNavigationBar) {
            startY = 64;
        }else{
            startY = 0;
        }
        self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, startY, SCREENWIDTH,  SCREENHEIGHT - startY)];
        self.scrollview.delegate = self;
        self.scrollview.delaysContentTouches = YES;
        [self.scrollview setContentSize:CGSizeMake(SCREENWIDTH*self.photoArray.count, 0)];
        [self.scrollview setPagingEnabled:YES];
        self.scrollview.backgroundColor = [UIColor blackColor];
        [self setMultipleTouchEnabled:YES];
        [self.scrollview setDelegate:self];
        self.scrollview.maximumZoomScale = 2;
        self.scrollview.minimumZoomScale = 0.5;
        [self addSubview:self.scrollview];
        
    }
    
    self.scrollview.contentOffset = CGPointMake(SCREENWIDTH*self.startIndex, 0);
    for (NSInteger i = 0; i<self.photoArray.count; i++) {
        UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(SCREENWIDTH*i, 0, SCREENWIDTH, _scrollview.height)];
        scroller.minimumZoomScale = 1;
        scroller.maximumZoomScale = 2;
        scroller.delegate = self;
        scroller.backgroundColor = [UIColor blackColor];
        [self.scrollview addSubview:scroller];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scroller.frame.size.width , 300)];
        imageView.center = CGPointMake(scroller.frame.size.width/2, scroller.frame.size.height/2);
        [imageView setImageWithUrlStr:[self.photoArray objectAtIndex:i] placholderImage:[UIImage imageNamed:@"defaultImage"]];
        [scroller addSubview:imageView];
        
        UITapGestureRecognizer *doubletap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubletap.delegate = self;
        doubletap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:doubletap];
        [self.tapGestureRecognizer requireGestureRecognizerToFail:doubletap];// 防止手势冲突
        imageView.userInteractionEnabled = YES;
        
    }
    currentIndex = self.startIndex;
}

-(void)doubleTap:(UITapGestureRecognizer*)gesture
{
    UIScrollView *view = (UIScrollView*)gesture.view.superview;
    if (view.minimumZoomScale <= view.zoomScale && view.maximumZoomScale > view.zoomScale) {
        [view setZoomScale:view.maximumZoomScale animated:YES];
    }else {
        [view setZoomScale:view.minimumZoomScale animated:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView //移动一页的宽度后调用此方法
{
    if (scrollView == self.scrollview) {
        CGFloat floatWidth = scrollView.frame.size.width;
        NSInteger currentPage = floor((scrollView.contentOffset.x-floatWidth/2)/floatWidth)+1; //返回小于或者等于指定表达式的最大整数
        if (currentIndex != currentPage) {
            currentIndex = currentPage;
            _newtitleLabel.text = [NSString stringWithFormat:@"%d/%d",currentIndex + 1,self.photoArray.count];
            for (UIView *view in self.scrollview.subviews) {
                if ([view isKindOfClass:[UIScrollView class]]){
                    UIScrollView *v = (UIScrollView*)view;
                    v.zoomScale = 1;
                    for (UIView *view in scrollView.subviews) {
                        if ([view isKindOfClass:[UIImageView class]]) {
                            view.center = CGPointMake(view.superview.frame.size.width/2, view.superview.frame.size.height/2);
                        }
                    }
                }
            }
        }
    }
}
-(void)setUpNavigation:(NSString *)titleString navigationColor:(UIColor*)color
{
    _navigationBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 64)];
    [_navigationBackground setBackgroundColor:color];
    [self addSubview: _navigationBackground];
    
    
    _newtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 20)];
    _newtitleLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, 42);
    _newtitleLabel.textColor = [UIColor whiteColor];
    _newtitleLabel.text = titleString;
    _newtitleLabel.textAlignment = NSTextAlignmentCenter;
    _newtitleLabel.font = [UIFont systemFontOfSize:20];
    
    [_navigationBackground addSubview:_newtitleLabel];
    
    //添加导航栏左侧按钮
    _navLeftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _navLeftButton.backgroundColor = [UIColor clearColor];
    [_navLeftButton setFrame:CGRectMake(0, 20, 44,44)];
    [_navLeftButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_navLeftButton setBackgroundImage:[UIImage imageNamed:@"back_btn_normal"] forState:UIControlStateNormal];
    [_navigationBackground addSubview:_navLeftButton];
    
    _navigationRightButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _navigationRightButton.backgroundColor = [UIColor clearColor];
    [_navigationRightButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-44, 20, 44, 44)];
    [_navigationRightButton addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
    [_navigationRightButton setTitle:@"详情" forState:UIControlStateNormal];
    [_navigationRightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_navigationBackground addSubview:_navigationRightButton];
}
-(void)back
{
    [self.pictureScrollerViewDelegate back];
    [self removeFromSuperview];
    
}
-(void)detail:sender
{
    [self.pictureScrollerViewDelegate rightButtonEvent:currentIndex];
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            return view;
        }
    }
    return nil;
}
#pragma mark 当缩放完毕的时候调用
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    scrollView.contentSize= CGSizeMake(view.frame.size.width, scrollView.frame.size.height - 300 + view.frame.size.height);
    view.frame=CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    view.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
}
#pragma mark 当正在缩放的时候调用
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //    NSLog(@"-----");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
