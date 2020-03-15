//
//  ISingHTTPRequestOperationManager.h
//  nextSing
//
//  Created by nannan liu on 14-3-20.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
@interface ISingHTTPRequestOperationManager : AFHTTPRequestOperationManager

///------------------------------------
/// @name Storing the request url
///------------------------------------

/**
 用于请求的url，可以从外部修改.
 */
@property(readwrite, nonatomic, strong) NSString *requestURLString;

///------------------------------------
/// @name the request body
///------------------------------------

/**
 请求的body,未加密，未压缩，后续封装会对其自动进行加密并且压缩，如果不需要压缩或者加密，可以设置相关属性
 */
@property(readwrite, nonatomic, strong) NSData *afHttpBody;

///------------------------------------
/// @name need compress the request body or not ,default is YES.
///------------------------------------

/**
 request body 是否需要压缩,默认是YES
 */
@property(readwrite, nonatomic, assign) BOOL shouldCompressRequestBody;

///------------------------------------
/// @name need desencrypt the request body or not , default is YES.
///------------------------------------

/**
 request body是否需要加密，默认是YES
 */
@property(readwrite, nonatomic, assign) BOOL shouldDesEncrypt;

///---------------------------------------------
/// @name Creating and Initializing HTTP Clients
///---------------------------------------------

/**
 Creates and returns an `ISingHTTPRequestOperationManager` object.
 */
+ (instancetype)getManager;

/**
 Initializes an `ISingHTTPRequestOperationManager` object with the specified base URL.
 
 This is the designated initializer.
 
 @param url The base URL for the HTTP client.
 
 @return The newly-initialized HTTP client
 */
- (instancetype)initWithBaseURL:(NSURL *)url;

- (instancetype)init;
@end
