//
//  DoodleViewController.h
//  RenrenTong
//
//  Created by 唐彬 on 14-10-16.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyView.h"
#import "ToolView.h"
#import "KZColorPicker.h"
#import "AttendAlertView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DoodleToolImageView.h"

@protocol KZDefaultColorControllerDelegate;
@protocol DoodleDelegate
@required
- (void)DoodleWithUIImage:(UIImage*)img;
@end
@interface DoodleViewController : BaseViewController<AttendAlertViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,DoodleToolImageViewDelegate>{
    MyView *pintView;
    BOOL eraser;
    NSMutableArray* drawimgs;
}
@property(nonatomic, assign) id<KZDefaultColorControllerDelegate> delegate;
@property(nonatomic, retain) UIColor *selectedColor;
@property(nonatomic,assign,readwrite)id<DoodleDelegate> doodledelegate;
@end

@protocol KZDefaultColorControllerDelegate
- (void) defaultColorController:(DoodleViewController *)controller didChangeColor:(UIColor *)color;
@end


