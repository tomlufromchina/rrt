//
//  FaceBoard.m
//
//  Created by blue on 12-9-26.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood

#import "FaceBoard.h"

#define FACE_TOTAL_NUM   54
#define FACE_PAGE_NUM    28
#define FACE_WIDTH       26

#define FaceView_Height   160
#define PageControl_Height 30

#define Interval_H  18
#define Interval_V  10



@implementation FaceBoard
@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, FaceView_Height + PageControl_Height)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:243.0/255.0 green:243.0/255.0 blue:243.0/255.0 alpha:1];
        
        _faceMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"faceMap_ch" ofType:@"plist"]];
       
        //表情盘
        faceView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, FaceView_Height)];
        faceView.pagingEnabled = YES;
        faceView.contentSize = CGSizeMake((FACE_TOTAL_NUM / FACE_PAGE_NUM + 1) * SCREENWIDTH, FaceView_Height);
        faceView.showsHorizontalScrollIndicator = NO;
        faceView.showsVerticalScrollIndicator = NO;
        faceView.delegate = self;
        
        for (int i = 0; i < FACE_TOTAL_NUM; i++) {
            FaceButton *faceButton = [FaceButton buttonWithType:UIButtonTypeCustom];
            faceButton.buttonIndex = i;
            
            [faceButton addTarget:self
                           action:@selector(faceButton:)
                 forControlEvents:UIControlEventTouchUpInside];
            
            //计算每一个表情按钮的坐标和在哪一屏
            faceButton.frame = CGRectMake
            (((i % FACE_PAGE_NUM) % 7) * (FACE_WIDTH + Interval_H) + Interval_H + (i / FACE_PAGE_NUM * SCREENWIDTH),
                                          ((i % FACE_PAGE_NUM) / 7) * (FACE_WIDTH + Interval_V) + Interval_V,
                                          FACE_WIDTH,
                                          FACE_WIDTH);
            
            [faceButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"f%03d",i]] forState:UIControlStateNormal];
            [faceView addSubview:faceButton];
        }
        
        //添加PageControl
        facePageControl = [[GrayPageControl alloc] initWithFrame:CGRectMake(110,
                                                                            FaceView_Height,
                                                                            100,
                                                                            PageControl_Height)];
        
        [facePageControl addTarget:self
                            action:@selector(pageChange:)
                  forControlEvents:UIControlEventValueChanged];
        
        facePageControl.numberOfPages = FACE_TOTAL_NUM / FACE_PAGE_NUM + 1;
        facePageControl.currentPage = 0;
        [self addSubview:facePageControl];
        
        //添加键盘View
        [self addSubview:faceView];
        
        //删除键
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back setTitle:@"删除" forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"backFace"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"backFaceSelect"] forState:UIControlStateSelected];
        [back addTarget:self action:@selector(backFace) forControlEvents:UIControlEventTouchUpInside];
        back.frame = CGRectMake(270, FaceView_Height, 38, 27);
        [self addSubview:back];
        
    }
    return self;
}

//停止滚动的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [facePageControl setCurrentPage:faceView.contentOffset.x/SCREENWIDTH];
    [facePageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    [faceView setContentOffset:CGPointMake(facePageControl.currentPage*SCREENWIDTH, 0) animated:YES];
    [facePageControl setCurrentPage:facePageControl.currentPage];
}

- (void)faceButton:(id)sender {
    int i = ((FaceButton*)sender).buttonIndex;
    if (self.inputTextField) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"f%03d",i]]];
        self.inputTextField.text = faceString;
    }
    if (self.inputTextView) {
        NSMutableString *faceString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        [faceString appendString:[_faceMap objectForKey:[NSString stringWithFormat:@"f%03d",i]]];
        self.inputTextView.text = faceString;
        if (self.inputTextView.delegate &&
            [self.inputTextView.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [self.inputTextView.delegate textViewDidChange:self.inputTextView];
        }
        
    }
}

- (void)backFace{
    NSString *inputString;
    inputString = self.inputTextField.text;
    if (self.inputTextView) {
        inputString = self.inputTextView.text;
    }
    
    NSString *string = nil;
    NSInteger stringLength = inputString.length;
    if (stringLength > 0) {
        if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {
            if ([inputString rangeOfString:@"["].location == NSNotFound){
                string = [inputString substringToIndex:stringLength - 1];
            } else {
                string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
            }
        } else {
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    self.inputTextField.text = string;
    self.inputTextView.text = string;
    if (self.inputTextView) {
        [self.inputTextView.delegate textViewDidChange:self.inputTextView];
    }
}

@end
