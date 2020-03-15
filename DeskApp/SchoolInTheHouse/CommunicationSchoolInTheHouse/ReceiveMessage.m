//
//  ReceiveMessage.m
//  RenrenTong
//
//  Created by aedu on 15/3/6.
//  Copyright (c) 2015年 ___AEDU___. All rights reserved.
//

#import "ReceiveMessage.h"

@implementation ReceiveMessage
-(NSString *)description
{
    return [NSString stringWithFormat:@"%@,%@,%@,%@,%@",self.Audio,self.Pic,self.MessageContent,self.PubUser,self.PubTime];
}
@end
