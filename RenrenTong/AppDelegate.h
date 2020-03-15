//
//  AppDelegate.h
//  RenrenTong
//
//  Created by jeffrey on 14-5-15.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectsEntity.h"
#import "Reachability.h"
#import "ASIFormDataRequest.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>{
    NSMutableArray* synmsg;
    NSTimer *timer;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Reachability *hostReach;
@property (nonatomic, assign) BOOL isReachable;
@property(nonatomic, strong)ASIFormDataRequest *request;

@end
