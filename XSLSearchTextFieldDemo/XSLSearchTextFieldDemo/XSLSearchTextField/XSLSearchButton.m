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
    
    CGFloat _radius;     //小圆半径
    
    CGPoint _lbPoint;
    CGPoint _lePoint;
    
    CGPoint _rbPoint;
    CGPoint _rePoint;
    CGPoint _rInPosition;
    CGPoint _rOutPosition;
    
    CGPoint _circleCenter;
    
    CATransform3D _circleTransformMin;
    CATransform3D _circleTransformMax;
    
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
        [self caculateWithFrame:frame];
        [self.layer addSublayer:self.circleLayer];
        [self.layer addSublayer:self.rightLineLayer];
        _searching = NO;
        _clearEnable = NO;
    }
    return self;
}


- (void)caculateWithFrame:(CGRect)frame{
    _radius = frame.size.width / 4.0f;
    CGFloat radiusMax = frame.size.width / 3.0f;
    CGFloat width = frame.size.width;
    CGFloat sqrt2 = sqrt(2);
    CGFloat cdx = _radius / 2;
    CGFloat lineLength = radiusMax;
    _circleCenter = CGPointMake(width / 2 - cdx, width / 2 - cdx);
    
    CGFloat rbx = width / 2 + _radius / sqrt2 - cdx;
    CGFloat rex = rbx + lineLength / sqrt2;
    CGFloat inX = (width - lineLength /sqrt2) / 2;
    _rbPoint = CGPointMake(rbx, rbx);
    _rePoint = CGPointMake(rex, rex);
    _rInPosition = CGPointMake(inX - rbx, inX - rbx);
    _rOutPosition = CGPointZero;
    
    CGFloat lbx = width / 2 + lineLength / 2 / sqrt2;
    CGFloat lex = lbx - lineLength / sqrt2;
    _lbPoint = CGPointMake(lbx, width - lbx);
    _lePoint = CGPointMake(lex, width - lex);
    
    _circleTransformMin = CATransform3DMakeAffineTransform(CGAffineTransformMake(1, 0, 0, 1, 0, 0));
    _circleTransformMax = CATransform3DMakeAffineTransform(CGAffineTransformMake(radiusMax / _radius, 0, 0, radiusMax / _radius, 0, 0));
}


#pragma mark lazy load
- (CAShapeLayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, nil, _circleCenter.x , _circleCenter.y, _radius ,0, M_PI * 2, YES);
        _circleLayer.path = path;
        CGPathRelease(path);
        _circleLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _circleLayer;
}

- (CAShapeLayer *)rightLineLayer{
    if (!_rightLineLayer) {
        _rightLineLayer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, _rbPoint.x, _rbPoint.y);
        CGPathAddLineToPoint(path, nil, _rePoint.x, _rePoint.y);
        _rightLineLayer.anchorPoint = CGPointZero;
        _rightLineLayer.path = path;
        CGPathRelease(path);
        _rightLineLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _rightLineLayer;
}

- (CAShapeLayer *)leftLineLayer{
    if (!_leftLineLayer) {
        _leftLineLayer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, _lbPoint.x, _lbPoint.y);
        CGPathAddLineToPoint(path, nil, _lePoint.x, _lePoint.y);
        _leftLineLayer.path = path;
        CGPathRelease(path);
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
    self.circleLayer.transform = _circleTransformMax;
    [self.leftLineLayer addAnimation:[self stokeAnimation] forKey:@"stokeAnimation"];
    self.rightLineLayer.position = _rInPosition;

}

- (void)showHilightedWithAnimation:(BOOL)animation{
    [self setSeachingColor:_seachingColor];
    [self.leftLineLayer removeFromSuperlayer];
    if (!animation) {
        return;
    }
    self.circleLayer.transform = _circleTransformMin;
    self.rightLineLayer.position = _rOutPosition;
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
