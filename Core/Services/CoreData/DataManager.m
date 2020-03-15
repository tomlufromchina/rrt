//
//  DataManager.m
//  nextSing
//
//  Created by iflytek-liukai on 14-3-12.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "DataManager.h"
#import "CoreData+MagicalRecord.h"
#import "LoginInfo.h"
#import "ContactInfo.h"


@interface DataManager ()


+ (void)transformLogin:(Login*)login toLoginInfo:(LoginInfo*)loginInfo;
+ (void)transformLoginInfo:(LoginInfo*)loginInfo toLogin:(Login*)login;

+ (void)transformContact:(Contact*)contact toContactInfo:(ContactInfo*)contactInfo;
+ (void)transformContactInfo:(ContactInfo*)contactInfo toContact:(Contact*)contact;

@end

@implementation DataManager

+(NSDate*) convertDateFromString:(NSString*)uiDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *date=[formatter dateFromString:uiDate];
    return date;
}


#pragma mark - set up the database file
#pragma mark -
+ (void)setUpCoreDataStack
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"RenrenTong.sqlite"];
}


#pragma mark - Login for LoginInfo
#pragma mark -
+ (void)addLoginUser:(Login *)login
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    NSString *key = @"userId";
    LoginInfo *loginInfo = [LoginInfo MR_findFirstByAttribute:key withValue:login.userId];
    if (loginInfo) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",
                                  [NSString stringWithFormat:@"%@", login.userId]];
        [LoginInfo MR_deleteAllMatchingPredicate:predicate inContext:context];
    }
    
    loginInfo = [LoginInfo MR_createInContext:context];
    
    [self transformLogin:login toLoginInfo:loginInfo];
    
    
    [context MR_saveToPersistentStoreAndWait];
    
}

+ (void)deleteLoginUser:(NSString*)userId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@",
                              userId];

    // Remove the person
    [LoginInfo MR_deleteAllMatchingPredicate:predicate inContext:context];
    
    [context MR_saveToPersistentStoreAndWait];
}

+ (void)deleteAllLoginUsers
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    [LoginInfo MR_deleteAllMatchingPredicate:nil inContext:context];
    
    [context MR_saveToPersistentStoreAndWait];
}

+ (Login*)lastLoginUser
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    LoginInfo *loginInfo = [LoginInfo MR_findFirstOrderedByAttribute:@"loginTime"
                                                      ascending:NO
                                                      inContext:context];
    
    Login *login = nil;
    if (loginInfo) {
        login = [[Login alloc] init];
        [self transformLoginInfo:loginInfo toLogin:login];
    }
    
    return login;
}


#pragma mark - Contact -- ContactInfo
#pragma mark -
+ (void)addContacts:(NSArray*)contacts
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    for (NSArray *subContacts in contacts) {
        for (Contact *contact in subContacts) {
            NSPredicate *pre = [NSPredicate predicateWithFormat:
                                      @"(contactId == %@ && belonger == %@)",
                                contact.contactId, [RRTManager manager].loginManager.loginInfo.userId];
            
            
            ContactInfo *contactInfo = [ContactInfo MR_findFirstWithPredicate:pre inContext:context];
            
            if (contactInfo) {
                [contactInfo MR_deleteInContext:context];
            }
            
            contactInfo = [ContactInfo MR_createInContext:context];
            
            [self transformContact:contact toContactInfo:contactInfo];
        }
    }

    [context MR_saveToPersistentStoreAndWait];
}

+ (Contact*)contactForId:(NSString*)contactId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:
                        @"(contactId == %@ && belonger == %@)",
                        contactId, [RRTManager manager].loginManager.loginInfo.userId];
    
    
    ContactInfo *contactInfo = [ContactInfo MR_findFirstWithPredicate:pre inContext:context];
    
    Contact *contact = nil;
    if (contactInfo) {
        contact = [[Contact alloc] init];
        [self transformContactInfo:contactInfo toContact:contact];
    }
    
    return contact;
}

+ (void)deleteContact:(NSString*)contactId
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:
                        @"(contactId == %@ && belonger == %@)",
                        contactId, [RRTManager manager].loginManager.loginInfo.userId];
    
    ContactInfo *contactInfo = [ContactInfo MR_findFirstWithPredicate:pre inContext:context];
    
    if (contactInfo) {
        [contactInfo MR_deleteInContext:context];
        [context MR_saveToPersistentStoreAndWait];
    }
}

+ (NSArray*)allContacts
{
    NSMutableArray *contacts = [NSMutableArray array];
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    
    NSPredicate *pre = [NSPredicate predicateWithFormat:
                        @"belonger == %@", [RRTManager manager].loginManager.loginInfo.userId];

    NSArray *contactInfos = [ContactInfo MR_findAllWithPredicate:pre inContext:context];
    int count = [contactInfos count];
    for (int i = 0; i < count; i++) {
        ContactInfo *contactInfo = (ContactInfo*)[contactInfos objectAtIndex:i];

        Contact *contact = [[Contact alloc] init];
        [self transformContactInfo:contactInfo toContact:contact];
        
        [contacts addObject:contact];
    }

    return contacts;
}









#pragma mark - ubility
#pragma mark -
+ (void)transformLogin:(Login*)login toLoginInfo:(LoginInfo*)loginInfo
{
    loginInfo.userId = [NSString stringWithFormat:@"%@", login.userId];
    loginInfo.tokenId = [NSString stringWithFormat:@"%@", login.tokenId];
    loginInfo.userAvatar = [NSString stringWithFormat:@"%@", login.userAvatar];
    loginInfo.userName = [NSString stringWithFormat:@"%@", login.userName];
    loginInfo.userRole = [NSString stringWithFormat:@"%@", login.userRole];
    
    loginInfo.blogAddress = [NSString stringWithFormat:@"%@", login.blogAddress];
    loginInfo.classId = [NSString stringWithFormat:@"%@", login.classId];
    loginInfo.schoolId = [NSString stringWithFormat:@"%@", login.schoolId];
    loginInfo.schoolName = [NSString stringWithFormat:@"%@", login.schoolName];
    
    loginInfo.integral = [NSNumber numberWithInt:login.integral];
    loginInfo.bSaveLoginState = [NSNumber numberWithBool:login.bSaveLoginState];
    loginInfo.publicProperty = [NSString stringWithFormat:@"%@", login.publicProperty];
    loginInfo.loginTime = [NSString stringWithFormat:@"%@", login.loginTime];
    loginInfo.saveStateTime = [NSString stringWithFormat:@"%@", login.saveStateTime];
    
    loginInfo.account = [NSString stringWithFormat:@"%@", login.account];
}

+ (void)transformLoginInfo:(LoginInfo*)loginInfo toLogin:(Login*)login
{
    login.userId = loginInfo.userId;
    login.tokenId = loginInfo.tokenId;
    login.userAvatar = loginInfo.userAvatar;
    login.userName = loginInfo.userName;
    login.userRole = loginInfo.userRole;
    
    login.blogAddress = loginInfo.blogAddress;
    login.classId = loginInfo.classId;
    login.schoolId = loginInfo.schoolId;
    login.schoolName = loginInfo.schoolName;
    
    login.integral = [loginInfo.integral intValue];
    login.bSaveLoginState = [loginInfo.bSaveLoginState boolValue];
    login.publicProperty = loginInfo.publicProperty;
    
    login.loginTime = loginInfo.loginTime;

    login.saveStateTime = loginInfo.saveStateTime;
    
    login.account = loginInfo.account;
}

+ (void)transformContact:(Contact*)contact toContactInfo:(ContactInfo*)contactInfo
{
    contactInfo.contactId = [NSString stringWithFormat:@"%@", contact.contactId];
    contactInfo.name = [NSString stringWithFormat:@"%@", contact.name];
    contactInfo.avatar = [NSString stringWithFormat:@"%@", contact.avatarUrl];
    contactInfo.py = [NSString stringWithFormat:@"%@", contact.py];
    contactInfo.type = [NSNumber numberWithInt:[contact.objType intValue]];
    contactInfo.belonger = [NSString stringWithFormat:@"%@", [RRTManager manager].loginManager.loginInfo.userId];
}

+ (void)transformContactInfo:(ContactInfo*)contactInfo toContact:(Contact*)contact
{
    contact.contactId = contactInfo.contactId;
    contact.name = contactInfo.name;
    contact.avatarUrl = contactInfo.avatar;
    contact.py = contactInfo.py;
    contact.objType = [NSString stringWithFormat:@"%d", [contactInfo.type intValue]];
}


@end
