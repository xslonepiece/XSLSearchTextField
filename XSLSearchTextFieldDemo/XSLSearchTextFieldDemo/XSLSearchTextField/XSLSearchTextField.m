//
//  XSLSearchTextField.m
//  XSLSearchTextFieldDemo
//
//  Created by xsl on 16/5/25.
//  Copyright © 2016年 xsl. All rights reserved.
//

#import "XSLSearchTextField.h"
#import "XSLSearchButton.h"

static CGFloat defaultMaxWidth = 200.0f;
static CGFloat defaultMinWidth = 40.0f;
static CGFloat x = 10.0f;

@interface XSLSearchTextField ()<UITextFieldDelegate>
{
    CGRect _minRect;
    CGRect _maxRect;
}

@property (nonatomic,strong)XSLSearchButton *searchBtn;
@property (nonatomic,strong)SearchHandle handle;

@end

@implementation XSLSearchTextField

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - lazy load
- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(x, 0, _maxWidth - _minWidth + x, _height)];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.placeholder = @"请输入文字搜索...";
        _textField.font = [UIFont systemFontOfSize:13];
        _textField.delegate = self;
        _textField.textColor = [UIColor blueColor];
    }
    return _textField;
}

- (XSLSearchButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [[XSLSearchButton alloc] initWithFrame:CGRectMake(x, 0, _height, 0)];
        [_searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
        _searchBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    }
    return _searchBtn;
}

#pragma - init
- (instancetype)initWithPosition:(CGPoint)point{
    return [self initWithPosition:point minWidth:defaultMinWidth maxWidth:defaultMaxWidth];
}

- (instancetype)initWithPosition:(CGPoint)point minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth{
    self = [super init];
    if (self) {
        [self setPosition:point minWidth:minWidth maxWidth:maxWidth];
        [self setupViews];
        [self setupNotifications];
        self.animationDirection = XSLSearchTextFieldAnimationDirectionLeft;
    }
    return self;
}

#pragma mark -setup
- (void)setupViews{
    [self setFrame:_minRect];
    self.layer.position = _position;
    self.searchColor = [UIColor redColor];
    self.normalColor = [UIColor blueColor];
    self.clipsToBounds = YES;
    self.layer.cornerRadius = _height / 2;
    self.layer.borderWidth = 0.0f;
    [self addSubview:self.searchBtn];
}


- (void)setupNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
}

#pragma mark - set
- (void)setPosition:(CGPoint)point minWidth:(CGFloat)minWidth maxWidth:(CGFloat)maxWidth{
    _position = point;
    if (minWidth < defaultMinWidth ) {
        minWidth = defaultMinWidth;
    }
    _minWidth = minWidth;
    _height = minWidth - x;
    _minRect = CGRectMake(_position.x, _position.y, minWidth, _height);
    [self setMaxWidth:maxWidth];
}

- (void)setSearchHandle:(SearchHandle)handle{
    _handle = handle;
}

- (void)setNormalColor:(UIColor *)normalColor{
    _normalColor = normalColor;
    self.searchBtn.normalColor = normalColor;
}

- (void)setSearchColor:(UIColor *)searchColor{
    _searchColor = searchColor;
    self.searchBtn.seachingColor = _searchColor;
    self.layer.borderColor = searchColor.CGColor;
}

- (void)setMaxWidth:(CGFloat)maxWidth{
    if (maxWidth < _minWidth) {
        maxWidth = defaultMaxWidth;
    }
    _maxWidth = maxWidth;
    _maxRect = CGRectMake(_position.x, _position.y, _maxWidth, _height);
}

- (void)setAnimationDirection:(XSLSearchTextFieldAnimationDirection)animationDirection{
    _animationDirection = animationDirection;
    switch (_animationDirection) {
        case XSLSearchTextFieldAnimationDirectionLeft:{
            self.layer.anchorPoint = CGPointMake(1, 0);
            break;
        }
        case XSLSearchTextFieldAnimationDirectionRight:{
            self.layer.anchorPoint = CGPointMake(0, 0);
            break;
        }
        default:
            break;
    }
}

#pragma mark - actions
- (void)search:(XSLSearchButton *)sender {
    BOOL searchRecord = sender.searching;
    if (sender.clearEnable) {
        sender.clearEnable = NO;
        self.textField.text = nil;
        sender.searching = YES;
        if (![self.textField isFirstResponder]) {
            [self.textField becomeFirstResponder];
        }
    }else {
        sender.searching = !sender.searching;
        if (!searchRecord) {
            self.layer.borderWidth = 1.0f;
            [self addSubview:self.textField];
            self.textField.layer.opacity = 0.0f;
            [self.textField becomeFirstResponder];
        }else{
            [self.textField resignFirstResponder];
            [self.textField removeFromSuperview];
        }
        [UIView animateWithDuration:0.3f animations:^{
            if (searchRecord) {
                [self setFrame: _minRect];
                [self.layer setPosition:_position];
            }else{
                [self setFrame:_maxRect];
                [self.layer setPosition:_position];
            }
        } completion:^(BOOL finished) {
            if (!searchRecord) {
                self.textField.layer.opacity = 1.0f;
            }else{
                self.layer.borderWidth = 0.0f;
            }
        }];
    }
}

- (void)textFieldTextDidChange:(NSNotification *)notification{
    if (_textField == notification.object) {
        if (_textField.text.length == 0) {
            self.searchBtn.clearEnable = NO;
        }else if (!self.searchBtn.clearEnable) {
            self.searchBtn.clearEnable = YES;
        }
        if (self.handle) {
            self.handle(_textField);
        }
    }
}

- (void)textFieldTextDidEndEditing:(NSNotification *)notification{
    if (_textField == notification.object) {
        if (!self.searchBtn.clearEnable) {
            if (self.searchBtn.searching) {
                [self search:self.searchBtn];
            }
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}




@end
