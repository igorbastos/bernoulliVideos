//
//  SecondViewController.m
//  bernoulliVideos
//
//  Created by Igor Henrique Bastos de Jesus on 07/05/15.
//  Copyright (c) 2015 bernoulli. All rights reserved.
//

#import "SecondViewController.h"
#import "DBManager.h"
#import "HistoricoCell.h"

@interface SecondViewController ()



@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *arrPeopleInfo;

-(void)loadData;

@end

@implementation SecondViewController

static NSString *CellIdentifier = @"CellIdentifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Make self the delegate and datasource of the table view.
    self.tblHistorico.delegate = self;
    self.tblHistorico.dataSource = self;
    
    // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"bernoullidb.sql"];
    [self.tblHistorico registerClass:[HistoricoCell class] forCellReuseIdentifier:@"CellIdentifier"];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from tbHistorico";
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view.
    [self.tblHistorico reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrPeopleInfo.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dequeue the cell.
    HistoricoCell *cell = (HistoricoCell *)[self.tblHistorico dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    if(self.dbManager.arrColumnNames.count > 0)
    {
    
    
    NSLog(@"%@", cell.class);
    NSLog(@"%d", self.dbManager.arrColumnNames.count);
    
        // Fetch Item
    NSDictionary *item = [self.dbManager.arrColumnNames objectAtIndex:indexPath.row];
    
    // Configure Table View Cell
    [cell.titleLabel setText:[NSString stringWithFormat:@"%@", item[@"codigo"]]];
    [cell.actionButton addTarget:self action:@selector(didTapButton:) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return cell;
}

- (void)didTapButton:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
