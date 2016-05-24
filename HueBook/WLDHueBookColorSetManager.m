//
//  WLDHueBookColorSetManager.m
//  HueBook
//
//  Created by Li Wang on 8/30/15.
//  Copyright (c) 2015 Li Wang. All rights reserved.
//

#import "WLDHueBookColorSetManager.h"
#import "WLDHueBookConstants.h"

@interface WLDHueBookColorSetManager() {
    NSDictionary* colorSetMap;
}

@end

@implementation WLDHueBookColorSetManager
static NSString* const kResColorSetListFileName = @"WLDHueBookResColorSet";
static NSString* const kResColorSetDisplayName = @"displayName";
static NSString* const kResColors = @"colors";
static NSString* const kResRed = @"red";
static NSString* const kResGreen = @"green";
static NSString* const kResBlue = @"blue";
static NSString* const kResIsFree = @"isFree";

+(id)sharedInstance{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}

-(BOOL)loadFromJson{
    NSError * error;
    NSString * filePath = [[NSBundle mainBundle] pathForResource:kResColorSetListFileName ofType:@"json"];
    NSData * jsonData = [NSData dataWithContentsOfFile:filePath];
    colorSetMap = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error == nil){
        NSLog(@"Load WLDHueBookResColorSet.json successfully!");
        return YES;
    }
    else{
        NSLog(@"%@", error.description);
        return NO;
    }
}

-(NSArray*)allColorSetIDs{
    return  [colorSetMap allKeys];
}

-(NSArray*)colorSetBySetID:(NSInteger)colorSetID{    
    NSString* setIDKey = [NSString stringWithFormat:@"%li", colorSetID];
    NSMutableArray* colorList = [[NSMutableArray alloc] init];
    for (NSDictionary* thisColor in [[colorSetMap objectForKey:setIDKey] objectForKey:kResColors]){
        UIColor* thisColorObj = [UIColor colorWithRed:[(NSNumber*)[thisColor objectForKey:kResRed] floatValue] green:[(NSNumber*)[thisColor objectForKey:kResGreen] floatValue] blue:[(NSNumber*)[thisColor objectForKey:kResBlue] floatValue] alpha:1.0];
        [colorList addObject:thisColorObj];
    }
    return  colorList;
}

-(NSString*)colorSetNameByID:(NSInteger)colorSetID{
    NSString* setIDKey = [NSString stringWithFormat:@"%li", colorSetID];
    return [[colorSetMap objectForKey:setIDKey] objectForKey:kResColorSetDisplayName];
}

-(BOOL)colorSetIsFreeByID:(NSInteger)colorSetID{
    NSString* setIDKey = [NSString stringWithFormat:@"%li", colorSetID];
    return [[colorSetMap objectForKey:setIDKey] objectForKey:kResIsFree];
}

-(void)
@end
