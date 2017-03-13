//  WYFoldTableView
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "WYTableViewCell.h"

@implementation WYTableViewCell

/** 初始化方法  注册Cell */
+ (instancetype)initWithTableView:(UITableView *)tableView
{
    static NSString *const WYTableViewIdentifier = @"tableViewCell";
    WYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYTableViewIdentifier];
    if (!cell) {
        cell = [[super alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYTableViewIdentifier];
    }
    return cell;
}





@end
