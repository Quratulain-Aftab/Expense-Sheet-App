//
//  AppDelegate.m
//  ExpenseSheet
//
//  Created by IOS Apps Developer on 11/17/16.
//  Copyright © 2016 IOS Apps Developer. All rights reserved.
//

#import "AppDelegate.h"
#import "Constants.h"
#import "Utilities.h"
#import "HomeViewController.h"
//#import "ExpenseSheetDetailViewController.h"
@interface AppDelegate ()
@end
@implementation AppDelegate
{
    UINavigationController *navigationController;
    UIStoryboard *storyboard;
}
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
#pragma mark Application Delegate Methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self resetTempUserDefaults];
    
    [[Utilities shareManager] moveToDocumentDirectory:SettingsFileName];
    
    NSLog(@"count is %lu",[UIApplication sharedApplication].scheduledLocalNotifications.count);
    
    // 3D touch handling on home screen app icon
//    UIApplicationShortcutIcon * photoIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"disclosure.png"]; // your customize icon
    UIApplicationShortcutItem * photoItem = [[UIApplicationShortcutItem alloc]initWithType: @"Due this week" localizedTitle: @"Pending this week" localizedSubtitle: nil icon: [UIApplicationShortcutIcon iconWithType: UIApplicationShortcutIconTypeUpdate] userInfo: nil];
    UIApplicationShortcutItem * videoItem = [[UIApplicationShortcutItem alloc]initWithType: @"Create New Expense Sheet" localizedTitle: @"New Expense Sheet" localizedSubtitle: nil icon: [UIApplicationShortcutIcon iconWithType: UIApplicationShortcutIconTypeAdd] userInfo: nil];
    
    [UIApplication sharedApplication].shortcutItems = @[photoItem,videoItem];
    UIApplicationShortcutItem *shortcutItem = [launchOptions objectForKey:UIApplicationLaunchOptionsShortcutItemKey];
    
    // notifications handling
  //  [self registerForLocalNotifications];
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (notification)
    {
        [self handleNotification:notification];
    }
    else
    {
        if([[Utilities shareManager]getUpdatedSettings:LockKey]==YES)
        {
            
        }
        else
        {
           navigationController= (UINavigationController *)self.window.rootViewController;
            
            storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            HomeViewController *homevc=[storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
            [navigationController setViewControllers:@[homevc] animated:NO];
    
        }
    }
    application.applicationIconBadgeNumber = 0;
    return ![self handleShortCutItem:shortcutItem];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about  ,,to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [[NSNotificationCenter defaultCenter] postNotificationName:AppDidBecomeActiveNotification object:nil userInfo:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"isNotFirstTime"])
    {
        [self setupLocalNotifications];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isNotFirstTime"];
    }
    
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    [self handleShortCutItem:shortcutItem];
}
#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ExpenseSheet" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ExpenseSheet.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark - Local Notifications
- (void)registerForLocalNotifications
{
    UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                            settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeAlert|UIUserNotificationTypeSound
                                            categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    
    
}
- (void)handleNotification:(UILocalNotification *)notification {
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
//        RemindMeViewController *rootController = (RemindMeViewController *)self.window.rootViewController;
//        [rootController showReminder:notification];
    }
}
-(void)setupLocalNotifications
{
    
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
    
    NSString *notificationDay, *notificationType, *notificationTime, *notificationAlertText;
    
    notificationDay=[[Utilities shareManager] getUpdatedSettingsForString:NotificationDayKey];
    notificationTime=[[Utilities shareManager] getUpdatedSettingsForString:NotificationTimeKey];
    notificationType=[[Utilities shareManager] getUpdatedSettingsForString:NotificationTypeKey];
    notificationAlertText=[[Utilities shareManager] getUpdatedSettingsForString:NotificationTextKey];
    
    NSArray *timeArray=[notificationTime componentsSeparatedByString:@" "];

    
    int hour,min;
    
    hour=[[[[timeArray objectAtIndex:0]componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
    min=[[[[timeArray objectAtIndex:0]componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
    if([[timeArray objectAtIndex:1] isEqualToString:@"am"])
    {
       
    }
    else
    {
        hour=12+hour;
    }
    
    
    
    NSArray *notificationArray=[[UIApplication sharedApplication]scheduledLocalNotifications];
        for(UILocalNotification *notification in notificationArray)
        {
    
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    
        NSDate *fireDate=[NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear |  NSCalendarUnitHour | NSCalendarUnitMonth| NSCalendarUnitSecond | NSCalendarUnitWeekOfYear) fromDate:fireDate];
        [comp setHour:hour];
        [comp setMinute:min];
        [comp setSecond:0];
        fireDate = [calendar dateFromComponents:comp];
        UILocalNotification *localNotif = [[UILocalNotification alloc] init];
        localNotif.fireDate = fireDate;
        localNotif.timeZone = [NSTimeZone localTimeZone];
    if([notificationType isEqualToString:@"Weekly"])
    {
          localNotif.repeatInterval = NSCalendarUnitWeekOfYear;
        [comp setWeekday:[notificationDay integerValue]];

    }
    else if([notificationType isEqualToString:@"Monthly"])
    {
         localNotif.repeatInterval = NSCalendarUnitMonth;
        [comp setDay:[notificationDay integerValue]+1];
    }
    else
    {
         localNotif.repeatInterval = NSCalendarUnitDay;
    }
    
        localNotif.alertBody=notificationAlertText;
        localNotif.alertTitle=APP_NAME;
        NSLog(@" date %lu",kCFCalendarUnitDay);
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    NSLog(@"count is %lu",[UIApplication sharedApplication].scheduledLocalNotifications.count);
}
#pragma mark Handle peek
- (BOOL)handleShortCutItem:(UIApplicationShortcutItem *)shortcutItem {
    BOOL handled = NO;
    
    if (shortcutItem == nil) {
        return handled;
    }
    
    handled = YES;
    
    if([shortcutItem.type isEqualToString:@"Create New Expense Sheet"])
    {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:ShouldShowCreateSheetView];
        [self navigateTowardCreateExpenseSheetView];
    }
    else
    {
        // show current expense sheet detail
    }
    
    return handled;
    
}
#pragma mark - Helper Methods
-(void)resetTempUserDefaults
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:DidSettingsChangedUserDefault];
    
    //NSUserDefaults *mySharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:AppGroupName];
    // Use the shared user defaults object to update the user's account
     //   [mySharedDefaults setObject:nil forKey:@"task"];
}
-(void)navigateTowardCreateExpenseSheetView
{
    navigationController= (UINavigationController *)self.window.rootViewController;
    storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NSLog(@"visible view controller is %@",navigationController.visibleViewController);
    
   BOOL isModel= [self isModal];
    
    if(isModel)
    {
        if (navigationController.visibleViewController.isViewLoaded && navigationController.visibleViewController.view.window){
            // viewController is visible
            [navigationController.visibleViewController dismissViewControllerAnimated:NO completion:nil];
        }
        else
        {
             [navigationController.visibleViewController dismissViewControllerAnimated:NO completion:nil];
            [navigationController.visibleViewController dismissViewControllerAnimated:NO completion:nil];
        }
        
    }
      [navigationController popToViewController:[navigationController.viewControllers objectAtIndex:1] animated:YES];
    
}
- (BOOL)isModal {
    if([navigationController.visibleViewController presentingViewController])
        return YES;
   if([[navigationController presentingViewController] presentedViewController] == navigationController.visibleViewController)
      return YES;
    if([[navigationController presentingViewController] presentedViewController] == navigationController)
    return YES;
    //if([[[self tabBarController] presentingViewController] isKindOfClass:[UITabBarController class]])
      //  return YES;
    
    return NO;
}
@end
