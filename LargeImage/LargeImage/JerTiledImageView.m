//
//  JerTiledImageView.m
//  LargeImage
//
//  Created by liudj on 2020/8/24.
//  Copyright © 2020 dcjt. All rights reserved.
//

#import "JerTiledImageView.h"

@interface JerTiledImageView()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect imageRect;
@property (nonatomic, assign) CGFloat imageScale;
@end

@implementation JerTiledImageView


- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image scale:(CGFloat)scale
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageRect = CGRectMake(0.0f, 0.0f,
                                CGImageGetWidth(self.image.CGImage),
                                CGImageGetHeight(self.image.CGImage));
        self.imageScale = scale;
        [self commonInit:image];
    }
    return self;
}



- (void)commonInit:(UIImage*)image {
    self.image = image;
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    int lev = ceil(log2(1/self.imageScale))+1;
    tiledLayer.levelsOfDetail = 1;
    tiledLayer.levelsOfDetailBias = lev;
    tiledLayer.tileSize = [self getTitleSize:image];
}

- (void)drawRect:(CGRect)rect {
     @autoreleasepool{
         CGRect imageCutRect = CGRectMake(rect.origin.x/_imageScale,
                                          rect.origin.y/_imageScale,
                                          rect.size.width/_imageScale,
                                          rect.size.height/_imageScale);
         CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, imageCutRect);
         UIImage *tileImage = [UIImage imageWithCGImage:imageRef];
         CGContextRef context = UIGraphicsGetCurrentContext();
         UIGraphicsPushContext(context);
         [tileImage drawInRect:rect];
         CGImageRelease(imageRef);
         UIGraphicsPopContext();
     }
}

+ (Class)layerClass {
    return [CATiledLayer class];
}


/// tileSize是最关键的参数, tileSize大, 则加载快, 但是内存洪峰大; tileSize小, 则加载慢, 但内存洪峰小. 所以取一个合适的tileSize就显得非常重要.
/// 图片大小一般是和图片原始size成正比的, 当然也不是一定的, 但基本是这样. 我们暂时不考虑图片体积很大但size很小的情况.
- (CGSize)getTitleSize:(UIImage*)image {
    // 图片的原始大小
    CGFloat originWidth  = CGImageGetWidth(image.CGImage);
    CGFloat originHeight = CGImageGetHeight(image.CGImage);
    CGSize originImageSize = CGSizeMake(originWidth, originHeight);
    
    //图片加载到真实内存的真实大小约为:图片宽*图片高*scale
    CGFloat imageSize = originWidth * originHeight * [[UIScreen mainScreen] scale];
    
    if (CGSizeEqualToSize(originImageSize, CGSizeZero) || !imageSize) {
        return CGSizeZero;
    }
    
    //默认tileSize等于整个图片大小, 也就是不分块, 也就是分成1块
    CGSize finalSize = originImageSize;
    //体积是影响内存洪峰高度的关键, 我们暂时只处理 10MB的图片, 小于10MB的图片不分块
    if (imageSize < 10 * 1024) {
        return finalSize;
    }
    
    /* 需要注意, tileSize并不一定要是正方形, 也就是长宽相等, 所以这个方程就成了
     * imageOriginW = tileSize.width * x;
     * imageOriginH = tileSize.height * y;
     * x表示x轴方向的tile个数, y表示y轴方向的tile个数
     * 怎样取x和y, 我暂时是取x = y = 10,也就是缩小10倍, 之后再优化, 达到加载速度和内存洪峰的平衡
    */
    
    finalSize.width = floor(self.frame.size.width/10);
    finalSize.height = floor(self.frame.size.height/10);
    return finalSize;
}
@end
