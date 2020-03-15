//
//  Comment.m
//  TableInTable
//
//  Created by jeffrey on 14-6-24.
//  Copyright (c) 2014年 ___AEDU___. All rights reserved.
//

#import "Comment.h"

@implementation Comment

+(NSCache*)shareCacheForComment;
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
        NSString *key=[NSString stringWithFormat:@"%@:content=%@",
                       self.commentId, self.commentBody];
        MatchParser *parser=[[Comment shareCacheForComment] objectForKey:key];
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
            MatchParser *parser=[self createMatch:270];
            if (parser) {
                [[Comment shareCacheForComment]  setObject:parser forKey:key];
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
        NSString *key=[NSString stringWithFormat:@"%@:content=%@",
                       self.commentId, self.commentBody];
        MatchParser *parser=[[Comment shareCacheForComment] objectForKey:key];
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
                MatchParser*parser=[self createMatch:270];
                if (parser) {
                    _match = parser;
                    [[Comment shareCacheForComment]  setObject:parser forKey:key];
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
        NSString *key=[NSString stringWithFormat:@"%@:content=%@",
                       self.commentId, self.commentBody];
        MatchParser *parser=[[Comment shareCacheForComment] objectForKey:key];
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
            MatchParser* parser=[self createMatch:270];
            if (parser) {
                [[Comment shareCacheForComment]  setObject:parser forKey:key];
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
    parser.numberOfLimitLines = 0;
    parser.font = [UIFont systemFontOfSize:11.0f];
    //    self.numberOfLineLimit=5;
    
    NSString *title = @"大黑回复小黑：";
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:title];
    [str addAttribute:NSForegroundColorAttributeName value:appColor range:NSMakeRange(0,2)];
    [str addAttribute:NSForegroundColorAttributeName value:appColor range:NSMakeRange(4,2)];
    
    
    [parser match:self.commentBody
       atCallBack:^BOOL(NSString * string) {
           return NO;
       }
            title:str];
    
//    [parser match:self.commentBody atCallBack:^BOOL(NSString * string) {
//        //        NSString *partInStr;
//        //        if (![tMans isKindOfClass:[NSString class]]) {
//        //            partInStr = [tMans JSONString];
//        //        } else {
//        //            partInStr = (NSString*)tMans;
//        //        }
//        return NO;
//    }];
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
    [_match match:self.commentBody atCallBack:^BOOL(NSString * string) {
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
