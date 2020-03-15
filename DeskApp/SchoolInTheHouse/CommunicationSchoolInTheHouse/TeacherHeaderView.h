//
//  TeacherHeaderView.h
//  RenrenTong
//
//  Created by aedu on 15/2/4.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TeacherHeaderViewDelegate <NSObject>

- (void)didClickButton:(UIButton *)button;

@end

@interface TeacherHeaderView : UIView
@property (nonatomic, weak) id<TeacherHeaderViewDelegate> delegate;

@end
