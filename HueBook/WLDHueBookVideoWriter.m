//
//  WLDHueBookVideoWriter.m
//  HueBook
//
//  Created by Li Wang on 10/27/15.
//  Copyright © 2015 Li Wang. All rights reserved.
//

#import "WLDHueBookVideoWriter.h"
#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@interface WLDHueBookVideoWriter(){
    cv::VideoWriter writer;
    NSString *tempVidePath;
}
@end

@implementation WLDHueBookVideoWriter

-(id)init{
    if (self=[super init]) {
        _fps = 30;
        NSString * documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        tempVidePath = [documentPath stringByAppendingPathComponent:@"temp.avi"];
        writer.open([tempVidePath UTF8String], CV_FOURCC('M', 'J', 'P', 'G'), 30, cv::Size(_width, _height));
    }
    return self;
}

-(void)addOneFrame:(UIImage *)image{
    cv::Mat img;
//    cv::Mat targetImg;
    UIImageToMat(image, img);
//    cv::resize(img, targetImg, cv::Size(_width, _height));
    writer << img;
}

-(void)addNextKeyFrame:(UIImage *)image afterTime:(float)second{
    
}

-(void)save{
    UISaveVideoAtPathToSavedPhotosAlbum(tempVidePath, nil, nil, nil);
}
@end
