//
//  GUThemeManager.h
//  myFirstProgram
//
//  Created by Глеб Уваркин on 30/11/2019.
//  Copyright © 2019 Gleb Uvarkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifndef GUThemeManager_h
#define GUThemeManager_h

NS_SWIFT_NAME(ThemeManager)

@interface GUThemeManager : NSObject

+ (instancetype)sharedInstance;
- (void)themeDidChange;

@end

#endif /* GUThemeManager_h */
