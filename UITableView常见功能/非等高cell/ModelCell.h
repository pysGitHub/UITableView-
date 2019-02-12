//
//  ModelCell.h
//  UITableView常见功能
//
//  Created by 潘远生 on 2018/5/24.
//  Copyright © 2018年 Wistron. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Model;
@interface ModelCell : UITableViewCell
/** 将模型作为cell的一个属性，对cell进行模型赋值 */
@property (nonatomic,strong)Model * model;

@end
