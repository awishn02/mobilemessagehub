//
//  main.m
//  messagehub
//
//  Created by Aaron Wishnick on 11/5/13.
//  Copyright (c) 2013 Aaron Wishnick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Pixate/Pixate.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        [Pixate licenseKey:@"QEEOC-BQKDK-UQ60D-570U7-7VIEM-Q2VV6-HSOLP-IUVI7-LS85R-N82DO-FIOLE-2K4N1-IQPCF-AP37L-4BMBJ-OK" forUser:@"aaronwishnick@gmail.com"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
