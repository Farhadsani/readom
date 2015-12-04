//
//  AudioManager.cpp
//  qmap
//
//  Created by 石头人6号机 on 15/4/16.
//
//

#include "AudioManager_ios.h"
#include "AudioManager.h"

//void AudioManager::initAudio()
//{
//    delegate = [AudioDelegate alloc];
//    NSDictionary *setting = [NSDictionary dictionaryWithObjectsAndKeys:
//                             [NSNumber numberWithInt:AVAudioQualityLow],AVEncoderAudioQualityKey,
//                             [NSNumber numberWithInt:16],AVEncoderBitRateKey,
//                             [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
//                             [NSNumber numberWithFloat:44100.0],AVSampleRateKey,
//                             nil];
//    //录音文件保存地址的URL
//    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/record.caf", [[NSBundle mainBundle] resourcePath]]];
//    NSError *error = nil;
//    audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:setting error:&error];
//    
//    if (error != nil) {
//        InfoLog(@"Init audioRecorder error: %@",error);
//    }else{
//        //准备就绪，等待录音，注意该方法会返回Boolean，最好做个成功判断，因为其失败的时候无任何错误信息抛出
//        if ([audioRecorder prepareToRecord]) {
//            InfoLog(@"Prepare successful");
//        }
//    }
//}
//
//void AudioManager::startRecord()
//{
//    [audioRecorder record];
//}
//
//void AudioManager::stopRecord()
//{
//    [audioRecorder stop];
//}
//
//void AudioManager::stopPlay()
//{
//    
//}
//
//void AudioManager::startPlay()
//{
//    NSError *error;
//    InfoLog(@"%@", audioRecorder.url);
//    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioRecorder.url error:&error];
//    audioPlayer.delegate = delegate;
//    if (error != nil) {
//        InfoLog(@"Wrong init player:%@", error);
//    }else{
//        [audioPlayer play];
//    }
////    [playButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
//}
//


@implementation AudioManager_ios

-(void)initAudio
{
    
}


#pragma mark audio delegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    InfoLog(@"Finsh playing");
//    self.recordButton.hidden = NO;
//    [self.playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    
}

-(void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    InfoLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    InfoLog(@"Finish record!");
}

-(void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    InfoLog(@"Encode Error occurred");
}

@end