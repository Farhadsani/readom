//
//  main.m
//  HelloLua
//
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[]) {
    @try {
        NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
        int retVal = UIApplicationMain(argc, argv, nil, @"AppController");
        [pool release];
        return retVal;
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
    
}
