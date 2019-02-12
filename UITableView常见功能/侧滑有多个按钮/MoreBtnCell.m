//
//  MoreBtnCell.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/29.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "MoreBtnCell.h"
#import "MoreBtnModel.h"
#import "Masonry.h"
@interface MoreBtnCell ()

@property (nonatomic,strong)UILabel * contentLabel;
@property (nonatomic,strong)UIImageView * iconImage;

@end

@implementation MoreBtnCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    return self;
}


- (void)createUI{
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.iconImage];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(20);
        make.bottom.mas_equalTo(-10);
    }];
    
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(20);
        make.right.mas_equalTo(-10);
    }];
}



- (UILabel *)contentLabel{
    if (!_contentLabel) {
        UILabel * label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor orangeColor];
        _contentLabel = label;
    }
    return  _contentLabel;
}



- (UIImageView *)iconImage{
    if (!_iconImage) {
        UIImageView * iamgeView = [[UIImageView alloc] init];
        _iconImage = iamgeView;
    }
    return _iconImage;
}




-(void)setModel:(MoreBtnModel *)model{
    _model = model;
    
    self.contentLabel.text = model.content;
    self.iconImage.image = [UIImage imageNamed:model.icon];
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
