//
//  HRFilterTool.m
//  HRFilterTool
//
//  Created by Rannie on 13-11-23.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import "HRFilterTool.h"
#import <CoreImage/CoreImage.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface HRFilterTool ()
{
    CIContext                   *_context;              //core image context
    EAGLContext                 *_glContext;            //OpenGL context
}

@end

@implementation HRFilterTool

#pragma mark -
#pragma mark Singleton

+ (HRFilterTool *)filterTool
{
    static dispatch_once_t onceToken;
    static HRFilterTool *instance;
    dispatch_once(&onceToken, ^{
        instance = [[HRFilterTool alloc] initSingleton];
    });
    return instance;
}

- (id)init
{
    NSAssert(NO, @"please send initSingleton method to initialize singleton");
    return nil;
}

- (id)initSingleton
{
    self = [super init];
    if (self) {
        
        //initialize contexts
        _glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        if (!_glContext) {
            NSLog(@"Failed to create ES context");
        }
        _context = [CIContext contextWithEAGLContext:_glContext];

    }
    return self;
}

#pragma mark -
#pragma mark Sepia Filter

- (UIImage *)sepiaImageWithPath:(NSString *)path
{
    return [self sepiaImageWithPath:path intensity:0.5];
}

- (UIImage *)sepiaImageWithPath:(NSString *)path intensity:(CGFloat)intensity
{
    if (!path || intensity > 1 || intensity < 0) return nil;
    
    NSURL *url = [NSURL fileURLWithPath:path];
    CIImage *ciimg = [CIImage imageWithContentsOfURL:url];
    
    return [self sepiaImageWithCIImage:ciimg intensity:intensity];
}

- (UIImage *)sepiaImageWithCIImage:(CIImage *)image intensity:(CGFloat)intensity
{
    CIImage *output = [self sepiaOutputWithCIImage:image intensity:intensity];
    return [self imageWithCoreImage:output];
}

- (CIImage *)sepiaOutputWithPath:(NSString *)path intensity:(CGFloat)intensity
{
    NSURL *url = [NSURL fileURLWithPath:path];
    CIImage *ciimg = [CIImage imageWithContentsOfURL:url];
    return [self sepiaOutputWithCIImage:ciimg intensity:intensity];
}

- (CIImage *)sepiaOutputWithCIImage:(CIImage *)image intensity:(CGFloat)intensity
{
    if (!image || intensity > 1 || intensity < 0) return nil;
    
    CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
    [sepiaFilter setValue:image forKey:kCIInputImageKey];
    [sepiaFilter setValue:@(intensity) forKey:@"inputIntensity"];
    
    CIImage *output = [sepiaFilter outputImage];
    
    return output;
}

#pragma mark -
#pragma mark CIAffineTransform Filter

- (CIImage *)transOutputWithPath:(NSString *)path transform:(CGAffineTransform)trans
{
    NSURL *url = [NSURL fileURLWithPath:path];
    CIImage *ciimg = [CIImage imageWithContentsOfURL:url];
    return [self transOutputWithCIImage:ciimg transform:trans];
}

- (CIImage *)transOutputWithCIImage:(CIImage *)image transform:(CGAffineTransform)trans
{
    if (!image) return nil;
    
    CIFilter *transFilter = [CIFilter filterWithName:@"CIAffineTransform"];
    [transFilter setValue:image forKey:kCIInputImageKey];
    [transFilter setValue:[NSValue valueWithCGAffineTransform:trans] forKey:@"inputTransform"];
    CIImage *output = transFilter.outputImage;
    
    return output;
}

- (UIImage *)transImageWithCIImage:(CIImage *)image transform:(CGAffineTransform)trans
{
    CIImage *output = [self transOutputWithCIImage:image transform:trans];
    return [self imageWithCoreImage:output];
}

- (UIImage *)transImageWithPath:(NSString *)path transform:(CGAffineTransform)trans
{
    NSURL *url = [NSURL fileURLWithPath:path];
    CIImage *ciimg = [CIImage imageWithContentsOfURL:url];
    
    return [self transImageWithCIImage:ciimg transform:trans];
}

#pragma mark -
#pragma mark Compositing

- (UIImage *)atopCompsitingWithTop:(UIImage *)top andBack:(UIImage *)back
{
    if (!top || !back) return nil;
    
    CIImage *topInput = [CIImage imageWithCGImage:top.CGImage];
    CIImage *bottom = [CIImage imageWithCGImage:back.CGImage];
    
    CIFilter *filter = [CIFilter filterWithName:@"CISourceAtopCompositing"];
    [filter setValue:topInput forKey:kCIInputImageKey];
    [filter setValue:bottom forKey:@"inputBackgroundImage"];
    
    return [self imageWithCoreImage:[filter outputImage]];
}

#pragma mark -
#pragma mark CIStraightenFilter

- (UIImage *)straightenImageWithImage:(UIImage *)image andAngle:(CGFloat)angle
{
    if (!image || angle < 0) return nil;
    
    CIImage *input = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIStraightenFilter"];
    [filter setValue:input forKey:kCIInputImageKey];
    [filter setValue:@(angle) forKey:kCIInputAngleKey];
    
    return [self imageWithCoreImage:[filter outputImage]];
}

#pragma mark  -
#pragma mark CIVibranceFilter

- (UIImage *)vibranceWithImage:(UIImage *)image andAmount:(CGFloat)amount
{
    if (!image) return nil;
    
    CIImage *input = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIVibrance"];
    [filter setValue:input forKey:kCIInputImageKey];
    [filter setValue:@(amount) forKey:@"inputAmount"];
    
    return [self imageWithCoreImage:[filter outputImage]];
}

#pragma mark -
#pragma mark CIColorControls

- (UIImage *)colorControlWithImage:(UIImage *)image brightness:(CGFloat)bright contrast:(CGFloat)contrast saturation:(CGFloat)saturation
{
    if (!image) return nil;
    
    CIImage *input = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setValue:input forKey:kCIInputImageKey];
    [filter setValue:@(bright) forKey:@"inputBrightness"];
    [filter setValue:@(contrast) forKey:@"inputContrast"];
    [filter setValue:@(saturation) forKey:@"inputSaturation"];
    
    return [self imageWithCoreImage:[filter outputImage]];
}

#pragma mark -
#pragma mark CIColorInvert

- (UIImage *)colorInvertWithImage:(UIImage *)image
{
    if (!image) return nil;
    
    CIImage *input = [CIImage imageWithCGImage:image.CGImage];
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setValue:input forKey:kCIInputImageKey];
    
    return [self imageWithCoreImage:[filter outputImage]];
}

#pragma mark -
#pragma mark Private

- (UIImage *)imageWithCoreImage:(CIImage *)image
{
    CGImageRef cgimg = [_context createCGImage:image fromRect:[image extent]];
    UIImage *uiimage = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    return uiimage;
}

#pragma mark -
#pragma mark Face Detector

- (BOOL)hasFace:(UIImage *)image
{
    NSArray *features = [self featuresWithImage:image];
    return features.count?YES:NO;
}

- (NSArray *)leftEyePositionsWithImage:(UIImage *)image
{
    if (![self hasFace:image]) return nil;
    
    NSArray *features = [self featuresWithImage:image];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:features.count];
    for (CIFaceFeature *f in features) {
        if (f.hasLeftEyePosition) [arrM addObject:[NSValue valueWithCGPoint:f.leftEyePosition]];
    }
    return arrM;
}

- (NSArray *)rightEyePositionsWithImage:(UIImage *)image
{
    if (![self hasFace:image]) return nil;
    
    NSArray *features = [self featuresWithImage:image];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:features.count];
    for (CIFaceFeature *f in features) {
        if (f.hasRightEyePosition) [arrM addObject:[NSValue valueWithCGPoint:f.rightEyePosition]];
    }
    return arrM;
}

- (NSArray *)mouthPositionsWithImage:(UIImage *)image
{
    if (![self hasFace:image]) return nil;
    
    NSArray *features = [self featuresWithImage:image];
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:features.count];
    for (CIFaceFeature *f in features) {
        if (f.hasMouthPosition) [arrM addObject:[NSValue valueWithCGPoint:f.mouthPosition]];
    }
    return arrM;
}

- (NSArray *)featuresWithImage:(UIImage *)image
{
    CIDetector *faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace
                                                  context:nil
                                                  options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    CIImage *ciimg = [CIImage imageWithCGImage:image.CGImage];
    NSArray *features = [faceDetector featuresInImage:ciimg];
    return features;
}

#pragma mark -
#pragma mark Save to AssetsLibrary

- (void)saveImage:(CIImage *)image
{
    if (!image) return;
    
    CGImageRef cgimg = [_context createCGImage:image fromRect:[image extent]];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgimg
                                 metadata:[image properties]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              CGImageRelease(cgimg);
                          }];
}

@end
