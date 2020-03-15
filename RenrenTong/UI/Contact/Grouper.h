//
//  Grouper.h
//  RenrenTong
//
//  Created by aedu on 15/3/25.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Grouper : NSObject
@property(nonatomic, strong)NSString *UserId;
@property(nonatomic, assign)int UserRole;
@property(nonatomic, strong)NSString *UserName;
@property(nonatomic, strong)NSString *PinYin;
@property(nonatomic, strong)NSString *Photo;
@property(nonatomic, strong)NSString *SubjectName;
@end
