//
//  ZFBoard.m
//  ZFBoard
//
//  Created by 张帆 on 2018/12/19.
//  Copyright © 2018 张帆. All rights reserved.
//

#import "ZFBoard.h"
#import <Masonry.h>


@implementation ZFBoardLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
    }
    return self;
}

- (void)setText:(NSString *)text {
    [super setText:text];
    self.hidden = !(text && text.length > 0);
}

@end



@implementation ZFBoardImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
    }
    return self;
}

- (void)setImage:(UIImage *)image {
    [super setImage:image];
    self.hidden = !image;
}


@end


@interface ZFBoardButton ()
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic, strong) CALayer *statusLayer;
@property (nonatomic, assign) float height;
@end

@implementation ZFBoardButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.statusLayer = [CALayer layer];
        self.layer.masksToBounds = YES;
        [self.layer addSublayer:self.statusLayer];
        [self.statusLayer setFrame:CGRectMake(0, 0, 0, 44)];
        
        [self setBackgroundColor:ZFBOARD_UNABLE_BUTTON_BACKGROUND_COLOR];
        
    }
    return self;
}


- (void)setType:(ZFBoardButtonType)type {
    if (_type == type) {
        return;
    }
    _type = type;
    switch (type) {
        case ZFBoardButtonTypeNOMAL:
            [self.statusLayer setBackgroundColor:ZFBOARD_NOMAL_BUTTON_BACKGROUND_COLOR.CGColor];
            [self.statusLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            self.userInteractionEnabled = YES;
            NSLog(@"ZFBoardButtonTypeNOMAL");
            break;
        case ZFBoardButtonTypeUNABLE:
            [self.statusLayer setBackgroundColor:ZFBOARD_UNABLE_BUTTON_BACKGROUND_COLOR.CGColor];
            [self.statusLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            self.userInteractionEnabled = NO;
            NSLog(@"ZFBoardButtonTypeUNABLE");
            break;
        case ZFBoardButtonTypeLOADING: {
            [self.statusLayer setBackgroundColor:ZFBOARD_NOMAL_BUTTON_BACKGROUND_COLOR.CGColor];
            [self.statusLayer setFrame:CGRectMake(0, 0, 0, self.frame.size.height)];
            self.userInteractionEnabled = NO;
            NSLog(@"ZFBoardButtonTypeLOADING");
            break;
        }
        case ZFBoardButtonTypeSUCCESS: {
            [self.statusLayer setBackgroundColor:ZFBOARD_DONE_BUTTON_BACKGROUND_COLOR.CGColor];
            [self.statusLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            self.userInteractionEnabled = YES;
            NSLog(@"ZFBoardButtonTypeSUCCESS");
            break;
        }
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.height != self.frame.size.height) {
        NSLog(@"change frame:%.2f", self.frame.size.height);
        self.height = self.frame.size.height;
        if (self.type!=ZFBoardButtonTypeLOADING) {
            [self.statusLayer setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        }
        
    }
}

- (void)setProgress:(float)progress {
    if (self.type != ZFBoardButtonTypeLOADING) {
        self.type = ZFBoardButtonTypeLOADING;
        NSLog(@"chage type");
    }
    if (_progress == progress) {
        return;
    }
    NSLog(@"%.2f", progress);
    _progress = progress<0?0:progress>1?1:progress;
    float w = self.frame.size.width * progress;
    [self.statusLayer setFrame:CGRectMake(0, 0, w, self.frame.size.height)];
}


- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    self.hidden = !title;
}


@end


#pragma mark -
#pragma mark ZFBoardItem


@interface ZFBoardItem ()

@property (nonatomic, strong, nullable) ZFBoardItem *perviousItem;
@property (nonatomic, strong, nullable) ZFBoardItem *nextItem;

@end

@implementation ZFBoardItem

- (instancetype)init
{
    self = [super init];
    if (self) {

        _titleFont = [UIFont systemFontOfSize:18];
        _titleColor = [UIColor blackColor];
        
        _detial1textFont = [UIFont systemFontOfSize:15];
        _detial1textColor = [UIColor blackColor];
        
        _detial2textFont = [UIFont systemFontOfSize:13];
        _detial2textColor = ZFBOARD_GARY_TEXT_COLOR;
        
        _introduceTextFont = [UIFont systemFontOfSize:15];
        _introduceTextColor = ZFBOARD_GARY_TEXT_COLOR;
        
        _actionButtonBackgroundColor = ZFBOARD_NOMAL_BUTTON_BACKGROUND_COLOR;
        _actionButtonCornerRadius = 10;
        
        _closeButtonImageName = @"closeicon";
    }
    return self;
}

- (ZFBoardItem * _Nonnull (^)(ZFBoardItem * _Nonnull))next {
    return ^ZFBoardItem*(ZFBoardItem *item) {
        self.nextItem = item;
        item.perviousItem = self;
        return item;
    };
}

@end

#pragma mark -
#pragma mark ZFBoardItemsVC

@interface ZFBoardItemsVC ()

- (void)loadItem:(ZFBoardItem *)item;
@end

@implementation ZFBoardItemsVC


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView = ({
            UIView *view = [[UIView alloc] init];
            [self.view addSubview:view];
            view.layer.cornerRadius = 20;
            view.layer.masksToBounds = YES;
            view.backgroundColor = UIColor.whiteColor;
            view;
        });
        
        self.titleLabel = ({
            ZFBoardLabel *label = [[ZFBoardLabel alloc] init];
            label;
        });
        
        self.closeButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.contentView addSubview:button];
//            [button setBackgroundColor:UIColor.blackColor];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.contentView).offset(10);
                make.right.mas_equalTo(self.contentView).mas_offset(-10);
                make.height.mas_equalTo(44);
                make.width.mas_equalTo(44);
            }];
            [button setImage:[UIImage imageNamed:@"closeicon-1"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        self.imageView = ({
            ZFBoardImageView *imageView = [[ZFBoardImageView alloc] init];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.width.mas_offset(100);
                make.height.mas_equalTo(100);
            }];
            imageView;
        });
        
        
        self.detialLabel1 = ({
            ZFBoardLabel *label = [[ZFBoardLabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        
        
        self.detialLabel2 = ({
            ZFBoardLabel *label = [[ZFBoardLabel alloc] init];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        UIStackView *stackV = ({
            UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
                                                                                     self.detialLabel1,
                                                                                     self.detialLabel2,
                                                                                     ]];
            [stackView setAxis:UILayoutConstraintAxisVertical];
            [stackView setSpacing:5];
            [stackView setAlignment:UIStackViewAlignmentCenter];
            [stackView setDistribution:UIStackViewDistributionFill];
            stackView;
        });
        
        self.introduceLabel = ({
            ZFBoardLabel *label = [[ZFBoardLabel alloc] init];
            label.numberOfLines = 0;
            label;
            
        });
        
        self.indicatorView = ({
            UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] init];
            [indicatorView setHidesWhenStopped:YES];
            indicatorView;
        });
        
        self.customView = ({
            UIView *view = [[UIView alloc] init];
            view;
        });
        
        self.actionButton = ({
            ZFBoardButton *button = [ZFBoardButton buttonWithType:UIButtonTypeCustom];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(44);
            }];
            [button addTarget:self action:@selector(actionBUttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button;
        });
        
        self.stackView = ({
            UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[
                                                                                     self.titleLabel,
                                                                                     self.imageView,
                                                                                     stackV,
                                                                                     self.introduceLabel,
                                                                                     self.actionButton,
                                                                                     ]];
            [stackView setAxis:UILayoutConstraintAxisVertical];
            [stackView setAlignment:UIStackViewAlignmentFill];
            [stackView setDistribution:UIStackViewDistributionFill];
            [stackView setSpacing:30];
            [self.contentView addSubview:stackView];
            [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.contentView).mas_offset(-30);
                make.right.mas_equalTo(self.contentView).offset(-20);
                make.left.mas_equalTo(self.contentView).offset(20);
            }];
            
            stackView;
        });
        
        
    }
    return self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.contentView bringSubviewToFront:self.closeButton];
}
- (void)viewDidLoad {
    
    [self.view setBackgroundColor:[UIColor colorWithWhite:.2 alpha:.4]];
    
}

- (NSArray *)additionalSubviews {
    ZFBoardItem *perviousItem = self.currentItem.perviousItem;
    if (perviousItem) {
        NSMutableArray *arr= [NSMutableArray arrayWithCapacity:10];
        if (!(perviousItem.title && self.currentItem.title)) {
            [arr addObject:self.titleLabel];
        }
        if (!(perviousItem.imageName && self.currentItem.imageName)) {
            [arr addObject:self.imageView];
        }
        if (!(perviousItem.detial1text && self.currentItem.detial1text)) {
            [arr addObject:self.detialLabel1];
        }
        if (!(perviousItem.detial2text && self.currentItem.detial2text)) {
            [arr addObject:self.detialLabel2];
        }
        if (!(perviousItem.detial2text && self.currentItem.detial2text)) {
            [arr addObject:self.detialLabel2];
        }
        if (!(perviousItem.introduceText && self.currentItem.introduceText)) {
            [arr addObject:self.introduceLabel];
        }
        if (!(perviousItem.actionButtonTitle && self.currentItem.actionButtonTitle)) {
            [arr addObject:self.actionButton];
        }
        if (arr.count > 0) {
            return arr;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}



- (void)loadItem:(ZFBoardItem *)item {
    if (!item) {
        NSLog(@"NO items");
        return;
    }
    if (item.willShow) {
        item.willShow(item);
    }
    if (item.perviousItem.willDimiss) {
        item.perviousItem.willDimiss(item.perviousItem);
    }
    
    
    for (UIView *views in [self additionalSubviews]) {
        views.alpha = 0;
    }
    self.actionButton.titleLabel.alpha = 0;
    
    self.currentItem = item;
    [self.titleLabel setFont:item.titleFont];
    [self.titleLabel setText:item.title];
    [self.titleLabel setTextColor:item.titleColor];
    
    [self.imageView setImage:[UIImage imageNamed:item.imageName]];
    
    [self.detialLabel1 setText:item.detial1text];
    [self.detialLabel1 setTextColor:item.detial1textColor];
    [self.detialLabel1 setFont:item.detial1textFont];
    
    [self.detialLabel2 setText:item.detial2text];
    [self.detialLabel2 setTextColor:item.detial2textColor];
    [self.detialLabel2 setFont:item.detial2textFont];
    
    [self.introduceLabel setText:item.introduceText];
    [self.introduceLabel setTextColor:item.introduceTextColor];
    [self.introduceLabel setFont:item.introduceTextFont];
    
    self.actionButton.layer.cornerRadius = item.actionButtonCornerRadius;
    [self.actionButton setType:ZFBoardButtonTypeNOMAL];
    [self.actionButton setTitle:item.actionButtonTitle forState:UIControlStateNormal];
    
    [UIView animateWithDuration:.3 animations:^{
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(20);
            make.right.mas_equalTo(self.view).offset(-20);
            make.bottom.mas_equalTo(self.view).offset(0);
            make.height.mas_equalTo(self.stackView).offset(50);
        }];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.2 animations:^{
            self.actionButton.titleLabel.alpha = 1;
        }];
        
        for (UIView *views in [self additionalSubviews]) {
            [UIView animateWithDuration:.2 animations:^{
                views.alpha = 1;
            }];
        }
        if (item.didShow) {
            item.didShow(item);
        }
        
    }];
    
}

- (void)closeButtonClick:(ZFBoardButton *)sender {
    if (self.currentItem.closeButtonAction) {
        self.currentItem.closeButtonAction(sender);
    }
}

- (void)actionBUttonClick:(ZFBoardButton *)sender {
    if (self.currentItem.actionButtonAction) {
        self.currentItem.actionButtonAction(sender);
    }
}
@end

#pragma mark -
#pragma mark ZFBoard
@interface ZFBoard ()
@property (nonatomic, strong) NSArray<ZFBoardItem *> *items;
@end

@implementation ZFBoard


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.boardVc = ({
            ZFBoardItemsVC *boardVc = [[ZFBoardItemsVC alloc] init];
            boardVc.modalPresentationStyle = UIModalPresentationOverFullScreen;
            boardVc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            boardVc;
        });
        
    }
    return self;
}

- (void)showItems:(NSArray<ZFBoardItem *> *)items target:(UIViewController *)target {
    _items = items;
    ZFBoardItem *firstItem = items.firstObject;
    [self.boardVc loadItem:firstItem];
    [target presentViewController:self.boardVc animated:YES completion:^{
        
    }];
}
- (void)showItem:(ZFBoardItem *)item target:(UIViewController *)target {
    [self.boardVc loadItem:item];
    [target presentViewController:self.boardVc animated:YES completion:^{
        
    }];
}

- (void)showItem:(ZFBoardItem *)item {
    [self showItem:item target:[self rootViewController]];
}

- (UIViewController *)rootViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *vc = keyWindow.rootViewController;
    return vc;
}

- (void)loadNext {
    [self.boardVc loadItem:self.boardVc.currentItem.nextItem];
}

- (void)loadPervious {
    [self.boardVc loadItem:self.boardVc.currentItem.perviousItem];
}

- (void)hiden {
    [self.boardVc dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
