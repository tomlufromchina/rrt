//
//  Activity.m
//  TableInTable
//
//  Created by jeffrey on 14-6-18.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "Activity.h"

@implementation Activity

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.activityId       forKey:@"activityId"];
    [aCoder encodeObject:self.activityBody     forKey:@"activityBody"];
    [aCoder encodeObject:self.forwardedWeiboId forKey:@"forwardedWeiboId"];
    [aCoder encodeObject:self.from             forKey:@"from"];
    [aCoder encodeObject:self.weiboId          forKey:@"weiboId"];
    [aCoder encodeObject:self.originalWeiboId  forKey:@"originalWeiboId"];
    [aCoder encodeObject:self.time             forKey:@"time"];
    [aCoder encodeObject:self.userId           forKey:@"userId"];
    [aCoder encodeObject:self.imageUrl         forKey:@"imageUrl"];
    [aCoder encodeObject:self.userName         forKey:@"userName"];
    
    [aCoder encodeObject:[NSNumber numberWithInteger:self.activityType]  forKey:@"activityType"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.commentCount]  forKey:@"commentCount"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.favoriteCount] forKey:@"favoriteCount"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.forwardCount]  forKey:@"forwardCount"];
    
    [aCoder encodeObject:[NSNumber numberWithBool:self.bFavorited]  forKey:@"bFavorited"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.bForwarded]  forKey:@"bForwarded"];
    
    [aCoder encodeObject:self.albumId         forKey:@"albumId"];
    [aCoder encodeObject:self.images          forKey:@"images"];
    
    [aCoder encodeObject:self.blogId         forKey:@"BlogId"];
    [aCoder encodeObject:self.title          forKey:@"Title"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super init];
    if (self) {
        self.activityId       = [aDecoder decodeObjectForKey:@"activityId"];
        self.activityBody     = [aDecoder decodeObjectForKey:@"activityBody"];
        self.forwardedWeiboId = [aDecoder decodeObjectForKey:@"forwardedWeiboId"];
        self.from             = [aDecoder decodeObjectForKey:@"from"];
        self.weiboId          = [aDecoder decodeObjectForKey:@"weiboId"];
        self.originalWeiboId  = [aDecoder decodeObjectForKey:@"originalWeiboId"];
        self.time             = [aDecoder decodeObjectForKey:@"time"];
        self.userId           = [aDecoder decodeObjectForKey:@"userId"];
        self.imageUrl         = [aDecoder decodeObjectForKey:@"imageUrl"];
        self.userName         = [aDecoder decodeObjectForKey:@"userName"];
        
        self.activityType     = [[aDecoder decodeObjectForKey:@"activityType"] intValue];
        self.commentCount     = [[aDecoder decodeObjectForKey:@"commentCount"] intValue];
        self.favoriteCount    = [[aDecoder decodeObjectForKey:@"favoriteCount"] intValue];
        self.forwardCount     = [[aDecoder decodeObjectForKey:@"forwardCount"] intValue];
        
        self.bFavorited       = [[aDecoder decodeObjectForKey:@"bFavorited"] boolValue];
        self.bForwarded       = [[aDecoder decodeObjectForKey:@"bForwarded"] boolValue];
        
        self.albumId          = [aDecoder decodeObjectForKey:@"albumId"];
        self.images           = [aDecoder decodeObjectForKey:@"images"];
        
        self.blogId           = [aDecoder decodeObjectForKey:@"BlogId"];
        self.title            = [aDecoder decodeObjectForKey:@"Title"];
    }
    
    return self;
}


+(NSCache*)shareCacheForActivity;
{
    static NSCache * cache=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache=[[NSCache alloc]init];
        cache.totalCostLimit=0.1*1024*1024;
    });
    return cache;
}

-(MatchParser*)getMatch
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        _match.data=self;
        return _match;
    }else{
        NSString *key=[NSString stringWithFormat:@"%@:type=%d:content=%@",
                       self.activityId,self.activityType,self.activityBody];
        MatchParser *parser=[[Activity shareCacheForActivity] objectForKey:key];
        if (parser) {
            _match = parser;
//            self.height=parser.height;
//            self.heightOflimit=parser.heightOflimit;
//            self.miniWidth=parser.miniWidth;
//            self.numberOfLinesTotal=parser.numberOfTotalLines;
//            self.numberOfLineLimit=parser.numberOfLimitLines;
            parser.data = self;
//            if (_match.numberOfTotalLines>_match.numberOfLimitLines) {
//                self.shouldExtend=YES;
//            }else{
//                self.shouldExtend=NO;
//            }
            return parser;
        }else{
            MatchParser *parser=[self createMatch:250];
            if (parser) {
                [[Activity shareCacheForActivity]  setObject:parser forKey:key];
            }
            return parser;
        }
    }
}

-(MatchParser*)getMatch:(void(^)(MatchParser *parser,id data))complete data:(id)data
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        _match.data=self;
        return _match;
    }else{
        NSString *key=[NSString stringWithFormat:@"%@:type=%d:content=%@",
                       self.activityId,self.activityType,self.activityBody];
        MatchParser *parser=[[Activity shareCacheForActivity] objectForKey:key];
        if (parser) {
            _match = parser;
//            self.height=parser.height;
//            self.heightOflimit=parser.heightOflimit;
//            self.miniWidth=parser.miniWidth;
//            self.numberOfLinesTotal=parser.numberOfTotalLines;
//            self.numberOfLineLimit=parser.numberOfLimitLines;
            parser.data = self;
//            if (_match.numberOfTotalLines>_match.numberOfLimitLines) {
//                self.shouldExtend=YES;
//            }else{
//                self.shouldExtend=NO;
//            }
            return parser;
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                MatchParser*parser=[self createMatch:250];
                if (parser) {
                    _match = parser;
                    [[Activity shareCacheForActivity]  setObject:parser forKey:key];
                    if (complete) {
                        complete(parser,data);
                    }
                }
            });
            return nil;
        }
    }
}

-(void)setMatch
{
    if (_match&&[_match isKindOfClass:[MatchParser class]]) {
        _match.data=self;
        return;
    }else{
        NSString *key=[NSString stringWithFormat:@"%@:type=%d:content=%@",
                       self.activityId,self.activityType,self.activityBody];
        MatchParser *parser=[[Activity shareCacheForActivity] objectForKey:key];
        if (parser) {
            _match = parser;
//            self.height=parser.height;
//            self.heightOflimit=parser.heightOflimit;
//            self.miniWidth=parser.miniWidth;
//            self.numberOfLinesTotal=parser.numberOfTotalLines;
//            self.numberOfLineLimit=parser.numberOfLimitLines;
            parser.data = self;
//            if (_match.numberOfTotalLines>_match.numberOfLimitLines) {
//                self.shouldExtend=YES;
//            }else{
//                self.shouldExtend=NO;
//            }
            parser.data=self;
        }else{
            MatchParser* parser=[self createMatch:250];
            if (parser) {
                [[Activity shareCacheForActivity]  setObject:parser forKey:key];
            }
        }
    }
}

-(void)setMatch:(MatchParser *)match
{
    _match=match;
}

-(MatchParser*)createMatch:(float)width
{
    MatchParser * parser=[[MatchParser alloc]init];
    parser.keyWorkColor=[UIColor blueColor];
    parser.width=width;
    parser.numberOfLimitLines=5;
//    self.numberOfLineLimit=5;
    parser.font = [UIFont systemFontOfSize:12.0f];
    
    if (self.activityType == Activity_Type_Blog) {//日志，有title
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:appColor,
                              NSForegroundColorAttributeName, nil];
        NSAttributedString *title = self.title ?
        [[NSAttributedString alloc] initWithString:self.title attributes:dict] :
        nil;
        
        [parser match:self.activityBody
           atCallBack:^BOOL(NSString * string) {
               return NO;
           }
                title:title];
    } else {

    [parser match:self.activityBody atCallBack:^BOOL(NSString * string) {
//        NSString *partInStr;
//        if (![tMans isKindOfClass:[NSString class]]) {
//            partInStr = [tMans JSONString];
//        } else {
//            partInStr = (NSString*)tMans;
//        }
        return NO;
    }];
    }
    _match=parser;
//    self.height=_match.height;
//    self.heightOflimit=parser.heightOflimit;
//    self.miniWidth=parser.miniWidth;
//    self.numberOfLinesTotal=parser.numberOfTotalLines;
    parser.data=self;
//    if (_match.numberOfTotalLines>_match.numberOfLimitLines) {
//        self.shouldExtend=YES;
//    }else{
//        self.shouldExtend=NO;
//    }
    return parser;
}
-(void)updateMatch:(void(^)(NSMutableAttributedString * string, NSRange range))link
{
    [_match match:self.activityBody atCallBack:^BOOL(NSString * string) {
//        NSString *partInStr;
//        if (![tMans isKindOfClass:[NSString class]]) {
//            partInStr = [tMans JSONString];
//        } else {
//            partInStr = (NSString*)tMans;
//        }
        return NO;
    } title:nil link:link];
}

@end

