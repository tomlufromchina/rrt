//
//  CacheManager.h
//  RenrenTong
//
//  Created by jeffrey on 14-5-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (instancetype)manager;


- (void)saveActivity:(NSArray *)activities withType:(int)type withGroup:(int)group;
- (NSArray *)loadActivityOfType:(int)type withGroup:(int)group;

- (void)saveContact:(NSArray *)contacts withType:(int)type;
- (NSArray*)loadContactOfType:(int)type;

@end
