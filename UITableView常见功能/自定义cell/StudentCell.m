//
//  StudentCell.m
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/4/4.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import "StudentCell.h"


@interface StudentCell()

@property (nonatomic,strong)UILabel * nameLabel;
@property (nonatomic,strong)UILabel * ageLabel;

@end



@implementation StudentCell

- (instancetype )initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self= [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UILabel * nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        UILabel * ageLabel = [[UILabel alloc] init];
        [self.contentView addSubview:ageLabel];
        self.ageLabel = ageLabel;
        
    }
    return self;
}



- (void)layoutSubviews{
    // cell的宽高
    CGFloat contentW = self.contentView.bounds.size.width;
    CGFloat contentH = self.contentView.bounds.size.height;
    
    CGFloat margin = 10;
    CGFloat nameX = 20;
    CGFloat nameH = contentH-margin*2;
    CGFloat nameW = 200;
    self.nameLabel.frame = CGRectMake(nameX, margin, nameW, nameH);
    
    CGFloat ageX = contentW - nameX - nameW;
    self.ageLabel.frame = CGRectMake(ageX, margin, nameW, nameH);
    
}



-(void)setStudent:(StudentModel *)student{
    _student = student;
    
    self.nameLabel.text = student.name;
    self.ageLabel.text = [NSString stringWithFormat:@"%ld",student.age];
}



//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
