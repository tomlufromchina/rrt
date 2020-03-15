//
//  Plot.h
//  Plot
//
//  Created by 唐彬 on 14-12-8.
//  Copyright (c) 2014年 唐彬. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewExt.h"
@interface Plot : UIView{
   UIView* valview;
}
@property(nonatomic,readwrite)float plotvalue;
@property(nonatomic,readwrite,strong)UIColor* cl;
@end
