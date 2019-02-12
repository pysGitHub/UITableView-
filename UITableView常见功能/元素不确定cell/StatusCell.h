//
//  StatusCell.h
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/23.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StatusModel,StatusCell;


@protocol StatusCellDelegate <NSObject>
/**
 *  折叠按钮点击代理
 *
 *  @param cell 按钮所属cell
 */
- (void)clickFoldLabel:(StatusCell *)cell;

@end


@interface StatusCell : UITableViewCell

@property (nonatomic,strong)StatusModel * statusModel;
/** 代理 */
@property (nonatomic,assign)id<StatusCellDelegate> cellDelegate;


- (CGFloat)height;
@end
