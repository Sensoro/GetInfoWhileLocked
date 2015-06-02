//
//  SENLocationManager.h
//  BeaconActive-ObjC
//
//  Created by skyming on 15/4/10.
//  Copyright (c) 2015年 Sensoro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SensoroBeaconKit/SensoroBeaconKit.h>

@interface SENLocationManager : NSObject

+ (instancetype)sharedInstance;
- (void)startMonitor:(BOOL)relaunch;
- (void)stopMonitor;

@end
