//
//  ViewController.m
//  HRFilterTool
//
//  Created by Rannie on 13-11-23.
//  Copyright (c) 2013年 Rannie. All rights reserved.
//

#import "ViewController.h"
#import "HRFilterTool.h"

@interface ViewController ()
{
    UIImageView                     *_imageView;
    HRFilterTool                    *_tool;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tool = [HRFilterTool filterTool];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 280, 300)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_imageView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"han" ofType:@"jpg"];
    
//    _image = [_tool sepiaImageWithPath:path];
//    _image = [_tool sepiaImageWithPath:path intensity:0.1];
    
//    CIImage *ciimg = [_tool transOutputWithPath:path transform:CGAffineTransformMakeRotation(M_PI)];
//    [_tool saveImage:ciimg];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
//    _imageView.image = [_tool sepiaImageWithPath:path];
//    _imageView.image = [_tool colorControlWithImage:image brightness:-0.5 contrast:3.0 saturation:1.5];
    _imageView.image = [_tool colorInvertWithImage:image];
}

@end
