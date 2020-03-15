//
//  MyView.m
//  画图
//
//  Created by mj on 14-9-4.
//  Copyright (c) 2014年 Mr.Li. All rights reserved.
//

#import "MyView.h"
#import "MyViewModel.h"

@interface MyView ()

@property (assign, nonatomic) CGMutablePathRef path;
@property (strong, nonatomic) NSMutableArray *pathArray;
@property (assign, nonatomic) BOOL isHavePath;
@end

@implementation MyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _lineWidth = 1.0f;
        _lineColor = [UIColor blackColor];
        if (_pathArray == nil) {
            _pathArray = [NSMutableArray array];
        }
    }
    return self;
}

-(void)drawImg:(UIImageView*)img{
    MyViewModel *myViewModel = [MyViewModel viewModelWithColor:_lineColor Img:img Width:_lineWidth];
    [_pathArray addObject:myViewModel];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawView:context];
}
- (void)drawView:(CGContextRef)context
{
    for (MyViewModel *myViewModel in _pathArray) {
        if (myViewModel.img) {
            UIImage* img=myViewModel.img.image;
            [img drawInRect:myViewModel.img.frame];
        }else{
            CGContextAddPath(context, myViewModel.path.CGPath);
            [myViewModel.color set];
            CGContextSetLineWidth(context, myViewModel.width);
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextDrawPath(context, kCGPathStroke);
        }
    }
    if (_isHavePath) {
        CGContextAddPath(context, _path);
        [_lineColor set];
        CGContextSetLineWidth(context, _lineWidth);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextDrawPath(context, kCGPathStroke);
    }
}

-(void)clean{
    _isHavePath = NO;
    [_pathArray removeAllObjects];
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location =[touch locationInView:self];
    _path = CGPathCreateMutable();
    _isHavePath = YES;
    CGPathMoveToPoint(_path, NULL, location.x, location.y);
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    CGPathAddLineToPoint(_path, NULL, location.x, location.y);
    [self setNeedsDisplay];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:_path];
    MyViewModel *myViewModel = [MyViewModel viewModelWithColor:_lineColor Path:path Width:_lineWidth];
    [_pathArray addObject:myViewModel];
    
    CGPathRelease(_path);
    _isHavePath = NO;
}
@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com
