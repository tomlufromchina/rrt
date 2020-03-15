//
//  LoginManager.m
//  RenrenTong
//
//  Created by jeffrey on 14-6-9.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "LoginManager.h"
#import "SSKeychain.h"

@implementation LoginManager
@synthesize loginInfo = _loginInfo;

#pragma mark - Login
#pragma mark -
- (void)setLoginInfo:(Login *)loginInfo
{
    _loginInfo = loginInfo;
    
    [DataManager addLoginUser:_loginInfo];
    
    [SSKeychain setPassword:loginInfo.password
                 forService:KEYCHAIN_SERVICE
                    account:loginInfo.userId];
}

- (Login*)loginInfo
{
    if (!_loginInfo) {
        _loginInfo = [DataManager lastLoginUser];
        
        _loginInfo.password = [SSKeychain passwordForService:KEYCHAIN_SERVICE
                                                     account:_loginInfo.userId];
    }
    
    return _loginInfo;
}

- (void)logout
{
    if (self.loginInfo) {
        if (self.loginInfo.userId) {
            [SSKeychain deletePasswordForService:KEYCHAIN_SERVICE account:self.loginInfo.userId];
            self.loginInfo.password = nil;
        }
    }
}

@end
