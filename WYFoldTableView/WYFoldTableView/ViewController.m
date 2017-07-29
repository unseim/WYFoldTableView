//  WYFoldTableView
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UITableView+WYFoldTableView.h"

#import "ViewController.h"
#import "WYTableViewCell.h"
#import "WYTableViewHeaderView.h"

#define KScreenWidth     [UIScreen mainScreen].bounds.size.width
#define KScreenHeight    [UIScreen mainScreen].bounds.size.height

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    BOOL isFolded = [tableView isSectionFolded:section];
    
    // 折叠中返回0 需要展示的行数
    return isFolded ? 0 :[self.dataList count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WYTableViewCell *cell = [WYTableViewCell initWithTableView:tableView];
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

#pragma mark header/footer
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WYTableViewHeaderView *header = [WYTableViewHeaderView initWithHeaderView:tableView];
    
    header.textLabel.text = [NSString stringWithFormat:@"第%@组", @(section+1)];
    header.tag = section;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureTapped:)];
    [header addGestureRecognizer:tap];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}


//  折叠展开方法
- (void)gestureTapped:(UIGestureRecognizer *)gesture
{
    NSLog(@"Class = %@", gesture.view);
    
    UIView *header = gesture.view;
    NSInteger section = header.tag;
    [self.tableView foldSection:section fold:![self.tableView isSectionFolded:section]];
}


#pragma mark - Lazy
- (UITableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        
        //  关键代码  让tableView具备可以折叠的功能
        _tableView.isFold = YES;
        
        //  关键代码    指定某一个分区折叠   默认全部展开
        [_tableView foldSection:1 fold:YES];
        
	}
	return _tableView;
}

- (NSArray *)dataList {
	if(_dataList == nil) {
		_dataList = [[NSArray alloc] initWithObjects:@"第1行", @"第2行", @"第3行", nil];
	}
	return _dataList;
}

@end
