//
//  ViewController.m
//  SleepWakeObjc
//
//  Created by Nghia Tran on 12/5/18.
//  Copyright © 2018 com.nsproxy.proxy. All rights reserved.
//

#import "ViewController.h"
#import "Utils.h"

@interface NSString (Utils)
- (BOOL) appendToFile:(NSString *)path;
@end

void logContent(NSString *content, ...) {

	NSLog(@"%@", content);

	// Path
	NSString *filePath = [[NSURL fileURLWithPath:[NSHomeDirectory()stringByAppendingPathComponent:@"Desktop"]].path stringByAppendingPathComponent:@"SleepWakeObj.txt"];

	NSString *newContent = [content stringByAppendingString:@"\n"];
	[newContent appendToFile:filePath];
}

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
														   selector:@selector(receiveShutdownNote:)
															   name:NSWorkspaceWillPowerOffNotification object:nil];

	//    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
	//                                                           selector:@selector(receiveSleepNote:)
	//                                                               name:NSWorkspaceWillSleepNotification object:nil];
	//
	//    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self
	//                                                           selector:@selector(receiveWakeNote:)
	//                                                               name:NSWorkspaceDidWakeNotification object:nil];

	NSDistributedNotificationCenter* distCenter =
	[NSDistributedNotificationCenter defaultCenter];
	//         [distCenter addObserver:self
	//                                selector:@selector(onScreenSaverStarted:)
	//                                    name:@"com.apple.screensaver.didstart"
	//                      object:nil];
	//         [distCenter addObserver:self
	//                                selector:@selector(onScreenSaverStopped:)
	//                                    name:@"com.apple.screensaver.didstop"
	//                                  object:nil];
	[distCenter addObserver:self
				   selector:@selector(onScreenLocked:)
					   name:@"com.apple.screenIsLocked"
					 object:nil];
	[distCenter addObserver:self
				   selector:@selector(onScreenUnlocked:)
					   name:@"com.apple.screenIsUnlocked"
					 object:nil];
}

- (void)receiveShutdownNote:(NSNotification *)note
{
	logContent(@"receiveShutdownNote: %@", [note name]);
}

- (void)receiveSleepNote:(NSNotification *)note
{
	logContent(@"receiveSleepNote: %@", [note name]);
}

- (void)receiveWakeNote:(NSNotification *)note
{
	logContent(@"receiveWakeNote: %@", [note name]);
}

- (void)onScreenSaverStarted:(NSNotification *)note
{
	logContent(@"onScreenSaverStarted: %@", [note name]);
}

- (void)onScreenSaverStopped:(NSNotification *)note
{
	logContent(@"onScreenSaverStopped: %@", [note name]);
}

- (void)onScreenLocked:(NSNotification *)note
{
	logContent(@"onScreenLocked: %@", [note name]);
}

- (void)onScreenUnlocked:(NSNotification *)note
{
	logContent(@"onScreenUnlocked: %@", [note name]);
}


@end




@implementation NSString (Utils)

- (BOOL) appendToFile:(NSString *)path
{
	BOOL result = YES;
	NSFileHandle* fh = [NSFileHandle fileHandleForWritingAtPath:path];
	if ( !fh ) {
		[[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
		fh = [NSFileHandle fileHandleForWritingAtPath:path];
	}
	if ( !fh ) return NO;
	@try {
		[fh seekToEndOfFile];
		[fh writeData:[self dataUsingEncoding:NSUTF8StringEncoding]];
	}
	@catch (NSException * e) {
		result = NO;
	}
	[fh closeFile];
	return result;
}


@end
