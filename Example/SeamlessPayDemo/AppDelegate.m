/**
 * Copyright (c) Seamless Payments, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

@import SeamlessPayCore;


#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Override point for customization after application launch.
  NSString *secretkey = [[NSUserDefaults standardUserDefaults] objectForKey:@"secretkey"];
  NSString *publishableKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"publishableKey"];
  NSString *env = [[NSUserDefaults standardUserDefaults] objectForKey:@"env"];

  if (!publishableKey) {
    publishableKey = @"pk_XXXXXXXXXXXXXXXXXXXXXXXXXX";
    secretkey = @"sk_XXXXXXXXXXXXXXXXXXXXXXXXXX";
    env = @"sandbox";
    [[NSUserDefaults standardUserDefaults] setObject:publishableKey forKey:@"publishableKey"];
    [[NSUserDefaults standardUserDefaults] setObject:secretkey forKey:@"secretkey"];
    [[NSUserDefaults standardUserDefaults] setObject:env forKey:@"env"];
  }

  [[SPAPIClient getSharedInstance]
        setSecretKey:secretkey
      publishableKey:publishableKey
             sandbox:[env isEqualToString:@"sandbox"]];

  return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application
    configurationForConnectingSceneSession:
        (UISceneSession *)connectingSceneSession
                                   options:(UISceneConnectionOptions *)options {
  // Called when a new scene session is being created.
  // Use this method to select a configuration to create the new scene with.
  return
      [[UISceneConfiguration alloc] initWithName:@"Default Configuration"
                                     sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application
    didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
  // Called when the user discards a scene session.
  // If any sessions were discarded while the application was not running, this
  // will be called shortly after application:didFinishLaunchingWithOptions. Use
  // this method to release any resources that were specific to the discarded
  // scenes, as they will not return.
}

@end
