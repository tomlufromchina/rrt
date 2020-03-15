//
//  CacheManager.m
//  RenrenTong
//
//  Created by jeffrey on 14-5-22.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "CacheManager.h"

static CacheManager *instance = nil;

@implementation CacheManager

+ (instancetype)manager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CacheManager alloc] init];
    });
    
    return instance;
}

- (void)saveActivity:(NSArray *)activities withType:(int)type withGroup:(int)group
{
    if (activities && [activities count] > 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                             NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0];
        
        //create appCache directory
        NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:
                                 [NSString stringWithFormat:@"AppCache"]];
        [[NSFileManager defaultManager] createDirectoryAtPath:archivePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        
        archivePath = [archivePath stringByAppendingPathComponent:
                  [NSString stringWithFormat:@"activity_%d_%d.cache", type, group]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
            BOOL j = [[NSFileManager defaultManager] createFileAtPath:archivePath
                                                             contents:nil
                                                           attributes:nil];
            j++;
        }
        
        BOOL i = [NSKeyedArchiver archiveRootObject:activities toFile:archivePath];
        NSLog(@"The i is:%d", i);
    }
}

- (NSArray *)loadActivityOfType:(int)type withGroup:(int)group
{
    NSArray *array = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:
                 [NSString stringWithFormat:@"AppCache/activity_%d_%d.cache", type, group]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
        array = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    }

    return array;
}

- (void)saveContact:(NSArray *)contacts withType:(int)type
{
    if (contacts && [contacts count] > 0) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                             NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0];
        
        //create appCache directory
        NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:
                                 [NSString stringWithFormat:@"AppCache"]];
        [[NSFileManager defaultManager] createDirectoryAtPath:archivePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
        
        archivePath = [archivePath stringByAppendingPathComponent:
                       [NSString stringWithFormat:@"contact_%d.cache", type]];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
            BOOL j = [[NSFileManager defaultManager] createFileAtPath:archivePath
                                                             contents:nil
                                                           attributes:nil];
            j++;
        }
        
        BOOL i = [NSKeyedArchiver archiveRootObject:contacts toFile:archivePath];
        NSLog(@"The i is:%d", i);
    }
}
- (NSArray*)loadContactOfType:(int)type
{
    NSArray *array = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:
                             [NSString stringWithFormat:@"AppCache/contact_%d.cache", type]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
        array = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
    }
    
    return array;
}

@end
