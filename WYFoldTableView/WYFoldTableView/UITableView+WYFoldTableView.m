//
//  UITableView+WYFoldTableView.m
//  WYFoldTableView
//  简书地址：http://www.jianshu.com/u/8f8143fbe7e4
//  GitHub地址：https://github.com/unseim
//  QQ：9137279
//

#import "UITableView+WYFoldTableView.h"
#import <objc/runtime.h>

@implementation UITableView (WYFoldTableView)

#pragma mark - init
+ (void)load
{
#pragma clang diagnostic push
    //    [self swizzInstanceMethod:@selector(_numberOfSections) withMethod:@selector(ww__numberOfSections)];
    [self swizzInstanceMethod:@selector(_numberOfRowsInSection:) withMethod:@selector(ww__numberOfRowsInSection:)];
#pragma clang diagnostic pop
}

- (NSInteger)ww__numberOfRowsInSection:(NSInteger)section
{
    if(!self.ww_foldState || !self.ww_foldState){
        return [self ww__numberOfRowsInSection:section];
    }
    
    //根据折叠状态返回行数
    BOOL isFolded = [self isSectionFolded:section];
    return isFolded ? 0 : [self ww__numberOfRowsInSection:section];
}

#pragma mark - getter/setter
static const char WWFoldableKey = '\0';
- (BOOL)isFold
{
    return [objc_getAssociatedObject(self, &WWFoldableKey) boolValue];
}

- (void)setIsFold:(BOOL)isFold
{
    [self willChangeValueForKey:@"isFold"];
    objc_setAssociatedObject(self, &WWFoldableKey, @(isFold), OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"isFold"];
    
    //initialize
    if(isFold && !self.ww_foldState){
        NSMutableSet *foldState = [NSMutableSet set];
        self.ww_foldState = foldState;
    }
    
    //clean up
    if(!isFold){
        [self setWw_foldState:nil];
    }
}

static const char WWFoldStateKey = '\0';
- (NSMutableSet *)ww_foldState
{
    return objc_getAssociatedObject(self, &WWFoldStateKey);
}

- (void)setWw_foldState:(NSMutableSet *)ww_foldState
{
    if(self.isFold && ww_foldState != self.ww_foldState){
        [self willChangeValueForKey:@"ww_foldState"];
        objc_setAssociatedObject(self, &WWFoldStateKey, ww_foldState, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"ww_foldState"];
    }
}

#pragma mark - methods
- (BOOL)isSectionFolded:(NSInteger)section
{
    if(!self.isFold || !self.ww_foldState){
        return NO;
    }
    return [self.ww_foldState containsObject:@(section)];
}

- (void)foldSection:(NSInteger)section fold:(BOOL)fold
{
    if(!self.isFold || !self.ww_foldState){
        return;
    }
    
    NSMutableSet *state = self.ww_foldState;
    if(fold){
        [state addObject:@(section)];
    }else{
        [state removeObject:@(section)];
    }
    self.ww_foldState = state;
    
    @try {
        //防止crash
        [self reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception);
        [self reloadData];
    }
}
@end

@implementation NSObject (WWExtension)
+ (void)swizzInstanceMethod:(SEL)methodOrig withMethod:(SEL)methodNew
{
    Method orig = class_getInstanceMethod(self, methodOrig);
    Method new = class_getInstanceMethod(self, methodNew);
    if(orig && new){
        method_exchangeImplementations(orig, new);
    }else{
        NSLog(@"swizz instance method failed: %s", sel_getName(methodOrig));
    }
}

+ (void)swizzClassMethod:(SEL)methodOrig withMethod:(SEL)methodNew
{
    Method orig = class_getClassMethod(self, methodOrig);
    Method new = class_getClassMethod(self, methodNew);
    if(orig && new){
        method_exchangeImplementations(orig, new);
    }else{
        NSLog(@"swizz class method failed: %s", sel_getName(methodOrig));
    }
}

@end
