//
//  GrayPageControl.m
//
//  Created by blue on 12-9-28.
//  Copyright (c) 2012年 blue. All rights reserved.
//  Email - 360511404@qq.com
//  http://github.com/bluemood
//

#import "GrayPageControl.h"
@implementation GrayPageControl
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setCurrentPage:0];
    
    self.pageIndicatorTintColor = [UIColor grayColor];
    self.currentPageIndicatorTintColor = [UIColor blackColor];
    
    return self;
}

- (id)initWithFrame:(CGRect)aFrame {
    
	if (self = [super initWithFrame:aFrame]) {
        [self setCurrentPage:0];
        
        self.pageIndicatorTintColor = [UIColor grayColor];
        self.currentPageIndicatorTintColor = [UIColor blackColor];
    }
	
	return self;
}

-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
}

@end