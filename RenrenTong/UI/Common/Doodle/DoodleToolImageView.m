//
//  DoodleToolImageView.m
//  RenrenTong
//
//  Created by 唐彬 on 14-10-20.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "DoodleToolImageView.h"

@implementation DoodleToolImageView

-(instancetype)init{
    self=[super init];
    if (self) {
        
    }
    [self setUserInteractionEnabled:YES];
    lock=NO;
    layer=NO;
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scalePiece:)];
    [pinchGesture setDelegate:self];
    [self addGestureRecognizer:pinchGesture];
    return self;
    
}

-(void)addTopTool{
    toolview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 40*5, 30)];
    NSArray* toolbtnnomals=@[@"toolsunlock",@"toolsbringtofront",@"toolsstamp",@"toolstrash",@"toolssendtoback",@"toolslock"];
    for (int i=0; i<4; i++) {
        UIButton* toolbtn=[UIButton buttonWithType:UIButtonTypeCustom];
        int width=40;
        toolbtn.frame=CGRectMake(width*i+(width-30)*0.5, 0, 30, 30);
        [toolbtn setBackgroundImage:[UIImage imageNamed:[toolbtnnomals objectAtIndex:i]] forState:UIControlStateNormal];
        toolbtn.tag=i;
        [toolbtn addTarget:self action:@selector(toolbtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [toolview addSubview:toolbtn];
    }
    toolview.alpha=0;
    toolview.hidden=YES;
    
    [self.pintview addSubview:toolview];
}

-(void)toolbtnClick:(UIButton*)sender{
    switch (sender.tag) {
        case 0:
            lock=!lock;
            if (lock) {
                [sender setBackgroundImage:[UIImage imageNamed:@"toolslock"] forState:UIControlStateNormal];
            }else{
                [sender setBackgroundImage:[UIImage imageNamed:@"toolsunlock"] forState:UIControlStateNormal];
            }
            break;
        case 1:
            [self.pintview bringSubviewToFront:self];
            if (self.delegate) {
                [self.delegate changeLayerTopWithUIimage:self];
            }
            break;
        case 2:
            [self drawImg];
            break;
        case 3:
            if (self.delegate) {
                [self.delegate remveDtI:self];
            }
            [toolview removeFromSuperview];
            [self removeFromSuperview];
            break;
    }

}

-(void)drawImg{
    [self.pintview drawImg:self];
    [self removeFromSuperview];
    [toolview removeFromSuperview];
}

-(void)selfRemoveFromSuperview{
    [self removeFromSuperview];
    [toolview removeFromSuperview];
}

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *piece = gestureRecognizer.view;
        CGPoint locationInView = [gestureRecognizer locationInView:piece];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:piece.superview];
        
        piece.layer.anchorPoint = CGPointMake(locationInView.x / piece.bounds.size.width, locationInView.y / piece.bounds.size.height);
        piece.center = locationInSuperview;
    }
}

- (void)scalePiece:(UIPinchGestureRecognizer *)gestureRecognizer
{
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGFloat scale = [gestureRecognizer scale];
        
        self.left=(self.pintview.width-self.width)*0.5;
        self.top=(self.pintview.height-self.height)*0.5;
        if (self.width*scale>=self.pintview.width) {
            self.width=self.pintview.width;
        }else{
            self.width=self.width*scale;
        }
        if (self.height*scale>=self.pintview.height) {
            self.height=self.pintview.height;
        }else{
            self.height=self.height*scale;
        }
        toolview.top=self.top-30;
        toolview.left=self.left;
        
        if (toolview.top<=0) {
            [UIView animateWithDuration:0.5 animations:^{
                toolview.alpha=0;
            } completion:nil];
        }else{
            [self showToolAnim];
        }
        [gestureRecognizer setScale:1];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    if (lock) {
        return;
    }
    if ([touches count]==1) {
        UITouch *touch=[touches anyObject];
        starpoint=[touch locationInView:self];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{

}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{

}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (lock) {
        return;
    }
    if ([touches count]==1) {
        if (!CGPointEqualToPoint(starpoint, CGPointZero)) {
            UITouch *touch=[touches anyObject];
            CGPoint currentpoint=[touch locationInView:self];
            float offsetX=currentpoint.x-starpoint.x;
            float offsetY=currentpoint.y-starpoint.y;
            if (offsetX>0) {
                if (self.right>=self.pintview.width) {
                    self.right=self.pintview.width;
                }else{
                    self.right=self.right+offsetX;
                }
            }else{
                if (self.left+offsetX<=0) {
                    self.left=0;
                }else{
                    self.left=self.left+offsetX;
                }
            }
            if (offsetY>0) {
                if (self.bottom>=self.pintview.height) {
                    self.bottom=self.pintview.height;
                }else{
                    self.bottom=self.bottom+offsetY;
                }
            }else{
                if (self.top+offsetY<=0) {
                    toolview.alpha=0;
                    self.top=0;
                }else{
                    self.top=self.top+offsetY;
                }
            }
            toolview.top=self.top-30;
            toolview.left=self.left;
            
            if (toolview.top<=0) {
                [UIView animateWithDuration:0.5 animations:^{
                    toolview.alpha=0;
                } completion:nil];
            }else{
                [self showToolAnim];
            }
        }
    }
}



-(void)showToolAnim{
    [UIView animateWithDuration:0.5 animations:^{
        toolview.hidden=NO;
        toolview.alpha=1;
    } completion:nil];
}

@end
