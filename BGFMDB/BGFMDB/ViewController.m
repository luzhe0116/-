//
//  ViewController.m
//  BGFMDB
//
//  Created by huangzhibiao on 16/4/28.
//  Copyright © 2016年 Biao. All rights reserved.
//

#import "ViewController.h"
#import "BGFMDB/BGFMDB.h"

#define tableName @"student"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
//建表字段
@property (weak, nonatomic) IBOutlet UITextField *createOne;
@property (weak, nonatomic) IBOutlet UITextField *createTwo;
@property (weak, nonatomic) IBOutlet UITextField *createThree;
//插入值
@property (weak, nonatomic) IBOutlet UITextField *insertOne;
@property (weak, nonatomic) IBOutlet UITextField *insertTwo;
@property (weak, nonatomic) IBOutlet UITextField *insertThree;
//查询字段
@property (weak, nonatomic) IBOutlet UITextField *selectOne;
@property (weak, nonatomic) IBOutlet UITextField *selectTwo;
@property (weak, nonatomic) IBOutlet UITextField *selectThree;
//要更新的值
@property (weak, nonatomic) IBOutlet UITextField *updateOne;
@property (weak, nonatomic) IBOutlet UITextField *updateTwo;
@property (weak, nonatomic) IBOutlet UITextField *updateThree;
//根据字段值删除
@property (weak, nonatomic) IBOutlet UITextField *deleteOne;
@property (weak, nonatomic) IBOutlet UITextField *deleteTwo;
@property (weak, nonatomic) IBOutlet UITextField *deleteThree;
//数据展示
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSArray* datas;


- (IBAction)createAction:(id)sender;
- (IBAction)dropAction:(id)sender;
- (IBAction)insertAction:(id)sender;
- (IBAction)selectAction:(id)sender;
- (IBAction)updateAction:(id)sender;
- (IBAction)deleteAction:(id)sender;
- (IBAction)hideKeyBoard:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initTableview];
}

-(void)initTableview{
    _tableview.dataSource = self;
    _tableview.delegate = self;
}

- (IBAction)createAction:(id)sender {
    NSMutableArray* keys = [NSMutableArray array];
    if (![_createOne.text isEqualToString:@""]) {
        [keys addObject:_createOne.text];
    }
    if (![_createTwo.text isEqualToString:@""]){
        [keys addObject:_createTwo.text];
    }
    if (![_createThree.text isEqualToString:@""]){
        [keys addObject:_createThree.text];
    }
    //默认建立主键id
    //keys 数据存放要求@[字段名称1,字段名称2]
    BOOL result = [[BGFMDB intance] createTableWithTableName:tableName keys:keys];//建表语句
    if (result) {
        NSLog(@"创表成功");
    } else {
        NSLog(@"创表失败");
    }
}

- (IBAction)dropAction:(id)sender {
    BOOL result = [[BGFMDB intance] dropTable:tableName];
    if (result) {
        NSLog(@"删表成功");
        _datas = nil;
        [_tableview reloadData];
    } else {
        NSLog(@"删表失败");
    }
}

- (IBAction)insertAction:(id)sender {
    NSMutableDictionary* dictM = [NSMutableDictionary dictionary];
    if (![_createOne.text isEqualToString:@""] && ![_insertOne.text isEqualToString:@""]) {
        dictM[_createOne.text] = _insertOne.text;
    }
    if (![_createTwo.text isEqualToString:@""] && ![_insertTwo.text isEqualToString:@""]){
        dictM[_createTwo.text] = _insertTwo.text;
    }
    if (![_createThree.text isEqualToString:@""] && ![_insertThree.text isEqualToString:@""]){
        dictM[_createThree.text] = _insertThree.text;
    }
    
    BOOL result = [[BGFMDB intance] insertIntoTableName:tableName Dict:dictM];//插入语句
    if (result) {
        NSLog(@"插入成功");
        [self selectAction:nil];
    } else {
        NSLog(@"插入失败");
    }
}

- (IBAction)selectAction:(id)sender {
    NSMutableArray* keys = [NSMutableArray array];
    if (![_selectOne.text isEqualToString:@""]) {
        [keys addObject:_selectOne.text];
    }
    if (![_selectTwo.text isEqualToString:@""]){
        [keys addObject:_selectTwo.text];
    }
    if (![_selectThree.text isEqualToString:@""]){
        [keys addObject:_selectThree.text];
    }

    NSArray* arr = [[BGFMDB intance] queryWithTableName:tableName keys:keys where:nil];//查询语句
    _datas = arr;
    [_tableview reloadData];
}

- (IBAction)updateAction:(id)sender {
    NSMutableDictionary* valueDict = [NSMutableDictionary dictionary];
    if (![_createOne.text isEqualToString:@""] && ![_updateOne.text isEqualToString:@""]) {
        valueDict[_createOne.text] = _updateOne.text;
    }
    if (![_createTwo.text isEqualToString:@""] && ![_updateTwo.text isEqualToString:@""]){
        valueDict[_createTwo.text] = _updateTwo.text;
    }
    if (![_createThree.text isEqualToString:@""] && ![_updateThree.text isEqualToString:@""]){
        valueDict[_createThree.text] = _updateThree.text;
    }
    //where是条件数组 形式 @[@"key",@"=",@"value",@"key",@">=",@"value"]
    //没有过滤条件时,where填nil
    BOOL result = [[BGFMDB intance] updateWithTableName:tableName valueDict:valueDict where:nil];//更新语句
    if (result) {
        NSLog(@"更新成功");
        [self selectAction:nil];
    } else {
        NSLog(@"更新失败");
    }
}

- (IBAction)deleteAction:(id)sender {
    //NSArray* where = @[@"age",@"=",@"1"];
    NSMutableArray* where = [NSMutableArray array];
    if (![_createOne.text isEqualToString:@""] && ![_deleteOne.text isEqualToString:@""]) {
        [where addObject:_createOne.text];
        [where addObject:@"="];
        [where addObject:_deleteOne.text];
    }
    if (![_createTwo.text isEqualToString:@""] && ![_deleteTwo.text isEqualToString:@""]){
        [where addObject:_createTwo.text];
        [where addObject:@"="];
        [where addObject:_deleteTwo.text];
    }
    if (![_createThree.text isEqualToString:@""] && ![_deleteThree.text isEqualToString:@""]){
        [where addObject:_createThree.text];
        [where addObject:@"="];
        [where addObject:_deleteThree.text];
    }

    BOOL result = [[BGFMDB intance] deleteWithTableName:tableName where:where];//删除语句
    if (result) {
        NSLog(@"删除成功");
        [self selectAction:nil];
    } else {
        NSLog(@"删除失败");
    }
}

- (IBAction)hideKeyBoard:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark -- UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas==nil?0:_datas.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"UITableViewCell";
    //优化cell，去缓存池中寻找是否有可用的cell
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell ==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    NSMutableString* data = [[NSMutableString alloc] init];
    NSDictionary* dict = _datas[indexPath.row];
    for(NSString* key in dict.allKeys){
        [data appendFormat:@"%@: %@   ",key,dict[key]];
    }
    cell.textLabel.text = data;
    return cell;
}

@end
