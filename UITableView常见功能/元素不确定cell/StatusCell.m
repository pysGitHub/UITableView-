//
//  StatusCell.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/23.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "StatusCell.h"
#import "Masonry.h"
#import "StatusModel.h"

@interface StatusCell()

@property (weak, nonatomic) UIImageView *iconView;
@property (weak, nonatomic) UILabel *nameLabel;
@property (weak, nonatomic) UIImageView *vipView;
@property (weak, nonatomic) UILabel *contentLabel;
@property (weak, nonatomic) UIImageView *pictureView;
@property (weak, nonatomic) UIButton *foldLabel;
@end
@implementation StatusCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self loadUI];
    }
    return self;
}


- (void)loadUI{
    
    UIImageView * imageView = [[UIImageView alloc] init];
    self.iconView = imageView;
    
    
    UILabel * label = [[UILabel alloc] init];
    label.textColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20.f];
    //[label sizeToFit];
    self.nameLabel = label;
    
    
    UIImageView * vipImage = [[UIImageView alloc] init];
    self.vipView = vipImage;
    
    
    UILabel * label1 = [[UILabel alloc] init];
    label1.textColor = [UIColor blueColor];
    //label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:16.f];
    [label1 sizeToFit];
    self.contentLabel = label1;
    
    
    UIImageView * pictureImage = [[UIImageView alloc] init];
    self.pictureView = pictureImage;
    
    
    UIButton * foldLabel = [[UIButton alloc] init];
    foldLabel.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [foldLabel addTarget:self action:@selector(foldNewsOrNoTap:) forControlEvents:UIControlEventTouchUpInside];
    foldLabel.backgroundColor = [UIColor redColor];
    self.foldLabel = foldLabel;
    
    
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.vipView];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.pictureView];
    [self.contentView addSubview:self.foldLabel];
    
    
    
    // 设置frame
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(40);
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.top.mas_equalTo(self.iconView.mas_top);
    }];
    
    
    [self.vipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10);
        make.width.height.mas_equalTo(16);
    }];
    
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    //self.contentLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width-20;

    
    [self.pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(100);
    }];
    
    
    [self.foldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(40);
    }];
    
}




- (void)foldNewsOrNoTap:(UITapGestureRecognizer *)recognizer{
    
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(clickFoldLabel:)]) {
        
        [self.cellDelegate clickFoldLabel:self];
    }
}






- (void)setStatusModel:(StatusModel *)statusModel{
    _statusModel = statusModel;
    
    
    self.iconView.image = [UIImage imageNamed:statusModel.icon];
    
    
    self.nameLabel.text = statusModel.name;
    self.nameLabel.numberOfLines = 1;

    
    
    self.vipView.image = [UIImage imageNamed:@"vip"];
    if (statusModel.vip) {
        self.nameLabel.textColor = [UIColor orangeColor];
        self.vipView.hidden = NO;
    } else {
        self.nameLabel.textColor = [UIColor blackColor];
        self.vipView.hidden = YES;
    }
    
    
    self.contentLabel.text = statusModel.text;
    self.contentLabel.numberOfLines = 0;
    // 获取文本内容宽度，计算展示全部文本所需高度
    CGFloat contentW = [UIScreen mainScreen].bounds.size.width - 20;
    NSString *contentStr = self.contentLabel.text;
    
    NSMutableParagraphStyle *descStyle = [[NSMutableParagraphStyle alloc]init];
    
    //    //行间距
    //    [descStyle setLineSpacing:3];
    
    CGRect textRect = [contentStr
                       boundingRectWithSize:CGSizeMake(contentW, MAXFLOAT)
                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                       attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0f], NSParagraphStyleAttributeName : descStyle}
                       context:nil];
    // 这里的高度60是通过指定显示三行文字时，通过打印得到的一个临界值，根据需要自行修改
    // 超过三行文字，折叠按钮不显示
    if (textRect.size.height > 40) {
        // 打开折叠按钮
        self.foldLabel.hidden = NO;
        // 修改按钮的折叠打开状态
        if (statusModel.isOpening) {
            
            self.contentLabel.numberOfLines = 0;
            [self.foldLabel setTitle: @"收起" forState: UIControlStateNormal];
        }else{
            
            self.contentLabel.numberOfLines = 2;
            [self.foldLabel setTitle: @"展开" forState: UIControlStateNormal];
        }
    }else{
        
        self.contentLabel.numberOfLines = 0;
        self.foldLabel.hidden = YES;
    }
    
    
    if (statusModel.picture) {
        self.pictureView.hidden = NO;
        self.pictureView.image = [UIImage imageNamed:statusModel.picture];
    }else{
        self.pictureView.hidden = YES;
    }
    
    // 强制布局算出cell的真实高度
    [self layoutIfNeeded];
    if (self.pictureView.hidden) { // 没有配图
        self.statusModel.height =  CGRectGetMaxY(self.contentLabel.frame) + 10;
    } else { // 有配图
        self.statusModel.height =  CGRectGetMaxY(self.pictureView.frame) + 10;
    }
}



- (CGFloat)height
{
    if (self.pictureView.hidden) { // 没有配图
        return CGRectGetMaxY(self.contentLabel.frame) + 10;
    } else { // 有配图
        return CGRectGetMaxY(self.pictureView.frame) + 10;
    }
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
