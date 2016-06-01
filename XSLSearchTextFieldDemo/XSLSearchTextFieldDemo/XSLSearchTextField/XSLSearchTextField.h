//
//  XSLSearchTextField.h
//  XSLSearchTextFieldDemo
//
//  Created by xsl on 16/5/25.
//  Copyright © 2016年 xsl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SearchHandle) (UITextField *textField);

typedef NS_ENUM(NSUInteger,XSLSearchTextFieldAnimationDirection) {
    XSLSearchTextFieldAnimationDirectionLeft,//default
    XSLSearchTextFieldAnimationDirectionRight
};

@interface XSLSearchTextField : UIView

@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIColor *normalColor;
@property (nonatomic,strong)UIColor *searchColor;

@property (nonatomic,readonly)CGFloat height;
@property (nonatomic,readonly)CGFloat minWidth;
@property (nonatomic,readonly)CGPoint position;
@property (nonatomic)CGFloat maxWidth;

/***  frame变化方向,朝左或朝右 */
@property (nonatomic)XSLSearchTextFieldAnimationDirection animationDirection;

/**
 *  初始化方法
 *
 *  @param position self.layer.position (note: self.layer.position != self.frame.origin)
 *  @param minWidth 普通状态下的宽度。高度根据最小宽度自动设置
 *  @param maxWidth 搜索状态下的宽度
 *
 *  @return self
 */
- (instancetype)initWithPosition:(CGPoint)position minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth;

/**
 *  初始化方法,宽高设置默认。
 *
 *  @param point self.layer.position (note: self.layer.position != self.frame.origin)
 *
 *  @return self
 */

- (instancetype)initWithPosition:(CGPoint)point;

/**
 *  设置textField.text改变时执行的操作。
 */
- (void)setSearchHandle:(SearchHandle)handle;

@end
