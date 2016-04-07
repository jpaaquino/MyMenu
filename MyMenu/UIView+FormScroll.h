//
//  UIView+FormScroll.m
//
// Originally posted by Dan Ray http://stackoverflow.com/questions/5220818/moving-uiview-up-when-keyboard-shown/5221243#5221243
// Additions by Mark Rickert
//
// License: Public Domain

#import <UIKit/UIKit.h>

#define kFormScrollDidComplete @"kFormScrollDidComplete"
#define kFormScrollAnimationTiming 3.0

@interface UIView (FormScroll)

-(void)scrollToY:(float)y;
-(void)scrollToView:(UIView *)view;
-(void)scrollElement:(UIView *)view toPoint:(float)y;
-(void) notifyAnimationComplete;

@end