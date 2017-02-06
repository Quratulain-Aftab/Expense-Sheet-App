//
//  Model.h
//  ExpenseSheet
//
//  Created by Quratulain on 1/12/17.
//  Copyright © 2017 IOS Apps Developer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Model : NSObject
+(NSArray *)fetchDataFromTable:(NSString *)tableName;
+(NSArray *)fetchDataFromTable:(NSString *)tableName withPredicateName:(NSString *)predicateField andValue:(NSArray *)predicateValue andType:(int)dataType;
+(NSArray *)fetchDataFromTable:(NSString *)tableName withStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;
+(NSArray *)fetchDistinctDataFromTable:(NSString *)tableName withStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;
@end
