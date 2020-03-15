//
//  Activity.h
//  TableInTable
//
//  Created by jeffrey on 14-6-18.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchParser.h"

//Activity - weibo, blog and ablum
@interface Activity : NSObject <MatchParserDelegate>
{
    __weak MatchParser* _match;
}

//for common activity
@property (nonatomic, strong) NSString *activityId;
@property (nonatomic, strong) NSString *activityBody;
@property (nonatomic, assign) int      activityType;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *imageUrl; //avatar
@property (nonatomic, strong) NSString *userName;

@property (nonatomic, assign) int      commentCount;
@property (nonatomic, strong) NSMutableArray *comments;
@property (nonatomic, assign) int      favoriteCount;
@property (nonatomic, assign) int      forwardCount;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, assign) BOOL     bFavorited;
@property (nonatomic, assign) BOOL     bForwarded;

@property (nonatomic, strong) NSString *time;

//for weibo
@property (nonatomic, strong) NSString *weiboId;
@property (nonatomic, strong) NSString *originalWeiboId;
@property (nonatomic, strong) NSString *forwardedWeiboId;

//for album
@property (nonatomic, strong) NSString *albumId;
@property (nonatomic, strong) NSArray  *images;

//for blog
@property (nonatomic, strong) NSString *blogId;
@property (nonatomic, strong) NSString *title;


@property(nonatomic, assign) BOOL willDisplay;

@property (nonatomic, assign) BOOL bExpand;

//Match parse delegate
@property(nonatomic,weak,getter =getMatch) MatchParser * match;

-(MatchParser*)createMatch:(float)width;

-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link;

-(void)setMatch;

+(NSCache*)shareCacheForActivity;

@end
