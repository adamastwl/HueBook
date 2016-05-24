//
//  UIImage+FloodFill.h
//  ImageFloodFilleDemo
//
//  Created by chintan on 15/07/13.
//  Copyright (c) 2013 ZWT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LinkedListStack.h"

@interface UIImage (FloodFill)
- (UIImage *) fillWithColor:(UIColor *)color inMask:(UIImage *)mask;
- (UIImage *) blendWithForground:(UIImage *)forgroundImage inBlendMode:(CGBlendMode)mode;
- (UIImage *) overlayWithForground:(UIImage *)forgroundImage inSize:(CGSize)size;
- (UIImage *) overlayLineMap:(UIImage*)lineMap;
- (UIImage *) floodFillFromPoint:(CGPoint)startPoint withColor:(UIColor *)newColor andTolerance:(int)tolerance;
- (UIImage *) floodFillFromPoint:(CGPoint)startPoint withColor:(UIColor *)newColor andTolerance:(int)tolerance useAntiAlias:(BOOL)antiAlias;
- (UIColor *) getColorAtX:(int)x andY:(int)y;

@end