//
//  YYTextTagExample.m
//  YYKitExample
//
//  Created by ibireme on 15/8/19.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYTextTagExample.h"
#import "YYText.h"
#import "UIView+YYAdd.h"
#import "YYTextExampleHelper.h"

@interface YYTextTagExample () <YYTextViewDelegate>
@property (nonatomic, assign) YYTextView *textView;
@end

@implementation YYTextTagExample

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSArray *tags = @[@"◉red", @"◉orange", @"◉yellow", @"◉green", @"◉blue", @"◉purple", @"◉gray"];
    
    NSArray *tagStrokeColors = @[
        UIColorHex(fa3f39),
        UIColorHex(f48f25),
        UIColorHex(f1c02c),
        UIColorHex(54bc2e),
        UIColorHex(29a9ee),
        UIColorHex(c171d8),
        UIColorHex(818e91)
    ];
    
    NSArray *tagFillColors = @[
        UIColorHex(fb6560),
        UIColorHex(f6a550),
        UIColorHex(f3cc56),
        UIColorHex(76c957),
        UIColorHex(53baf1),
        UIColorHex(cd8ddf),
        UIColorHex(a4a4a7)
    ];

    UIFont *font = [UIFont boldSystemFontOfSize:16];
    for (int i = 0; i < tags.count; i++) {
        NSString *tag = tags[i];
        UIColor *tagStrokeColor = tagStrokeColors[i];//外框线本身的颜色
        UIColor *tagFillColor = tagFillColors[i];//框线围起来的封闭区域内部的填充颜色
        //1.文字
        //得到原始的富文本文字内容
        NSMutableAttributedString *tagText = [[NSMutableAttributedString alloc] initWithString:tag];
        //文字俩端插入俩个空格【是文字和border之间的padding设置】
        [tagText yy_insertString:@"   " atIndex:0];
        [tagText yy_appendString:@"   "];
        //文字格式设置
        tagText.yy_font = font;
        tagText.yy_color = [UIColor whiteColor];
        //文字和show绑定，设置为NO，删除的时候直接一步到位，不会小蒙版盖住整体了
        [tagText yy_setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:tagText.yy_rangeOfAll];
        
        
        //2.框线【border】
        YYTextBorder *border = [YYTextBorder new];
        border.strokeWidth = 1.5;
        border.strokeColor = tagStrokeColor;
        border.fillColor = tagFillColor;
        border.cornerRadius = 100; // a huge value
        border.lineJoin = kCGLineJoinBevel;//拐弯接合处的线条接合类型 -- 平角
 
        border.insets = UIEdgeInsetsMake(-2, -5.5, -2, -8);
        
        //3.给文字设置背景框线，是backgroundBorder
        [tagText yy_setTextBackgroundBorder:border range:[tagText.string rangeOfString:tag]];
        
        //4.在外端原始的text文本后边追加刚形成的富文本文字
        [text appendAttributedString:tagText];
    }
    
    //俩行之间的距离【上行的底端和上行的顶端之间的距离】
    text.yy_lineSpacing = 10;
    //换行还是根据内部的text，这个和text的border啥的没什么关系
    text.yy_lineBreakMode = NSLineBreakByWordWrapping;
    
    //循环结束之后，往最后的位置追加一个换行符，然后把输入热点唤醒
    [text yy_appendString:@"\n"];
    [text appendAttributedString:text]; // repeat for test -- 这个UI界面中的东西是双份的，这边是复制了一份
    
    YYTextView *textView = [YYTextView new];
    textView.attributedText = text;
    textView.size = self.view.size;
    textView.textContainerInset = UIEdgeInsetsMake(10 + 64, 10, 10, 10);
    textView.allowsCopyAttributedString = YES;
    textView.allowsPasteAttributedString = YES;
    textView.delegate = self;
    if (kiOS7Later) {
        //UIScrollViewKeyboardDismissModeOnDrag,向上或者向下拖曳scrollView的时候，键盘都会向下收回去
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;//拖动scrollView(向下方向)到某点触到键盘区域，此时键盘会跟着往下收回去
    } else {
        textView.height -= 64;
    }
    textView.scrollIndicatorInsets = textView.contentInset;
    textView.selectedRange = NSMakeRange(text.length, 0);
    [self.view addSubview:textView];
    self.textView = textView;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [textView becomeFirstResponder];
    });
}



#pragma mark text view
- (void)textViewDidBeginEditing:(YYTextView *)textView {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                target:self
                                                                                action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)edit:(UIBarButtonItem *)item {
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    } else {
        [_textView becomeFirstResponder];
    }
}

- (void)textViewDidEndEditing:(YYTextView *)textView {
    self.navigationItem.rightBarButtonItem = nil;
}

@end
