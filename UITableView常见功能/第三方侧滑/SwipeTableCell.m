//
//  SwipeTableCell.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/31.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "SwipeTableCell.h"
#import "SwipeModel.h"
#import "Masonry.h"

@interface SwipeTableCell()

@property (nonatomic,strong)UILabel * descLabel;
@property (nonatomic,strong)UILabel * pubdateLabel;
@property (nonatomic,strong)UILabel * collectionLabel;
@end

@implementation SwipeTableCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self getUI];
    }
    return self;
}


- (void)getUI{
    self.descLabel = [[UILabel alloc] init];
    self.descLabel.font = [UIFont systemFontOfSize:14.0f];
    self.descLabel.numberOfLines = 0;
    [self.contentView addSubview:self.descLabel];
    
    
    self.pubdateLabel = [[UILabel alloc] init];
    self.pubdateLabel.font = [UIFont systemFontOfSize:16.0f];
    self.pubdateLabel.numberOfLines = 1;
    self.pubdateLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:self.pubdateLabel];
    
    
    
    self.collectionLabel = [[UILabel alloc] init];
    self.collectionLabel.font = [UIFont systemFontOfSize:10.0f];
    self.collectionLabel.text = [NSString stringWithFormat:@"收藏"];
    self.collectionLabel.textColor = [UIColor greenColor];
    [self.contentView addSubview:self.collectionLabel];
    
    
    
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    
    [self.pubdateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(-10);
        //注意,不管布局多复杂,一定要有相对于cell.contentView的bottom的约束
        make.bottom.mas_equalTo(-10);
    }];
    
    
    [self.collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(self.pubdateLabel.mas_bottom);
    }];
}



-(void)setModel:(SwipeModel *)model{
    _model = model;
    
    self.descLabel.text = model.desc;
    self.pubdateLabel.text = model.pubdate;
    
    if (model.collection) {
        self.collectionLabel.hidden = NO;
        self.contentView.backgroundColor = [UIColor orangeColor];
    }else{
        self.collectionLabel.hidden = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
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
