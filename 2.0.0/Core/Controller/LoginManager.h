//
//  LoginManager.h
//  RenrenTong
//
//  Created by jeffrey on 14-6-9.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectsEntity.h"

@interface LoginManager : NSObject

@property(nonatomic, strong) Login *loginInfo;

- (void)logout;

@end
