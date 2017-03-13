//  WYFoldTableView
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYTableViewHeaderView.h"

@implementation WYTableViewHeaderView

/** 初始化方法  注册组头 */
+ (instancetype)initWithHeaderView:(UITableView *)tableView
{
    static NSString *const WYHeaderViewViewIdentifier = @"headerViewCell";
    WYTableViewHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:WYHeaderViewViewIdentifier];
    if (!header) {
        header = [[super alloc] initWithReuseIdentifier:WYHeaderViewViewIdentifier];
    }
    
    return header;
}


@end
