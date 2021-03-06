//
//  LGcollectionCell.m
//  titleScroll
//
//  Created by jamy on 15/7/4.
//  Copyright (c) 2015年 jamy. All rights reserved.
//

#import "LGcollectionCell.h"

@interface LGcollectionCell ()
{
    UIColor *_tintColor;
}
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation LGcollectionCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setUp];
    }
    return self;
}

- (void)setUp
{
//    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _tintColor = [UIColor blackColor];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:0x8c/255.0 green:0x8c/255.0 blue:0x8c/255.0 alpha:1.0];
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
//    UIView *selectView = [[UIView alloc] init];
//    selectView.backgroundColor = [UIColor groupTableViewBackgroundColor];
//    self.selectedBackgroundView = selectView;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    self.titleLabel.frame = CGRectMake(0, 0, width, height*0.9);
}

-(void)setTitleName:(NSString *)titleName
{
    if (self.titleName != titleName) {
        _titleName = titleName;
        [_titleLabel setText:titleName];
    }
}

- (void)setTintColor:(UIColor *)tintColor
{
    _tintColor = tintColor;
}

- (UIColor *)tintColor
{
    return _tintColor;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected)
    {
        self.titleLabel.textColor = self.tintColor;
    }
    else
    {
        self.titleLabel.textColor = [UIColor colorWithRed:0x8c/255.0 green:0x8c/255.0 blue:0x8c/255.0 alpha:1.0];
    }
}

@end
