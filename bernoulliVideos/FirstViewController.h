//
//  FirstViewController.h
//  bernoulliVideos
//
//  Created by Igor Henrique Bastos de Jesus on 07/05/15.
//  Copyright (c) 2015 bernoulli. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FirstViewController : UIViewController <UITextFieldDelegate>

@property(nonatomic, retain) NSMutableData *conWebData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;
@property NSMutableData   *webData;

@end

