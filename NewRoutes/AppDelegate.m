//
//  AppDelegate.m
//  NewRoutes
//
//  Created by François Dupayrat on 19/10/13.
//  Copyright (c) 2013 Hackathon. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LocationManager.h"

#import <Foursquare2.h>

@implementation AppDelegate

@synthesize navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    RootViewController* controller = [RootViewController new];
    [self.window setRootViewController:controller];
    navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self.window addSubview:navigationController.view];
    [self.window makeKeyAndVisible];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [LocationManager sharedManager];
    
    [Foursquare2 setupFoursquareWithClientId:@"ZCT1VSIHDVGL2U314X2VMSTUE0Q0XUC0SFBGWXL0XJPMVY0S"
                                      secret:@"YY2LN1OXN03RNATEX3ATWAZNMCD2J3TBGCEN0AWWLS4OK2PO"
                                 callbackURL:@"NewRoutes://foursquare"];
    if([Foursquare2 isNeedToAuthorize])
    {
        NSLog(@"Need Authorize Foursquare");
        [Foursquare2 authorizeWithCallback:^(BOOL success, id result)
         {
             NSLog(@"Callback success : %@, result : %@", success ? @"yes" : @"no", result);
             [self performFoursquareChecks];
         }];
    }
    else
    {
        NSLog(@"Foursquare authorized : %@", [Foursquare2 isAuthorized] ? @"yes" : @"no");
        if(![Foursquare2 isAuthorized])
        {
            UILocalNotification* notif = [UILocalNotification new];
            [notif setAlertBody:@"Authentication issue with Foursquare, the app cannot work"];
            [[UIApplication sharedApplication] presentLocalNotificationNow:notif];
            exit(0);
        }
        [self performFoursquareChecks];
    }
    return YES;
}

- (void)performFoursquareChecks
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"categories"] == nil)
    {
        [Foursquare2 getVenueCategoriesCallback:^(BOOL success, id result)
         {
             if(success)
             {
                 NSDictionary* response = [result objectForKey:@"response"];
                 NSArray* categories = [response objectForKey:@"categories"];
                 [defaults setObject:categories forKey:@"categories"];
                 [self printCategoriesIn:categories prefix:@"root"];
             }
             else
             {
                 NSLog(@"Problem getting categories");
             }
         }];
    }
    else
    {
        [self printCategoriesIn:[defaults objectForKey:@"categories"] prefix:@"root"];
    }
}

- (void)printCategoriesIn:(NSArray*)categories prefix:(NSString*)prefix
{
    for(NSDictionary* category in categories)
    {
        NSArray* subCategories = [category objectForKey:@"categories"];
        NSString* currentCategoryName = [NSString stringWithFormat:@"%@ | %@", prefix, [category objectForKey:@"name"]];
        if(subCategories != nil)
        {
            [self printCategoriesIn:subCategories prefix:currentCategoryName];
        }
        else
        {
            NSLog(@"%@, id : %@", currentCategoryName, [category objectForKey:@"id"]);
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"Foursquare handle URL");
    return [Foursquare2 handleURL:url];
}

@end
