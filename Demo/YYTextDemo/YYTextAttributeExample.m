//
//  YYTextAttributeExample.m
//  YYKitExample
//
//  Created by ibireme on 15/8/19.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYTextAttributeExample.h"
#import "YYText.h"
#import "YYTextExampleHelper.h"
#import "UIImage+YYWebImage.h"
#import "UIView+YYAdd.h"
#import "NSString+YYAdd.h"

@implementation YYTextAttributeExample

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    __weak typeof(self) _self = self;
    [YYTextExampleHelper addDebugOptionToViewController:self];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    //底下每个框{}都只追加一个单词，每个单词都赋予了特定的样式范例
    {
        //这些 NSMutableAttributedString 的yy相关属性都是通过分类文件来插入的
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Shadow"];
        one.yy_font = [UIFont boldSystemFontOfSize:30];
        one.yy_color = [UIColor whiteColor];
        YYTextShadow *shadow = [YYTextShadow new];
        shadow.color = [UIColor colorWithWhite:0.000 alpha:0.490];
        //效果上这个阴影是往下偏移的
        shadow.offset = CGSizeMake(0, 1);
        shadow.radius = 5;
        one.yy_textShadow = shadow;
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
    }
    
    {
        //内部阴影
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Inner Shadow"];
        one.yy_font = [UIFont boldSystemFontOfSize:30];
        one.yy_color = [UIColor whiteColor];
        YYTextShadow *shadow = [YYTextShadow new];
        shadow.color = [UIColor colorWithWhite:0.000 alpha:0.40];
        shadow.offset = CGSizeMake(0, 1);
        shadow.radius = 1;
        
        //设置内部阴影
        one.yy_textInnerShadow = shadow;
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
    }
    
    {
        //这串文字添加了三个阴影
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Multiple Shadows"];
        one.yy_font = [UIFont boldSystemFontOfSize:30];
        one.yy_color = [UIColor colorWithRed:1.000 green:0.795 blue:0.014 alpha:1.000];
        
        YYTextShadow *shadow = [YYTextShadow new];
        shadow.color = [UIColor colorWithWhite:0.000 alpha:0.20];
        //效果上该阴影往上偏移
        shadow.offset = CGSizeMake(0, -1);
        shadow.radius = 1.5;
        
        YYTextShadow *subShadow = [YYTextShadow new];
        subShadow.color = [UIColor colorWithWhite:1 alpha:0.99];
        subShadow.offset = CGSizeMake(0, 1);
        subShadow.radius = 1.5;
        shadow.subShadow = subShadow;
        one.yy_textShadow = shadow;
        
        YYTextShadow *innerShadow = [YYTextShadow new];
        innerShadow.color = [UIColor colorWithRed:0.851 green:0.311 blue:0.000 alpha:0.780];
        innerShadow.offset = CGSizeMake(0, 1);
        innerShadow.radius = 1;
        one.yy_textInnerShadow = innerShadow;
        
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
    }
    
    {
        //文字内部填充的是一个图案
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Background Image"];
        one.yy_font = [UIFont boldSystemFontOfSize:30];
        one.yy_color = [UIColor colorWithRed:1.000 green:0.795 blue:0.014 alpha:1.000];
        
        CGSize size = CGSizeMake(20, 20);
        #warning 画图部分得看下其他内容【这种样式用到的可能也会比较少】
        UIImage *background = [UIImage yy_imageWithSize:size drawBlock:^(CGContextRef context) {
            UIColor *c0 = [UIColor colorWithRed:0.054 green:0.879 blue:0.000 alpha:1.000];
            UIColor *c1 = [UIColor colorWithRed:0.869 green:1.000 blue:0.030 alpha:1.000];
            [c0 setFill];
            CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
            [c1 setStroke];
            CGContextSetLineWidth(context, 2);
            for (int i = 0; i < size.width * 2; i+= 4){
                CGContextMoveToPoint   (context, i, -2);
                CGContextAddLineToPoint(context, i - size.height, size.height + 2);
            }
            CGContextStrokePath(context);
        }];
        one.yy_color = [UIColor colorWithPatternImage:background];
        
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
    }
    
    {
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Border"];
        one.yy_font = [UIFont boldSystemFontOfSize:30];
        one.yy_color = [UIColor colorWithRed:1.000 green:0.029 blue:0.651 alpha:1.000];
        
        //文字外边框
        YYTextBorder *border = [YYTextBorder new];
        border.strokeColor = [UIColor colorWithRed:1.000 green:0.029 blue:0.651 alpha:1.000];
        border.strokeWidth = 3;
        //外框线条样式:虚线 线条是由圆点组成的
        border.lineStyle = YYTextLineStylePatternCircleDot;//YYTextLineStyle
        border.cornerRadius = 3;
        //左右向内聚拢4个像素
        border.insets = UIEdgeInsetsMake(0, -4, 0, -4);
        
        one.yy_textBackgroundBorder = border;
        
        //换行  位置调整下
        [text appendAttributedString:[self padding]];
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
        [text appendAttributedString:[self padding]];
        [text appendAttributedString:[self padding]];
        [text appendAttributedString:[self padding]];
    }
    
    {
        //链接样式，具备点击触发功效
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Link"];
        one.yy_font = [UIFont boldSystemFontOfSize:30];
        one.yy_underlineStyle = NSUnderlineStyleSingle;
        
        /// 1. you can set a highlight with these code
        /*
            one.yy_color = [UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000];

            YYTextBorder *border = [YYTextBorder new];
            border.cornerRadius = 3;
            border.insets = UIEdgeInsetsMake(-2, -1, -2, -1);
            border.fillColor = [UIColor colorWithWhite:0.000 alpha:0.220];
            
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBorder:border];
            highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                [_self showMessage:[NSString stringWithFormat:@"Tap: %@",[text.string substringWithRange:range]]];
            };
            [one yy_setTextHighlight:highlight range:one.yy_rangeOfAll];
        */
        
        /// 2. or you can use the convenience method
        /*
        @param containerView The text container view (such as YYLabel/YYTextView).
        @param text          The whole text.
        @param range         The text range in `text` (if no range, the range.location is NSNotFound).
        @param rect          The text frame in `containerView` (if no data, the rect is CGRectNull).*/
        [one yy_setTextHighlightRange:one.yy_rangeOfAll
                                color:[UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000]
                      backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                //此处点击事件
                                [_self showMessage:[NSString stringWithFormat:@"Tap: %@",[text.string substringWithRange:range]]];
                            }];
        
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
    }
    
    {
        //圆角外边线的链接样式（该链接是没有下划线的）
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Another Link"];
        one.yy_font = [UIFont boldSystemFontOfSize:30];
        one.yy_color = [UIColor redColor];
        
        //normal状态下的样式
        YYTextBorder *border = [YYTextBorder new];
        border.cornerRadius = 50;
        border.insets = UIEdgeInsetsMake(0, -10, 0, -10);
        border.strokeWidth = 0.5;
        border.strokeColor = one.yy_color;
        border.lineStyle = YYTextLineStyleSingle;
        //将YYTextBorder属性设置给字符串
        one.yy_textBackgroundBorder = border;
        
        //点击后高亮的样式【框内非文字的部分填充红色，文字部分内部填充白色】
        YYTextBorder *highlightBorder = border.copy;//copy应为深复制
        highlightBorder.strokeWidth = 0;
        highlightBorder.strokeColor = one.yy_color;//线条本身的颜色
        highlightBorder.fillColor = one.yy_color;//线条团起来封闭的空间内的填充颜色
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setColor:[UIColor whiteColor]];
        [highlight setBackgroundBorder:highlightBorder];//这行将高亮的文字样式和高亮(or点击状态下)的外边框样式绑定起来了。之后将文字样式赋给文字即可
        
        //tapAction是所有YYAttributeString所属的触发事件
        highlight.tapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
            [_self showMessage:[NSString stringWithFormat:@"Tap: %@",[text.string substringWithRange:range]]];
        };
        [one yy_setTextHighlight:highlight range:one.yy_rangeOfAll];
        
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
    }
    
    {
        //链接样式，没有外边框，点击时文字内部的填充颜色改变成浅黄色
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Yet Another Link"];
        one.yy_font = [UIFont boldSystemFontOfSize:30];
        one.yy_color = [UIColor whiteColor];
        
        //文字本身阴影设置
        YYTextShadow *shadow = [YYTextShadow new];
        shadow.color = [UIColor colorWithWhite:0.000 alpha:0.490];
        shadow.offset = CGSizeMake(0, 1);//阴影偏移向上？
        shadow.radius = 5;
        one.yy_textShadow = shadow;
        
        YYTextShadow *shadow0 = [YYTextShadow new];
        shadow0.color = [UIColor colorWithWhite:0.000 alpha:0.20];
        shadow0.offset = CGSizeMake(0, -1);
        shadow0.radius = 1.5;
        YYTextShadow *shadow1 = [YYTextShadow new];
        shadow1.color = [UIColor colorWithWhite:1 alpha:0.99];
        shadow1.offset = CGSizeMake(0, 1);
        shadow1.radius = 1.5;
        shadow0.subShadow = shadow1;
        
        YYTextShadow *innerShadow0 = [YYTextShadow new];
        innerShadow0.color = [UIColor colorWithRed:0.851 green:0.311 blue:0.000 alpha:0.780];
        innerShadow0.offset = CGSizeMake(0, 1);
        innerShadow0.radius = 1;
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setColor:[UIColor colorWithRed:1.000 green:0.795 blue:0.014 alpha:1.000]];
        [highlight setShadow:shadow0];
        [highlight setInnerShadow:innerShadow0];
        [one yy_setTextHighlight:highlight range:one.yy_rangeOfAll];
        
        [text appendAttributedString:one];
    }
    
    
    YYLabel *label = [YYLabel new];
    //最上方的text的设置到这边了
    label.attributedText = text;
    label.width = self.view.width;
    label.height = self.view.height - (kiOS7Later ? 64 : 44);
    label.top = (kiOS7Later ? 64 : 0);
    label.textAlignment = NSTextAlignmentCenter;
    label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    [self.view addSubview:label];
    
    /*
     If the 'highlight.tapAction' is not nil, the label will invoke 'highlight.tapAction' 
     and ignore 'label.highlightTapAction'.
     
     If the 'highlight.tapAction' is nil, you can use 'highlightTapAction' to handle
     all tap action in this label.
     */
    label.highlightTapAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
        [_self showMessage:[NSString stringWithFormat:@"Tap: %@",[text.string substringWithRange:range]]];
    };
}

//俩行文字间隔了俩个换行符
- (NSAttributedString *)padding {
    NSMutableAttributedString *pad = [[NSMutableAttributedString alloc] initWithString:@"\n\n"];
    pad.yy_font = [UIFont systemFontOfSize:4];
    return pad;
}

- (void)showMessage:(NSString *)msg {
    CGFloat padding = 10;
    
    YYLabel *label = [YYLabel new];
    label.text = msg;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.033 green:0.685 blue:0.978 alpha:0.730];
    label.width = self.view.width;
    label.textContainerInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    label.height = [msg heightForFont:label.font width:label.width] + 2 * padding;
    
    label.bottom = (kiOS7Later ? 64 : 0);
    [self.view addSubview:label];
    [UIView animateWithDuration:0.3 animations:^{
        label.top = (kiOS7Later ? 64 : 0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.bottom = (kiOS7Later ? 64 : 0);
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

@end
