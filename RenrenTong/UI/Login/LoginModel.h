//
//  LoginModel.h
//  RenrenTong
//
//  Created by 符其彬 on 15/5/18.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "JSONModel.h"


@interface LoginModelMsgss : JSONModel

@property (nonatomic,strong) NSString <Optional>*Id;
@property (nonatomic,strong) NSString <Optional>*UserRole;
@property (nonatomic,strong) NSString <Optional>*UserName;
@property (nonatomic,strong) NSString <Optional>*UserFace;
@property (nonatomic,strong) NSString <Optional>*Token;
@property (nonatomic,strong) NSString <Optional>*BlogAddress;
@property (nonatomic,strong) NSString <Optional>*LoginTime;
@property (nonatomic,strong) NSString <Optional>*IsSaveLoginState;
@property (nonatomic,strong) NSString <Optional>*SaveStateTime;
@property (nonatomic,strong) NSString <Optional>*PublicProperty;
@property (nonatomic,strong) NSString <Optional>*Integral;
@property (nonatomic,strong) NSString <Optional>*SchoolId;
@property (nonatomic,strong) NSString <Optional>*SchoolName;
@property (nonatomic,strong) NSString <Optional>*ClassId;

@end

@interface LoginModels : JSONModel

@property (nonatomic,assign) NSInteger status;
@property (nonatomic, strong) LoginModelMsgss <Optional>*msg;

@end
