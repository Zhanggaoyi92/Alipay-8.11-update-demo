//
//  Fg_tableView.h
//  支付宝跟新demo
//
//  Created by zgy_smile on 16/8/12.
//  Copyright © 2016年 zgy_smile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Fg_tableView : UITableView
@property(assign,nonatomic)CGFloat contentOffsetY;
-(void)startRefreshing;
-(void)endRefreshing;
@end
