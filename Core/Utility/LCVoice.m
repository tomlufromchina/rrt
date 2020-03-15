//
//  LCVoice.m
//  LCVoiceHud
//
//  Created by 郭历成 on 13-6-21.
//  Contact titm@tom.com
//  Copyright (c) 2013年 Wuxiantai Developer Team.(http://www.wuxiantai.com) All rights reserved.
//

#import "LCVoice.h"
#import "LCVoiceHud.h"
#import <AVFoundation/AVFoundation.h>

#pragma mark - <DEFINES>

#define WAVE_UPDATE_FREQUENCY   0.05

#pragma mark - <CLASS> LCVoice

@interface LCVoice () <AVAudioRecorderDelegate>
{
    NSTimer * timer_;
    
    LCVoiceHud * voiceHud_;
    NSMutableArray *_theRecord;
}

@property(nonatomic,retain) AVAudioRecorder * recorder;

@end

@implementation LCVoice

#pragma mark - Publick Function

-(void)startRecordWithPath:(NSString *)path
{    
    NSError * err = nil;
    
	AVAudioSession *audioSession = [AVAudioSession sharedInstance];
	[audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    
	if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
	}
    
	[audioSession setActive:YES error:&err];
    
	err = nil;
	if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
	}
	
	NSMutableDictionary * recordSetting = [NSMutableDictionary dictionary];
    
    
    [recordSetting setObject:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey: AVFormatIDKey];
    [recordSetting setObject:[NSNumber numberWithFloat:8000.0] forKey: AVSampleRateKey];
    [recordSetting setObject:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    [recordSetting setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setObject:[NSNumber numberWithInt:AVAudioQualityMedium]
                        forKey: AVEncoderAudioQualityKey];
	
    
	self.recordPath = path;
    
	NSURL * url = [NSURL fileURLWithPath:self.recordPath];
	
	err = nil;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([fm fileExistsAtPath:path]) {
        
        NSData * audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
        
        if(audioData)
        {
            [fm removeItemAtPath:[url path] error:&err];
        }
    }
	
	err = nil;
    
    if(self.recorder){
        [self.recorder stop];
        self.recorder = nil;
    }
    
	self.recorder = [[[AVAudioRecorder alloc] initWithURL:url settings:recordSetting error:&err] autorelease];
    
	if(!_recorder){
        NSLog(@"recorder: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle: @"无法录音"
								   message: [err localizedDescription]
								  delegate: nil
						 cancelButtonTitle: @"知道了"
						 otherButtonTitles:nil];
        [alert show];
        return;
	}
	
	[_recorder setDelegate:self];
	[_recorder prepareToRecord];
	_recorder.meteringEnabled = YES;
	
	BOOL audioHWAvailable = audioSession.isInputAvailable;
	if (! audioHWAvailable) {
        UIAlertView *cantRecordAlert =
        [[UIAlertView alloc] initWithTitle: @"无法录音"
								   message: @"请在iPhone的\"设置-隐私-麦克风\"选项中，允许人人通访问你的手机麦克风"
								  delegate: nil
						 cancelButtonTitle: @"知道了"
						 otherButtonTitles:nil];
        [cantRecordAlert show];
        return;
	}
	
	[_recorder recordForDuration:(NSTimeInterval) 60];
    
    self.recordTime = 0;
    [self resetTimer];
    
	timer_ = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    
    [self showVoiceHudOrHide:YES];
}

-(void) stopRecordWithCompletionBlock:(void (^)())completion
{    
    dispatch_async(dispatch_get_main_queue(),completion);

    [self resetTimer];
    [self showVoiceHudOrHide:NO];
}

#pragma mark - Timer Update

- (void)updateMeters {
    
    self.recordTime += WAVE_UPDATE_FREQUENCY;
    
    if (voiceHud_)
    {
        /*  发送updateMeters消息来刷新平均和峰值功率。
         *  此计数是以对数刻度计量的，-160表示完全安静，
         *  0表示最大输入值
         */
        
        if (_recorder) {
            [_recorder updateMeters];
        }
    
        float peakPower = [_recorder averagePowerForChannel:0];
        double ALPHA = 0.05;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
    
        [voiceHud_ setProgress:peakPowerForChannel];
    }
}

#pragma mark - Helper Function

-(void) showVoiceHudOrHide:(BOOL)yesOrNo{
    
    if (voiceHud_) {
        [voiceHud_ hide];
        voiceHud_ = nil;
    }
    
    if (yesOrNo) {
        
        voiceHud_ = [[LCVoiceHud alloc] init];
        [voiceHud_ show];
        [voiceHud_ release];
        
    }else{
        
    }
}

-(void) resetTimer
{    
    if (timer_) {
        [timer_ invalidate];
        timer_ = nil;
    }
}

-(void) cancelRecording
{
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;    
}

- (void)cancelled {
    
    [self showVoiceHudOrHide:NO];
    [self resetTimer];
    [self cancelRecording];
}

#pragma mark - LCVoiceHud Delegate

-(void) LCVoiceHudCancelAction
{
    [self cancelled];
}

@end
