//
//  XSLSearchButton.m
//  XSLSearchTextFieldDemo
//
//  Created by xsl on 16/5/25.
//  Copyright © 2016年 xsl. All rights reserved.
//

#import "XSLSearchButton.h"
@interface XSLSearchButton ()
{
    CGFloat _width;         //self.frame.size.width
    CGFloat _height;        //self.frame.size.height
    CGFloat _lineLength;    //斜线长
    CGFloat _radiusMin;     //小圆半径
    CGFloat _radiusMax;     //大圆半径
    CGFloat _cdx;           //圆半径差
    CGFloat _rdx;           //右斜线长度差
    CGFloat _sqrt2;
}

@property (nonatomic,strong)CAShapeLayer *circleLayer;
@property (nonatomic,strong)CAShapeLayer *leftLineLayer;    //x+y=_width"/"
@property (nonatomic,strong)CAShapeLayer *rightLineLayer;   //x=y"\"
/**
 *  使用UIControlState中三种状态
 *  UIControlStateSelected:     选中状态
 *  UIControlStateFocused:      可清除状态
 *  UIControlStateNormal:       普通状态
 */
@property (nonatomic)UIControlState searchState;


@end
@implementation XSLSearchButton

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.width)];
    if (self) {
        [self setupValuesWithFrame:frame];
        [self.layer addSublayer:self.circleLayer];
        [self.layer addSublayer:self.rightLineLayer];
        _searching = NO;
        _clearEnable = NO;
        
    }
    return self;
}


- (void)setupValuesWithFrame:(CGRect)frame{
    _radiusMin = frame.size.width / 4.0f;
    _radiusMax = frame.size.width / 3.0f;
    _width = frame.size.width;
    _height = _width;
    _lineLength = _radiusMax;
    _sqrt2 = sqrt(2);
    _cdx =  _radiusMin / 2;
    
    CGFloat rightX1 = _width / 2 + _radiusMin / _sqrt2 - _cdx;
    CGFloat rightX2 = _width / 2 - _lineLength / 2 /_sqrt2;
    _rdx = rightX1 - rightX2;
}

#pragma mark lazy load
- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, nil, _width / 2 - _cdx, _width / 2 - _cdx, _radiusMin, 0, M_PI * 2, YES);
        _circleLayer.path = path;
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _circleLayer;
}

- (CAShapeLayer *)rightLineLayer{
    if (!_rightLineLayer) {
        _rightLineLayer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGFloat beginX = _width / 2 + _radiusMin / _sqrt2 - _cdx;
        CGFloat endX = beginX + _lineLength / _sqrt2;
        CGPathMoveToPoint(path, nil, beginX, beginX);
        CGPathAddLineToPoint(path, nil, endX,endX);
        _rightLineLayer.path = path;
        _rightLineLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _rightLineLayer;
}

- (CAShapeLayer *)leftLineLayer{
    if (!_leftLineLayer) {
        _leftLineLayer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGFloat beginX = _width / 2 + _lineLength / 2 / _sqrt2;
        CGFloat endX = beginX - _lineLength / _sqrt2;
        CGPathMoveToPoint(path, nil, beginX, _width - beginX);
        CGPathAddLineToPoint(path, nil, endX, _width - endX);
        _leftLineLayer.path = path;
        _leftLineLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _leftLineLayer;
}

#pragma mark - animation
- (CABasicAnimation *)stokeAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 0.3f;
    animation.removedOnCompletion = YES;
    return animation;
}

- (void)showDefault{
    [self setNormalColor:_normalColor];
    [self.leftLineLayer removeFromSuperlayer];
}

- (void)enableClear{
    [self.layer addSublayer:self.leftLineLayer];
    self.circleLayer.transform =  CATransform3DMakeAffineTransform(CGAffineTransformMake(_radiusMax / _radiusMin, 0, 0, _radiusMax / _radiusMin, 0, 0));
    [self.leftLineLayer addAnimation:[self stokeAnimation] forKey:@"stokeAnimation"];
    self.rightLineLayer.position = CGPointMake(self.rightLineLayer.position.x - _rdx, self.rightLineLayer.position.y - _rdx);
    
}

- (void)showHilightedWithAnimation:(BOOL)animation{
    [self setSeachingColor:_seachingColor];
    [self.leftLineLayer removeFromSuperlayer];
    if (!animation) {
        return;
    }
    self.circleLayer.transform =  CATransform3DMakeAffineTransform(CGAffineTransformMake(1, 0, 0, 1, 0, 0));
    self.rightLineLayer.position = CGPointMake(self.rightLineLayer.position.x + _rdx, self.rightLineLayer.position.y +_rdx);
}

#pragma mark - set
- (void)setSearching:(BOOL)searching{
    _searching = searching;
    self.searchState = _searching ? UIControlStateSelected : UIControlStateNormal;
}

- (void)setClearEnable:(BOOL)clearEnable{
    if (_searching) {
        _clearEnable = clearEnable;
        _clearEnable ? self.searchState = UIControlStateFocused : [self setSearching:_searching];
    }
}

- (void)setSearchState:(UIControlState)searchState{
    switch (searchState) {
        case UIControlStateSelected:
        {
            [self showHilightedWithAnimation:_searchState == UIControlStateFocused];
            break;
        }
        case UIControlStateFocused:{
            [self enableClear];
            break;
        }
        case UIControlStateNormal:{
            [self showDefault];
            break;
        }
        default:
            break;
    }
    _searchState = searchState;
}

- (void)setSeachingColor:(UIColor *)seachingColor{
    _seachingColor = seachingColor;
    if (self.searching) {
        self.rightLineLayer.strokeColor = _seachingColor.CGColor;
        self.circleLayer.strokeColor = _seachingColor.CGColor;
        self.leftLineLayer.strokeColor = _seachingColor.CGColor;
    }
    
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    if (!self.searching) {
        self.rightLineLayer.strokeColor = _normalColor.CGColor;
        self.circleLayer.strokeColor = _normalColor.CGColor;
        self.leftLineLayer.strokeColor = _normalColor.CGColor;
    }
}

@end
