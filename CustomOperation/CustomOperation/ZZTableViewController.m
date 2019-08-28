//
//  ZZTableViewController.m
//  CustomOperation
//
//  Created by 开发所用，一般人别用 on 2019/8/27.
//  Copyright © 2019年 CK. All rights reserved.
//

#import "ZZTableViewController.h"
#import "ZZDownloadOperation.h"

@interface ZZTableViewController () <ZZDownloadOperationDelegate>

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) NSOperationQueue *queue;
@property (nonatomic, strong) NSMutableDictionary *oprations;
@property (nonatomic, strong) NSMutableDictionary *images;

@end

@implementation ZZTableViewController

- (NSMutableDictionary *)images
{
    if (!_images) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

- (NSMutableDictionary *)oprations
{
    if (!_oprations) {
        _oprations = [NSMutableDictionary dictionary];
    }
    return _oprations;
}

- (NSOperationQueue *)queue
{
    if (_queue == nil) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 3;
    }
    return _queue;
}

- (NSArray *)items
{
    if (_items == nil) {
        NSString *file = [[NSBundle mainBundle] pathForResource:@"apps.plist" ofType:nil];
        _items = [NSArray arrayWithContentsOfFile:file];
        
    
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSLog(@"%@", path);
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *Id = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Id];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Id];
    }
    
    NSDictionary *dict = self.items[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    cell.detailTextLabel.text = dict[@"download"];
    
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dict[@"icon"]]];

    
    // 下载图片
    UIImage *image = self.images[dict[@"icon"]];
    if (image == nil) {

        // 设置站位图片
        cell.imageView.image = [UIImage imageNamed:@""];

        ZZDownloadOperation *operation = self.oprations[dict[@"icon"]]; // 在不在下载

        if (operation == nil) {
            operation = [[ZZDownloadOperation alloc] init];
            self.oprations[dict[@"icon"]] = operation;
            operation.delegate = self;
            operation.indexPath = indexPath;
            operation.url = dict[@"icon"];
            [self.queue addOperation:operation];
        }

    } else {
        cell.imageView.image = image;
    }

    return cell;
}


#pragma ZZDownloadOperationDelegate
- (void)downloadOperation:(ZZDownloadOperation *)opration didDownloadWithImage:(UIImage *)image
{
    // 移除操作
    [self.oprations removeObjectForKey:opration.url];
    
    // 存入缓存
    [self.images setObject:image forKey:opration.url];
    
    // 刷新表格
    [self.tableView reloadRowsAtIndexPaths:@[opration.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    // 存入沙盒
//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
//
//    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", opration.indexPath]];
//
//    NSData *data = UIImagePNGRepresentation(image);
//    BOOL result =  [data writeToFile:filePath atomically:YES];
    
//    NSLog(@"%d", result);
}

@end
