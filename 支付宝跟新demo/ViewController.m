//
//  ViewController.m
//  支付宝跟新demo
//
//  Created by zgy_smile on 16/8/11.
//  Copyright © 2016年 zgy_smile. All rights reserved.
//

#import "ViewController.h"
#import "Fg_tableView.h"

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) Fg_tableView *tableView;
@property (weak, nonatomic) UIView *topView;
@property (strong, nonatomic) UIScrollView *rootView;
@property(assign,nonatomic) CGFloat lastY;
@property(strong,nonatomic) UIImageView * imageView;
@end

#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

-(void)setupUI {
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kWidth, 20)];
    titleLabel.text = @"支付宝首页更新demo";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
    
    self.rootView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, kWidth, kHeight-40)];
    self.rootView.contentSize = CGSizeMake(0, fg_headerViewHeight+fg_rowHeight*fg_rowNumber);
    self.rootView.scrollIndicatorInsets = UIEdgeInsetsMake(fg_headerViewHeight, 0, 0, 0);
    self.rootView.delegate = self;
    [self.view addSubview:self.rootView];
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 300)];
    self.topView = topView;
    topView.backgroundColor = [UIColor yellowColor];
    [self.rootView addSubview:topView];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    imageView.image = [UIImage imageNamed:@"monkey"];
    [topView addSubview:imageView];
    self.imageView = imageView;
    
    UILabel * dangban = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, kWidth, 150)];
    dangban.text = @"视差挡板";
    dangban.textAlignment = NSTextAlignmentCenter;
    dangban.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:dangban];
    
    Fg_tableView * tableView = [[Fg_tableView alloc] initWithFrame:CGRectMake(0, fg_headerViewHeight, kWidth, fg_rowHeight*fg_rowNumber) style:UITableViewStylePlain];
    self.tableView = tableView;
    [self.rootView addSubview:tableView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = scrollView.contentOffset.y;
    if (y <= 0) {
        CGRect newFrame = self.topView.frame;
        newFrame.origin.y = y;
        self.topView.frame = newFrame;
        
        newFrame = self.tableView.frame;
        newFrame.origin.y = y + 310;
        self.tableView.frame = newFrame;
        
        //偏移量给到tableview，tableview自己来滑动
        self.tableView.contentOffsetY = y;
        
        //滑动太快有时候不正确，这里是保护imageView 的frame为正确的。
        newFrame = self.imageView.frame;
        newFrame.origin.y = 0;
        self.imageView.frame = newFrame;
    } else {
        //视差处理
        CGRect newFrame = self.imageView.frame;
        newFrame.origin.y = y/2;
        self.imageView.frame = newFrame;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    // 松手时判断是否刷新
    CGFloat y = scrollView.contentOffset.y;
    if (y < - 65) {
        [self.tableView startRefreshing];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView endRefreshing];
        });
    }
}



@end
