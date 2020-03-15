//
//  NetWorkManager+Attend.h
//  RenrenTong
//
//  Created by 符其彬 on 14-9-25.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkManager (Attend)

#pragma mark - 平安考勤首页（老师）
#pragma mark -

- (void)getCheckingOfTearchs:(NSString *)masterid
                     success:(void(^)(NSMutableArray* data))successBlock
                      failed:(void(^)(NSString *errorMSG))failedBlock;
@end
