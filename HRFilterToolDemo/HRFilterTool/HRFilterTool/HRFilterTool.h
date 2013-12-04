//
//  HRFilterTool.h
//  HRFilterTool
//
//  Created by Rannie on 13-11-23.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HRFilterTool : NSObject

/**
 *  单例 Singleton
 */
+ (HRFilterTool *)filterTool;

/**
 *  CISepiaTone Filter.
 *  default input intensity is 0.5.
 */

- (CIImage *)sepiaOutputWithCIImage:(CIImage *)image intensity:(CGFloat)intensity;
- (CIImage *)sepiaOutputWithPath:(NSString *)path intensity:(CGFloat)intensity;

- (UIImage *)sepiaImageWithPath:(NSString *)path;
- (UIImage *)sepiaImageWithPath:(NSString *)path intensity:(CGFloat)intensity;
- (UIImage *)sepiaImageWithCIImage:(CIImage *)image intensity:(CGFloat)intensity;

/**
 *  CIAffineTransform Filter.
 *  need input CGAffineTransform
 */

- (CIImage *)transOutputWithPath:(NSString *)path transform:(CGAffineTransform)trans;
- (CIImage *)transOutputWithCIImage:(CIImage *)image transform:(CGAffineTransform)trans;

- (UIImage *)transImageWithPath:(NSString *)path transform:(CGAffineTransform)trans;
- (UIImage *)transImageWithCIImage:(CIImage *)image transform:(CGAffineTransform)trans;

/**
 *  CISourceAtopCompositing Filter
 *  input image and background image
 */

- (UIImage *)atopCompsitingWithTop:(UIImage *)top andBack:(UIImage *)back;

/**
 *  CIStraighten Filter
 */

- (UIImage *)straightenImageWithImage:(UIImage *)image andAngle:(CGFloat)angle;

/**
 *  CIVibrance Filter
 */

- (UIImage *)vibranceWithImage:(UIImage *)image andAmount:(CGFloat)amount;

/**
 *  CIColorControls Filter
 */

- (UIImage *)colorControlWithImage:(UIImage *)image brightness:(CGFloat)bright contrast:(CGFloat)contrast saturation:(CGFloat)saturation;

/**
 *  CIColorInvert Filter
 */

- (UIImage *)colorInvertWithImage:(UIImage *)image;

/**
 *  Face Detector
 */

- (BOOL)hasFace:(UIImage *)image;

- (NSArray *)leftEyePositionsWithImage:(UIImage *)image;
- (NSArray *)rightEyePositionsWithImage:(UIImage *)image;
- (NSArray *)mouthPositionsWithImage:(UIImage *)image;

/**
 *  Save image to library
 *  保存图片
 */

- (void)saveImage:(CIImage *)image;

@end
