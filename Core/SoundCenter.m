//
//  SoundCenter.m
//  IM
//
//  Created by 唐彬 on 15-1-1.
//  Copyright (c) 2015年 唐彬. All rights reserved.
//

#import "SoundCenter.h"

@implementation SoundCenter
+(void) playSound
{
    SystemSoundID soundIDTest = 0;
    NSString * path = [[NSBundle mainBundle] pathForResource:@"msgTritone" ofType:@"caf"];
    if (path) {
        AudioServicesCreateSystemSoundID( (__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest );
    }
    AudioServicesPlaySystemSound( soundIDTest );
    //        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}
@end
