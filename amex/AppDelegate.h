//
//  AppDelegate.h
//  amex
//
//  Created by Etay Luz on 7/28/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

CGRect Frame(float x, float y, float w, float h);
double Normalize(double val);
double Denormalize(double val);
extern float screenWidth;
extern float screenHeight;
void ShowViewBorders(UIView *view);

