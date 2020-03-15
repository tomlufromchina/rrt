//
//  Advert.h
//  RenrenTong
//
//  Created by 符其彬 on 14/12/24.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Advert : NSObject
+(Advert*)shareAdvert;
//从网络下载图片(登录)
-(void) getImageFromURL:(NSString *)fileURL;
//从网络下载图片(首页)
-(void) getImageFromURL1:(NSString *)fileURL;
//将所下载的图片保存到本地
- (void)saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath;
@end
