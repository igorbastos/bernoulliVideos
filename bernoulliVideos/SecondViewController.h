//
//  SecondViewController.h
//  bernoulliVideos
//
//  Created by Igor Henrique Bastos de Jesus on 07/05/15.
//  Copyright (c) 2015 bernoulli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblHistorico;

@end

