//
//  Comment.h
//  TableInTable
//
//  Created by jeffrey on 14-6-24.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MatchParser.h"

@interface Comment : NSObject <MatchParserDelegate>
{
    __weak MatchParser* _match;
}

@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, strong) NSString *commentBody;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *avatarUrl; //avatar
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSDate   *time;

@property(nonatomic, assign) BOOL willDisplay;

//Match parse delegate
@property(nonatomic,weak,getter =getMatch) MatchParser * match;

-(MatchParser*)createMatch:(float)width;

-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link;

-(void)setMatch;

+(NSCache*)shareCacheForComment;

@end
