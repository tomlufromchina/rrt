//
//  NSString+NSStringAddition.h
//  iSing
//
//  Created by cui xiaoqian on 13-4-21.
//  Copyright (c) 2013年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

- (CGSize)calculateSize:(CGSize)maxSize font:(UIFont *)font;
- (CGSize)calculateSize:(UIFont *)font;

@end

@interface NSString (Empty)

//+ (NSString *) getStoryNameByUrl:(NSString*) url;

+ (BOOL) isEmptyOrNull:(NSString*) string;

+ (BOOL) notEmptyOrNull:(NSString*) string;

+ (NSString*) makeNode:(NSString*) str;

+ (BOOL)isMobileNumber:(NSString *)mobileNum;

+ (NSString *)trimString:(NSString *) str;

@end
