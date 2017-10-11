//
//  SENLocationManager.m
//  BeaconActive-ObjC
//
//  Created by skyming on 15/4/10.
//  Copyright (c) 2015年 Sensoro. All rights reserved.
//

#import "SENLocationManager.h"
#import <UIKit/UIKit.h>

//#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define ALL_COUNT 20

@interface SENLocationManager ()<SBKBeaconManagerDelegate>{
}

@property (nonatomic, strong) SBKBeaconManager *locationManager;
@property (nonatomic, strong) SBKBeaconID *monitorRegion;

@end

@implementation SENLocationManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init{
    
    if(self = [super init])
    {
        _locationManager = [SBKBeaconManager sharedInstance];

        //获取授权
        [_locationManager requestAlwaysAuthorization];
        //设定代理
        _locationManager.delegate = self;
        //生成监测用的区域ID
        
        _monitorRegion = [SBKBeaconID beaconIDWithProximityUUID:[[NSUUID alloc]initWithUUIDString:@"3C6F9CF2-BBA6-4449-A79A-47DA2FF66D13"]
                                                          major:0x2711
                                                          minor:0x48B7];
//        [_locationManager addBroadcastKey:@"01Y2GLh1yw3+6Aq0RsnOQ8xNvXTnDUTTLE937Yedd/DnlcV0ixCWo7JQ+VEWRSya80yea6u5aWgnW1ACjKNzFnig=="];
    }
    return self;
}


- (void)startMonitor:(BOOL)relaunch{
    
    NSLog(@"Call startMonitor");
    if (relaunch == NO) {
        [_locationManager startRangingBeaconsWithID:_monitorRegion wakeUpApplication:YES];
        NSLog(@"Start monitor region!");
    }else{
        NSLog(@"During the relauch app!");
        [_locationManager startRangingBeaconsWithID:_monitorRegion wakeUpApplication:NO];
    }
}

- (void)stopMonitor{
    [_locationManager stopRangingBeaconsWithID:_monitorRegion];
    NSLog(@"Stop monitor region!");
}

- (void)sendNotification:(NSString *)notify{
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = notify;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}


- (void)beaconManager:(SBKBeaconManager *)beaconManager didRangeNewBeacon:(SBKBeacon *)beacon{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
    
    NSLog(@"Enter: this beacon %@ at %@",beacon.beaconID.stringRepresentation, now);
}

- (void)beaconManager:(SBKBeaconManager *)beaconManager beaconDidGone:(SBKBeacon *)beacon{
    if (beacon.beaconID == nil) {
        return;
    }
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
    
    NSLog(@"Exit this beacon: %@ at %@",beacon.beaconID.stringRepresentation, now);
}

- (void)beaconManager:(SBKBeaconManager *)beaconManager scanDidFinishWithBeacons:(NSArray *)beacons{

    NSLog(@"-------------- scanDidFinishWithBeacons() --------------------\n");

    for(SBKBeacon *b in beacons){
        NSLog(@"UMM: %@ serial number: %@ temprature %@, battery level %@", b.beaconID.stringRepresentation,b.serialNumber,b.temperature,b.batteryLevel);
    }
    NSLog(@"\n---------------------------------------------------------------\n");
}

- (void)beaconManager:(SBKBeaconManager *)beaconManager didDetermineState:(SBKRegionState)state forRegion:(SBKBeaconID *)region{
    NSLog(@"call didDetermineState");
    
    switch (state) {
        case CLRegionStateInside:
        {
            NSLog(@"Did Enter Region: %@", region.CLBeaconRegion.identifier);
        }
            break;
            
        case CLRegionStateOutside:
        {
            NSLog(@"Did Exit Region: %@", region.CLBeaconRegion.identifier);

        }
            break;
            
        case CLRegionStateUnknown:
            NSLog(@"This region state was unknown!");
            break;
    }
}
@end
