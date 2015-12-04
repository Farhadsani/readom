//
//  AudioManager.h
//  qmap
//
//  Created by 石头人6号机 on 15/4/17.
//
//

#ifndef qmap_AudioManager_h
#define qmap_AudioManager_h

#import <AVFoundation/AVFoundation.h>  

class AudioManager  //: UIViewController<AVAudioPlayerDelegate, AVAudioRecorderDelegate>
{
public:
    void initAudio();
    void startRecord();
    void stopRecord();
    void startPlay();
    void stopPlay();
};

#endif
