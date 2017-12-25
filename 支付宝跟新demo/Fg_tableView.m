//
//  Fg_tableView.m
//  支付宝跟新demo
//
//  Created by zgy_smile on 16/8/12.
//  Copyright © 2016年 zgy_smile. All rights reserved.
//

#import "Fg_tableView.h"
#import <MJRefresh.h>

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
@interface Fg_tableView ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation Fg_tableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.rowHeight = fg_rowHeight;
//        [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:nil];
    }
    return self;
}

-(void)setContentOffsetY:(CGFloat)contentOffsetY {
    
    _contentOffsetY = contentOffsetY;
    if (![self.mj_header isRefreshing]) {
        
        self.contentOffset = CGPointMake(0, contentOffsetY);
    }
}

-(void)startRefreshing {
    [self.mj_header beginRefreshing];
}
-(void)endRefreshing {
    [self.mj_header endRefreshing];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return fg_rowNumber;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"看下会不会抖动---%ld",indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
