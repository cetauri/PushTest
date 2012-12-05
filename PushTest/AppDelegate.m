//
//  AppDelegate.m
//  PushTest
//
//  Created by cetauri on 12. 12. 5..
//  Copyright (c) 2012년 cetauri. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];

    return YES;
}

#pragma mark -
#pragma mark Apple Push Notifications
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	// didFinishLaunchingWithOptions를 구현할 경우 사용되지 않는다.
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

// 애플리케이션 실행 중에 RemoteNotification 을 수신
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //	NSLog(@"1. didReceiveRemoteNotification");
    
	application.applicationIconBadgeNumber = 0;
	
	// push 메시지 추출
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    // alert 추출
    NSString *alertMessage = [aps objectForKey:@"alert"];
	
	NSString *string = [NSString stringWithFormat:@"%@", alertMessage];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:string delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
	[alert show];
}

// APNS 에 RemoteNotification 등록 실패
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
	NSLog(@"Error in registration. Error: %@", error);
}

//- (void) pushRegister: (NSMutableString *) deviceId  {
//	NSUserDefaults *defaultValues = [NSUserDefaults standardUserDefaults];
//	if (![[defaultValues objectForKey:@"isPushed"] isEqualToString:@"true"]) {
//		@try {
//			
//			NSString *bundlePath = [[NSBundle mainBundle]bundlePath];
//			NSString *pListPath = [bundlePath stringByAppendingPathComponent:@"default_settings.plist"];
//			
//			NSDictionary *pListDefault = [NSDictionary dictionaryWithContentsOfFile:pListPath];
//			NSString *urlString = [pListDefault objectForKey:@"PUSH_API"];
//			NSString *path = [NSString stringWithFormat:@"%@?id=%@", urlString, deviceId];
//			NSString *reponse = [HttpUtils execute:path :@"GET" :nil];
//			
//			//JSON 파싱
//			SBJSON *parser = [[SBJSON alloc] init];
//			NSDictionary *dict = [parser objectWithString:reponse];
//			[parser release];
//			
//			if(![[dict objectForKey:@"status"] isEqualToString: @"0"]){
//				@throw [NSException exceptionWithName:@"fail" reason:@"unknown(status : -1)" userInfo:nil];
//			}
//			
//			[defaultValues setObject:@"true" forKey:@"isPushed"];
//			[defaultValues synchronize];
//			
//			NSLog(@"PUSH registered success.");
//		} @catch (NSException *e) {
//			NSLog(@"Fail to PUSH register %@",e);
//		} @finally {
//			//
//		}
//	}else {
//		NSLog(@"PUSH already registered.");
//	}
//}

// RemoteNotification 등록 성공. deviceToken을 수신
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSLog(@"2. didRegisterForRemoteNotificationsWithDeviceToken");
	
	NSMutableString *deviceId = [NSMutableString string];
	const unsigned char* ptr = (const unsigned char*) [deviceToken bytes];
	
	for(int i = 0 ; i < 32 ; i++)
	{
		[deviceId appendFormat:@"%02x", ptr[i]];
	} 
	
	NSLog(@"This phone's deviceId : %@", deviceId);
//	[self pushRegister: deviceId];
}


@end
