# Alipay-8.11-update-demo
## 支付宝8.11跟新首页小demo<br/>
- 晚上买东西，用支付宝支付时，看到跟新了，手痒就敲了一下。
- 效果是这样的，向上滑动时，整个界面一起滑动，上面的视差效果忽略，很多demo的，自己搜就好了。然后是向下滑动时，如果上半部分视图显示完毕就不再跟着滑动，而是下面的tableview 在滑动了（这里有猫腻），然后拉出刷新控件，还可以刷新。(当然最好的方法是打开你的支付宝，上下滑动几下就清楚了)
- 说完废话上代码(核心部分)：
- 主要视图属性

```
@interface ViewController () <UIScrollViewDelegate>
// scrollView 在底部，topView、tableview是他的上下部分子视图
@property (strong, nonatomic) UIScrollView *rootView;
@property (weak, nonatomic) UIView *topView;
@property (weak, nonatomic) Fg_tableView *tableView;
```
- 后面处理视差图片做了一个调整处理（这不是重点，后6行代码可以不看）

```
@implementation ViewController
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
        CGFloat y = scrollView.contentOffset.y;
    if (y <= 0) {
        //这是上半部分视图显示完毕后，下拉处理，伴随scrollView移动，看起来像是没动
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
```
- 然后是tableview 接收到来自scrollView 的偏移量的处理

```
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        //这是根据固定的tableview 高度去计算的 rowheight
        self.rowHeight = (kHeight * 5 - 310) / 20;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:nil];
    }
    return self;
}

-(void)setContentOffsetY:(CGFloat)contentOffsetY {
    // 这里就转化成tableview 自己滑动的假象了
    _contentOffsetY = contentOffsetY;
    if (![self.mj_header isRefreshing]) {
        
        self.contentOffset = CGPointMake(0, contentOffsetY);
    }
}

// 这两个是开放给外部调用刷新，刷新停止的方法
-(void)startRefreshing {
    [self.mj_header beginRefreshing];
}
-(void)endRefreshing {
    [self.mj_header endRefreshing];
}
```
- 在这里判断何时刷新

```
@implementation ViewController
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
```
- 总结：处理scrollView 的滑动，制造了些假象，细心观察后发现就是在移动scrollView 时，同时改变子视图frame，看起来像是没动，然后把偏移量给到tableview ，然后调这个方法

```
self.contentOffset = CGPointMake(0, contentOffsetY);
```
就转换成tableview 在滑动了，再在何时的偏移时调刷新控件开始刷新。
- 不过有个问题没处理好，写完之后给控制加navigationController时，起始偏移量变成了-64，很尴尬！
- 知道的留下答案呀，谢谢啦。zzZZ~
- 邮箱地址：zhanggaoyi92@163.com