//
//  lastCharDeleteManager.m
//  myFirstProgram
//
//  Created by Глеб Уваркин on 01/12/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "LastCharDeleteManager.h"
#include <string>

@implementation GULastCharDeleteManager

-(NSString*)doWork : (NSString*) enterString
{
    std::string workString = std::string([enterString UTF8String]);
    //Some c++ code with workString
    workString += "_ThisStringWasInCppCode";
    //End of this code
    NSString *exitString = [NSString stringWithCString:workString.c_str() encoding:[NSString defaultCStringEncoding]];
    return exitString;
}

@end

