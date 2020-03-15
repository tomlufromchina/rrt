//
//  DataManager.h
//  nextSing
//
//  Created by iflytek-liukai on 14-3-12.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Login;
@class Contact;

@interface DataManager : NSObject

#pragma mark - set up the database file
#pragma mark -
+ (void)setUpCoreDataStack;


#pragma mark - Login -- LoginInfo
#pragma mark -
+ (void)addLoginUser:(Login *)login;
+ (void)deleteLoginUser:(NSString*)userId;
+ (void)deleteAllLoginUsers;
+ (Login*)lastLoginUser;

#pragma mark - Contact -- ContactInfo
#pragma mark -
+ (void)addContacts:(NSArray*)contacts;
+ (Contact*)contactForId:(NSString*)contactId;
+ (NSArray*)allContacts;
+ (void)deleteContact:(NSString*)contactId;


@end
