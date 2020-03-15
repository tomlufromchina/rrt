//
//  DoodleToolImageView.h
//  RenrenTong
//
//  Created by 唐彬 on 14-10-20.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyView.h"
@class DoodleToolImageView;
@protocol DoodleToolImageViewDelegate

- (void)changeLayerTopWithUIimage:(DoodleToolImageView*)img;
-(void) remveDtI:(DoodleToolImageView*)img;

@end
@interface DoodleToolImageView : UIImageView<UIGestureRecognizerDelegate>{
    CGPoint starpoint;
    UIView* toolview;
    BOOL lock;
    BOOL layer;
}
@property(nonatomic,readwrite,assign)MyView* pintview;
@property(nonatomic,readwrite,assign)id<DoodleToolImageViewDelegate> delegate;
-(void)addTopTool;
-(void)drawImg;
-(void)selfRemoveFromSuperview;
@end
