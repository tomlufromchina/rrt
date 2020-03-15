//
//  AboutMeViewController.h
//  RenrenTong
//
//  Created by 符其彬 on 14/12/5.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "BaseViewController.h"
#import "GuardianViewController.h"
#import "TheTeacherViewController.h"
#import "StudiesStirsViewController.h"
#import "CurrentTeacherViewController.h"
#import "CurrentGuarDianViewController.h"
#import "CurrentStudiesViewController.h"
#import "Advert.h"
#import "AppDelegate.h"

@interface AboutMeViewController : BaseViewController{
    BOOL isOpenAdvert;
    NSString* adverturl;
}

@end
