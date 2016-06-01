//
//  XSLSearchButton.h
//  XSLSearchTextFieldDemo
//
//  Created by xsl on 16/5/25.
//  Copyright © 2016年 xsl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XSLSearchButton : UIButton

@property (nonatomic,strong)UIColor *normalColor;
@property (nonatomic,strong)UIColor *seachingColor;

/** 是否正在搜索 **/
@property (nonatomic)BOOL searching;

/** 是否可清除，只有正在搜索的按钮才能进入可清除状态 **/
@property (nonatomic)BOOL clearEnable;

@end
