//
//  StartView.h
//  RenrenTong
//
//  Created by 符其彬 on 15/4/20.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StartView;
@protocol StartViewDelegate <NSObject>

- (void)clickTheImages;
@end

@interface StartView : UIView<UIScrollViewDelegate>
@property(nonatomic, strong)NSArray *picArray;
@property (weak, nonatomic)  UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, weak) id<StartViewDelegate> delegate;

@end
