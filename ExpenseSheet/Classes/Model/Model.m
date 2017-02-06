//
//  Model.m
//  ExpenseSheet
//
//  Created by Quratulain on 1/12/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import "Model.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Constants.h"

@implementation Model
#pragma mark -
#pragma mark === Core Data ===
#pragma mark -
+ (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
+(NSArray *)fetchDataFromTable:(NSString *)tableName
{
    NSManagedObjectContext *managedObjectContext = [Model managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:tableName];
    NSArray*  dataArray = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return dataArray;
}
+(NSArray *)fetchDataFromTable:(NSString *)tableName withPredicateName:(NSString *)predicateField andValue:(NSArray *)predicateValue andType:(int)dataType
{
    
    
    NSManagedObjectContext *managedObjectContext = [Model managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:tableName];
    
    NSPredicate *predicate;
    
     // 0:bool, number
     // 1:date
     // 2:string
    
    switch (dataType) {
        case 0:
            predicate=[NSPredicate predicateWithFormat:@"%@==%@",predicateField,[predicateValue objectAtIndex:0]];

            break;
            
        case 1:
              predicate=[NSPredicate predicateWithFormat:@"%@=%@",predicateField,[predicateValue objectAtIndex:0]];
            break;
            
        case 2:
            predicate=[NSPredicate predicateWithFormat:@"%@ like %@",predicateField,[predicateValue objectAtIndex:0]];
            break;
            
        default:
            break;
    }
   
    NSArray*  dataArray = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
    return dataArray;
}
+(NSArray *)fetchDataFromTable:(NSString *)tableName withStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    NSManagedObjectContext *managedObjectContext = [Model managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:tableName];

     NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(expenseDate>=%@ AND expenseDate<=%@)",startDate,endDate];
   [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray*  dataArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error)
    {
        NSLog(@"error is %@",error);
        return nil;
    }
    return dataArray;
}
+(NSArray *)fetchDistinctDataFromTable:(NSString *)tableName withStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate
{
    NSManagedObjectContext *managedObjectContext = [Model managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:tableName];
    
    
    
    NSPredicate *predicate=[NSPredicate predicateWithFormat:@"(expenseDate>=%@ AND expenseDate<=%@)",startDate,endDate];
   // [fetchRequest setPredicate:predicate];
    
    [fetchRequest setPropertiesToFetch:[NSArray arrayWithObjects:@"expenseType", @"expenseDate", nil]];
    [fetchRequest setPropertiesToGroupBy:[NSArray arrayWithObject:@"expenseType"]];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPredicate:predicate];
    NSError *error;
    NSArray*  dataArray = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if(error)
    {
        NSLog(@"error is %@",error);
        return nil;
    }
    return dataArray;
}

@end
