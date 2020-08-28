//
//  JerTiledImageView.h
//  LargeImage
//
//  Created by liudj on 2020/8/24.
//  Copyright © 2020 dcjt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JerTiledImageView : UIView
- (instancetype)initWithFrame:(CGRect)frame image:(UIImage*)image scale:(CGFloat)scale;
@end

NS_ASSUME_NONNULL_END
