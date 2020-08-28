//
//  ViewController.m
//  LargeImage
//
//  Created by dcjt on 2018/12/19.
//  Copyright © 2018 dcjt. All rights reserved.
//

#import "ViewController.h"
#import "ImageScrollView.h"
#import "JerTiledImageView.h"

@interface ViewController ()
@property (nonatomic, strong) JerTiledImageView *tileView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tileView];
}

- (JerTiledImageView *)tileView {
    if (!_tileView) {
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bigbig" ofType:@"jpg"]];
        CGRect imageRect = CGRectMake(0.0f,0.0f,CGImageGetWidth(image.CGImage),CGImageGetHeight(image.CGImage));
        CGFloat scale = self.view.bounds.size.width/imageRect.size.width;
        _tileView = [[JerTiledImageView alloc]initWithFrame:self.view.bounds image:image scale:scale];
    }
    return _tileView;
}
@end
