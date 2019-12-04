//
//  GUThemeManager.m
//  myFirstProgram
//
//  Created by Глеб Уваркин on 30/11/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

#import "GUThemeManager.h"

@implementation GUThemeManager

// Get the shared instance and create it if necessary.
+(instancetype)sharedInstance {
    static GUThemeManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(instancetype)init
{
    if((self = [super init])){}
    return self;
}

-(void)themeDidChange
{
    
}

@end
