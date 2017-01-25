//
//  Utilities.m
//  AlifIslam
//
//  Created by Syed Ubaidullah on 23/07/2015.
//  Copyright (c) 2015 NineSol Technololgies. All rights reserved.
//

#import "Utilities.h"
#import "Constants.h"
//#import "AppDelegate.h"

@implementation Utilities

#pragma mark - Shared

+ (Utilities *)shareManager {
    static Utilities *sharedInstance=nil;
    static dispatch_once_t  oncePredecate;
    
    dispatch_once(&oncePredecate,^{
        sharedInstance = [[Utilities alloc] init];
    });
    return sharedInstance;
}


#pragma mark - Get Color from Hexa code

- (UIColor *)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
-(UIColor *)backgroundColor
{
    NSInteger theme=[[self getUpdatedSettingsForString:ThemeKey] integerValue];
    UIColor *color;
    
    if(theme==0)
    {
      
        color=[UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:0.7];
    }
    else if (theme==1)
    {
        //  R: 81 G: 118 B: 162
        color=[UIColor colorWithRed:81.0/255.0 green:118.0/255.0 blue:162.0/255.0 alpha:0.7];

    }
    else if (theme==2)
    {
       // R: 129 G: 87 B: 89
        color=[UIColor colorWithRed:129.0/255.0 green:87.0/255.0 blue:89.0/255.0 alpha:0.7];
        
    }
    else if (theme==3)
    {
      //  R: 216 G: 101 B: 96
        color=[UIColor colorWithRed:216.0/255.0 green:101.0/255.0 blue:96.0/255.0 alpha:1.0];
        
    }
    else if (theme==4)
    {
        //	R: 37 G: 52 B: 91
        color=[UIColor colorWithRed:37.0/255.0 green:52.0/255.0 blue:91.0/255.0 alpha:1.0];
    }
    else if (theme==5)
    {  color=[UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:0.7];
        
    }
    else
    {
      //  R: 149 G: 79 B: 95
        
        color=[UIColor colorWithRed:149.0/255.0 green:79.0/255.0 blue:95.0/255.0 alpha:1.0];
        
    }
  
    return color;
}
#pragma mark - Move to Directory

- (void)moveToDocumentDirectory:(NSString *)fileName
{
    NSFileManager *fileManger=[NSFileManager defaultManager];
    NSError *error;
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSString *doumentDirectoryPath=[pathsArray objectAtIndex:0];
    
    NSString *destinationPath= [doumentDirectoryPath stringByAppendingPathComponent:fileName];
    
    if ([fileManger fileExistsAtPath:destinationPath]){
        
        return;
    }
    NSString *sourcePath =[[[NSBundle mainBundle] resourcePath]stringByAppendingPathComponent:fileName];
    
    [fileManger copyItemAtPath:sourcePath toPath:destinationPath error:&error];
    if(error)
    {
    }
}

- (BOOL)getUpdatedSettings:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:SettingsFileName];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:docfilePath];
    BOOL check = [[dictionary objectForKey:key] boolValue];
    return check;
}
-(NSString*)getUpdatedSettingsForString:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:SettingsFileName];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:docfilePath];
    NSString *check = [dictionary objectForKey:key];
    
    return check;
}


- (void)updateSettingsstring:(NSString*)value forKey:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:SettingsFileName];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:docfilePath];
    
    [dictionary setObject:value forKey:key];
    
    [dictionary writeToFile:docfilePath atomically:YES];
}
- (void)updateSettings:(BOOL)value forKey:(NSString *)key
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *docfilePath = [basePath stringByAppendingPathComponent:SettingsFileName];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:docfilePath];
    
    [dictionary setObject:[NSNumber numberWithBool:value] forKey:key];
    
    [dictionary writeToFile:docfilePath atomically:YES];
}

@end
