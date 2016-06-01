//
//  ViewController.m
//  XSLSearchTextFieldDemo
//
//  Created by xsl on 16/5/25.
//  Copyright © 2016年 xsl. All rights reserved.
//

#import "ViewController.h"
#import "XSLSearchTextField.h"

@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
}


- (void)setupViews{
    XSLSearchTextField *textField = [[XSLSearchTextField alloc] initWithPosition:CGPointMake(300, 100)];
    textField.maxWidth = 200;
    textField.searchColor = [UIColor blackColor];
    textField.normalColor = [UIColor grayColor];
    [self.view addSubview:textField];
    [textField setSearchHandle:^(UITextField *textField) {
        NSLog(@"%@",textField.text);
    }];

    XSLSearchTextField *textField2 = [[XSLSearchTextField alloc] initWithPosition:CGPointMake(100, 200) minWidth:40 maxWidth:200];
    textField2.animationDirection = XSLSearchTextFieldAnimationDirectionRight;
    [self.view addSubview:textField2];
    [textField2 setSearchHandle:^(UITextField *textField) {
        NSLog(@"%@",textField.text);
    }];
    
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}


- (void)tap{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
