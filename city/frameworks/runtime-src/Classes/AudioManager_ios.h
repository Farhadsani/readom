//
//  AudioManager.h
//  qmap
//
//  Created by 石头人6号机 on 15/4/16.
//
//

#ifndef __qmap__AudioManager__
#define __qmap__AudioManager__

#include <stdio.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>  

@interface AudioManager_ios : UIViewController<AVAudioPlayerDelegate,AVAudioRecorderDelegate>

@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

@end



#endif /* defined(__qmap__AudioManager__) */
