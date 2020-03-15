//
//  LoginInfo.h
//  RenrenTong
//
//  Created by jeffrey on 14-5-26.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LoginInfo : NSManagedObject

@property (nonatomic, retain) NSString * blogAddress;
@property (nonatomic, retain) NSNumber * bSaveLoginState;
@property (nonatomic, retain) NSString * classId;
@property (nonatomic, retain) NSNumber * integral;
@property (nonatomic, retain) NSString * loginTime;
@property (nonatomic, retain) NSString * publicProperty;
@property (nonatomic, retain) NSString * saveStateTime;
@property (nonatomic, retain) NSString * schoolId;
@property (nonatomic, retain) NSString * schoolName;
@property (nonatomic, retain) NSString * tokenId;
@property (nonatomic, retain) NSString * userAvatar;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * userName;
@property (nonatomic, retain) NSString * userRole;
@property (nonatomic, retain) NSString * account;

@end
