//
//  LogToolObjectMethodsListVC.m
//  LogTool
//
//  Created by DingYD on 2019/3/30.
//  Copyright © 2019 DingYD. All rights reserved.
//

#import "LogToolObjectMethodsListVC.h"
#import "LogToolHeader.h"
#import <objc/runtime.h>
#import "NSObject+LogToolRuntime.h"
@interface LogToolObjectMethodsListVC ()
@property(nonatomic, strong) NSMutableArray<NSString *> *properties;// 如果存在 property 则它放在 section0
@property(nonatomic, strong) NSMutableArray<NSString *> *ivarNames;// 如果存在 ivar 则它放在 section1
@property(nonatomic, strong) NSMutableArray<NSMutableArray<NSString *> *> *selectorNames;
@property(nonatomic, strong) NSMutableArray<NSString *> *indexesString;
@property(nonatomic, strong) NSMutableArray<NSAttributedString *> *searchResults;
@property (nonatomic, strong) UISearchController *searchController;
@end

@implementation LogToolObjectMethodsListVC

- (instancetype)initWithClass:(Class)aClass {
    if (self = [self initWithStyle:UITableViewStylePlain]) {
        
        self.searchResults = [[NSMutableArray alloc] init];
        
        // 属性
        self.properties = [[NSMutableArray alloc] init];
        [NSObject logtool_enumratePropertiesOfClass:aClass includingInherited:NO usingBlock:^(objc_property_t property, NSString *propertyName) {
//            logtoolPropertyDescriptor *descriptor = [logtoolPropertyDescriptor descriptorWithProperty:property];
            [self.properties addObject:propertyName];
        }];
        self.properties = [[[NSOrderedSet alloc] initWithArray:self.properties].array sortedArrayUsingSelector:@selector(compare:)].mutableCopy;
        
        // 成员变量
        self.ivarNames = [[NSMutableArray alloc] init];
        [NSObject logtool_enumrateIvarsOfClass:aClass includingInherited:NO usingBlock:^(Ivar ivar, NSString *ivarName) {
            [self.ivarNames addObject:ivarName];
        }];
        self.ivarNames = [self.ivarNames sortedArrayUsingSelector:@selector(compare:)].mutableCopy;
        
        // 方法
        self.selectorNames = [[NSMutableArray alloc] init];
        NSMutableArray<NSString *> *selectorNames = [[NSMutableArray alloc] init];
        [NSObject logtool_enumrateInstanceMethodsOfClass:aClass includingInherited:NO usingBlock:^(Method method, SEL selector) {
            [selectorNames addObject:[NSString stringWithFormat:@"- %@", NSStringFromSelector(selector)]];
        }];
        selectorNames = [selectorNames sortedArrayUsingSelector:@selector(compare:)].mutableCopy;
        
        self.indexesString = [[NSMutableArray alloc] init];
        NSMutableArray<NSString *> *selectorNamesInCurrentSection = nil;
        for (NSInteger i = 0; i < selectorNames.count; i++) {
            NSString *selectorName = selectorNames[i];
            NSString *index = [selectorName substringWithRange:NSMakeRange(2, 1)];
            if (![self.indexesString containsObject:index]) {
                [self.indexesString addObject:index];
                
                selectorNamesInCurrentSection = [[NSMutableArray alloc] init];
                [self.selectorNames addObject:selectorNamesInCurrentSection];
            }
            [selectorNamesInCurrentSection addObject:selectorName];
        }
        
        // 处理完 selectorName 再将 ivars 插入 dataSource，是为了避免 selectorName 里也存在字母“V”，会导致一些逻辑判断错误
        if (self.ivarNames.count > 0) {
            [self.indexesString insertObject:@"V" atIndex:0];
        }
        
        if (self.properties.count > 0) {
            [self.indexesString insertObject:@"P" atIndex:0];
        }
    }
    return self;
}




- (BOOL)isPropertiesSection:(NSInteger)section {
    return self.properties.count > 0 && section == 0;
}

- (BOOL)isIvarSection:(NSInteger)section {
    return self.ivarNames.count > 0 && ((self.properties.count > 0 && section == 1) || (self.properties.count <=0 && section == 0));
}



#pragma mark - <logtoolTableViewDataSource, logtoolTableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.selectorNames.count + (self.properties.count > 0 ? 1 : 0) + (self.ivarNames.count > 0 ? 1 : 0);
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if ([self isPropertiesSection:section]) {
            return self.properties.count;
        }
        if ([self isIvarSection:section]) {
            return self.ivarNames.count;
        }
        return self.selectorNames[section - (self.properties.count > 0 ? 1 : 0) - (self.ivarNames.count > 0 ? 1 : 0)].count;
    }
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellToTableView:tableView];
    
    if (tableView == self.tableView) {
        NSString *name = nil;
        if ([self isPropertiesSection:indexPath.section]) {
            name = self.properties[indexPath.row];
        } else if ([self isIvarSection:indexPath.section]) {
            name = self.ivarNames[indexPath.row];
        } else {
            name = self.selectorNames[indexPath.section - ((self.properties.count ? 1 : 0)) - (self.ivarNames.count ? 1 : 0)][indexPath.row];
        }
        cell.textLabel.text = name;
    } else {
        // 有时候清空了 searchResults 后还会因为一些原因导致 tableView reload，然后就会越界，所以这里做个保护
        if (indexPath.row < self.searchResults.count) {
            cell.textLabel.attributedText = self.searchResults[indexPath.row];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textColor = [UIColor whiteColor];
    header.contentView.backgroundColor = LogTool_Color_Label_TITLECOLOR;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if ([self isPropertiesSection:section]) {
            return @"    Properties";
        }
        if ([self isIvarSection:section]) {
            return @"    Ivars";
        }
        return [NSString stringWithFormat:@"    %@",self.indexesString[section]];
    }
    return nil;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.tableView) {
        return self.indexesString;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
