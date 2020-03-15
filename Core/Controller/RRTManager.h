//
//  RRTManager.h
//  RenrenTong
//
//  Created by jeffrey on 14-5-21.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectsEntity.h"
#import "LoginManager.h"

@interface RRTManager : NSObject

@property(nonatomic, strong) LoginManager *loginManager;

+ (instancetype)manager;

//Login




@end
