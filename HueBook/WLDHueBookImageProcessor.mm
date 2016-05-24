//
//  WLDHueBookImageProcessor.m
//  HueBook
//
//  Created by Li Wang on 9/23/15.
//  Copyright (c) 2015 Li Wang. All rights reserved.
//

#import "WLDHueBookImageProcessor.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "UIImage+WLDHueBook.h"

@implementation WLDHueBookImageProcessor

-(UIImage*)findFloodFillAreaFromMask:(UIImage *)mask atPoint:(CGPoint)point{
    cv::Mat maskMat4;
    cv::Mat maskMat3;
    UIImageToMat(mask, maskMat4, true);
    cv::cvtColor(maskMat4, maskMat3, CV_RGBA2RGB);
//    std::vector<cv::Mat> channels(4);
//    cv::split(maskMat4, channels);
//    maskMat3 = channels[3];
    
    cv::Mat largerMask = cv::Mat::zeros(maskMat3.rows+2, maskMat3.cols+2, CV_8U);
    cv::floodFill(maskMat3, largerMask, cv::Point(point.x, point.y), 255, 0, CV_RGB(40,40,40), CV_RGB(255,255,255), 8|cv::FLOODFILL_MASK_ONLY|(255<<8));//4+(255<<8)+cv::FLOODFILL_MASK_ONLY);
    cv::Rect imgOutLine = cv::Rect(1,1,maskMat3.rows, maskMat3.cols);
    UIImage *result = MatToUIImage(cv::Mat(largerMask, imgOutLine));
    maskMat3.release();
    maskMat4.release();
    largerMask.release();
    return result;
}

-(UIImage*)floodFillImage:(UIImage*)colorImage atPoint:(CGPoint)point withColor:(UIColor *)color andMaskImage:(UIImage *)mask{
    UIImage* maskImage = [self findFloodFillAreaFromMask:mask atPoint:point];
    return [colorImage fillWithColor:color inMask:maskImage];
}

-(UIImage *) fillImage:(UIImage*)image WithColor:(UIColor *)color inMask:(UIImage *)mask{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGImageRef imageRef = [image CGImage];
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    
    //    NSUInteger bytesPerPixel = CGImageGetBitsPerPixel(imageRef) / 8;
    NSUInteger bytesPerRow = CGImageGetBytesPerRow(imageRef);
    NSUInteger bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    unsigned char *imageData = malloc(height * bytesPerRow);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    if (kCGImageAlphaLast == (uint32_t)bitmapInfo || kCGImageAlphaFirst == (uint32_t)bitmapInfo) {
        bitmapInfo = (uint32_t)kCGImageAlphaPremultipliedLast;
    }
    
    CGContextRef context = CGBitmapContextCreate(imageData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextClipToMask(context, CGRectMake(0.0, 0.0, width, height), mask.CGImage);
    if ([color isEqual:[UIColor clearColor]]) {
        CGContextClearRect(context, CGRectMake(0, 0, width, height));
    }else{
        CGContextSetFillColorWithColor(context, [color CGColor]);
        CGContextFillRect(context, CGRectMake(0.0, 0.0, width, height));
    }
    
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    
    UIImage *result = [UIImage imageWithCGImage:newCGImage scale:[image scale] orientation:UIImageOrientationUp];
    
    CGImageRelease(newCGImage);
    
    CGContextRelease(context);
    
    free(imageData);
    
    return result;
}
@end
