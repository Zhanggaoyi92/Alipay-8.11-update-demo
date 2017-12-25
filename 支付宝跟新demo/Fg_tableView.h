//
//  Fg_tableView.h
//  支付宝跟新demo
//
//  Created by zgy_smile on 16/8/12.
//  Copyright © 2016年 zgy_smile. All rights reserved.
//

#import <UIKit/UIKit.h>

#define fg_rowHeight 120   //行高
#define fg_rowNumber 100  //行数
#define fg_headerViewHeight 310 //头部视图的高度

@interface Fg_tableView : UITableView
@property(assign,nonatomic)CGFloat contentOffsetY;
-(void)startRefreshing;
-(void)endRefreshing;
@end
