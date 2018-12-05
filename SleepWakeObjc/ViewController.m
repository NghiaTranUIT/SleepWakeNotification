//
//  ViewController.m
//  SleepWakeObjc
//
//  Created by Nghia Tran on 12/5/18.
//  Copyright © 2018 com.nsproxy.proxy. All rights reserved.
//

#import "ViewController.h"
#import "Utils.h"

@interface ViewController ()

@property (strong, nonatomic) Utils *utils;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.

    self.utils = [[Utils alloc] init];
    [self.utils setup];

    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(receiveSleepNote:)
                                                               name:NSWorkspaceWillSleepNotification object:nil];

    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
                                                           selector:@selector(receiveWakeNote:)
                                                               name:NSWorkspaceDidWakeNotification object:nil];

    NSDistributedNotificationCenter* distCenter =
               [NSDistributedNotificationCenter defaultCenter];
         [distCenter addObserver:self
                                selector:@selector(onScreenSaverStarted:)
                                    name:@"com.apple.screensaver.didstart"
                      object:nil];
         [distCenter addObserver:self
                                selector:@selector(onScreenSaverStopped:)
                                    name:@"com.apple.screensaver.didstop"
                                  object:nil];
         [distCenter addObserver:self
                                selector:@selector(onScreenLocked:)
                                    name:@"com.apple.screenIsLocked"
                                  object:nil];
         [distCenter addObserver:self
                               selector:@selector(onScreenUnlocked:)
                                    name:@"com.apple.screenIsUnlocked"
                                object:nil];
}

- (void)receiveSleepNote:(NSNotification *)note
{
    NSLog(@"receiveSleepNote: %@", [note name]);
}

- (void)receiveWakeNote:(NSNotification *)note
{
    NSLog(@"receiveWakeNote: %@", [note name]);
}

- (void)onScreenSaverStarted:(NSNotification *)note
{
    NSLog(@"onScreenSaverStarted: %@", [note name]);
}

- (void)onScreenSaverStopped:(NSNotification *)note
{
    NSLog(@"onScreenSaverStopped: %@", [note name]);
}

- (void)onScreenLocked:(NSNotification *)note
{
    NSLog(@"onScreenLocked: %@", [note name]);
}

- (void)onScreenUnlocked:(NSNotification *)note
{
    NSLog(@"onScreenUnlocked: %@", [note name]);
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
