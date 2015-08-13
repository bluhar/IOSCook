//
//  BKItemsViewController.m
//  Homepwner
//
//  Created by vivi 卫 on 15-7-22.
//  Copyright (c) 2015年 Colin. All rights reserved.
//

#import "BKItemsViewController.h"
#import "BKItem.h"
#import "BKItemStore.h"
#import "BKDetailViewController.h"

@interface BKItemsViewController ()

//@property (nonatomic, strong) IBOutlet UIView *headerView;

@end


@implementation BKItemsViewController

// 在自己的指定初始化方法中调用父类的指定初始化方法
- (instancetype)init{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if(self){
        // 设置其本身的navigationItem
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        // 创建一个bar button item，并设置target action
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        // 将bar button item设置给navigation item
        navItem.rightBarButtonItem = bbi;
        
        // UIViewController has an editButtonItem property, and when sent editButtonItem, the view
        // controller creates a UIBarButtonItem with the title Edit. Even better, this button comes with a targetaction
    // pair: it sends the message setEditing:animated: to its UIViewController when tapped.
        navItem.leftBarButtonItem = self.editButtonItem;
    }
       
    return self;
}

// 重写父类的指定初始化方法：调用自己的指定初始化方法
- (instancetype)initWithStyle:(UITableViewStyle)style{
    return [self init];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
//    // 设置table view的header view
//    UIView *header = self.headerView;
//    [self.tableView setTableHeaderView:header];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // 返回table view需要显示多少行
    return [[[BKItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 创建table view cell
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    // Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // 找到对应行的item
    NSArray *items = [[BKItemStore sharedStore] allItems];
    BKItem *item = items[indexPath.row];
    cell.textLabel.text = [item description];
    return cell;
}

- (IBAction)addNewItem:(id)sender{
    // 为要插入的行创建index path
    //NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
    
    // 新建一条数据
    BKItem *newItem = [[BKItemStore sharedStore] createItem];
    
//    NSInteger lastRow = [[[BKItemStore sharedStore] allItems] indexOfObject:newItem];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    // 插入一行
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    BKDetailViewController *detailViewController = [[BKDetailViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    
    // 重新加载table view数据的block
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    // 设置modal view controller style
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    // 注意下面这个方法，presentViewController
    [self presentViewController:navController animated:YES completion:nil];
}
//- (IBAction)toggleEditingMode:(id)sender{
//    if (self.isEditing) {
//        [sender setTitle:@"Edit" forState:UIControlStateNormal];
//        [self setEditing:NO animated:YES];
//    } else {
//        [sender setTitle:@"Done" forState:UIControlStateNormal];
//        [self setEditing:YES animated:YES];
//    }
//}
// headerView属性的get方法，当第一次调用此方法时，加载对应的XIB文件
//- (UIView *)headerView{
//    if(!_headerView){
//        // 加载 HeaderView.xib
//        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
//    }
//    return _headerView;
//}

// 当table view要删除一行时，会发送此消息到其delegate，这个方法是在UITableVieaDataSource protocol中定义的
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 当是要执行删除时
    if(editingStyle == UITableViewCellEditingStyleDelete){
        NSArray *items = [[BKItemStore sharedStore] allItems];
        BKItem *item = items[indexPath.row];
        
        // 删除cell对应的item
        [[BKItemStore sharedStore] removeItem:item];
        
        // table view 删除行
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
// 移动行顺序
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    [[BKItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

// 选中一行
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //BKDetailViewController *detailViewController = [[BKDetailViewController alloc] init];
    // 由于BKDetailViewController重写了父类的指定初始化方法并抛出异常，所以不能直接调用init方法了。
    // 调用其自己的指定初始化方法
    BKDetailViewController *detailViewController = [[BKDetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[BKItemStore sharedStore] allItems];
    BKItem *selectedItem = items[indexPath.row];
    
    detailViewController.item = selectedItem;
    
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

@end
