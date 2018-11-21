//
//  AppDelegate.m
//  Mouse Remap Helper
//
//  Created by Noah Nübling on 25.07.18.
//  Copyright © 2018 Noah Nuebling Enterprises Ltd. All rights reserved.
//
#import "AppDelegate.h"
#import "InputReceiver.h"
#import "InputParser.h"
#import "ConfigFileMonitor.h"
#import "SmoothScroll.h"

#import "CGSInternal/CGSHotKeys.h"
#import "SensibleSideButtons/TouchEvents.h"


@interface AppDelegate ()

@end

@implementation AppDelegate



- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSLog(@"running Mouse Remap Helper");

    [InputReceiver start];
    
    [ConfigFileMonitor fillConfigDictFromFile];
    [ConfigFileMonitor setupFSEventStreamCallback];
    
    SmoothScroll *smoothScrollObject = [[SmoothScroll alloc] init];
    [smoothScrollObject start];
    
    
    // setup SSB globals
    _swipeInfo = [NSMutableDictionary dictionary];
    
    for (NSNumber* direction in @[ @(kTLInfoSwipeUp), @(kTLInfoSwipeDown), @(kTLInfoSwipeLeft), @(kTLInfoSwipeRight) ]) {
        NSDictionary* swipeInfo1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @(kTLInfoSubtypeSwipe), kTLInfoKeyGestureSubtype,
                                    @(1), kTLInfoKeyGesturePhase,
                                    nil];
        
        NSDictionary* swipeInfo2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @(kTLInfoSubtypeSwipe), kTLInfoKeyGestureSubtype,
                                    direction, kTLInfoKeySwipeDirection,
                                    @(4), kTLInfoKeyGesturePhase,
                                    nil];
        
        _swipeInfo[direction] = @[ swipeInfo1, swipeInfo2 ];
    }
    
    _nullArray = @[];
}

- (void) repairConfigFile:(NSString *)info {
    // TODO: actually repair config dict
    NSLog(@"repairing configDict....");
}



// NSTimer Callbacks

// - InputParser.h
- (void) disableSHK: (NSTimer *)timer {
    CGSSymbolicHotKey shk = [[timer userInfo] intValue];
    CGSSetSymbolicHotKeyEnabled(shk, FALSE);
}
- (void) doClickAndHoldAction: (NSTimer *)timer {
    NSArray *holdAction = [timer userInfo];
    [InputParser handleActionArray:holdAction];
}

@end
