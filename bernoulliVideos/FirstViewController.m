//
//  FirstViewController.m
//  bernoulliVideos
//
//  Created by Igor Henrique Bastos de Jesus on 07/05/15.
//  Copyright (c) 2015 bernoulli. All rights reserved.
//

#import "FirstViewController.h"
#import "DBManager.h"


NSMutableData *conWebData;
NSMutableString *soapResults;
NSXMLParser *xmlParser;
BOOL recordResults;


@interface FirstViewController ()

@property (strong, nonatomic) IBOutlet UIView *btPlay;
@property (strong, nonatomic) IBOutlet UIButton *btnPlay;
@property (strong, nonatomic) IBOutlet UITextField *txtCodigo;
@property (nonatomic, strong) DBManager *dbManager;


@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.txtCodigo.delegate = self;
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"bernoullidb.sql"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buscaUrl:(id)sender {
    
    NSString *soapMessage = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
                             "<soap:Body>\n"
                             " <retornaUrl xmlns=\"http://tempuri.org/\">\n"
                            "<codigo>%@</codigo>\n"
                             "</retornaUrl>\n"
                             "</soap:Body>\n"
                             "</soap:Envelope>\n" ,self.txtCodigo.text];
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://bernoullimobileservice.azurewebsites.net/mobile.asmx"];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [theRequest addValue: @"http://tempuri.org/retornaUrl" forHTTPHeaderField:@"SOAPAction"];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    if( theConnection )
    {
        conWebData = [NSMutableData data];
    }
    else
    {
        NSLog(@"theConnection is NULL");
    }

    NSString *query = [NSString stringWithFormat:@"insert into tbhistorico values(null, '%@')", self.txtCodigo.text];
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
    }

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [conWebData setLength: 0];
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [conWebData appendData:data];
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"ERROR with theConenction");
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"DONE. Received Bytes: %d", [conWebData length]);
    NSString *theXML = [[NSString alloc] initWithBytes: [conWebData mutableBytes] length:[conWebData length] encoding:NSUTF8StringEncoding];
    NSLog(theXML);
    xmlParser = [[NSXMLParser alloc] initWithData: conWebData];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName   attributes: (NSDictionary *)attributeDict
{
    if( [elementName isEqualToString:@"retornaUrlResult"])
    {
        if(!soapResults)
        {
            soapResults = [[NSMutableString alloc] init];
        }
        recordResults = TRUE;
    }
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if( recordResults )
    {
        [soapResults appendString: string];
    }
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if( [elementName isEqualToString:@"retornaUrlResult"])
    {
        recordResults = FALSE;
        //for debugging
        //UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:soapResults delegate:nil   cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alert show];
        NSURL *url = [NSURL URLWithString:soapResults];
        [[UIApplication sharedApplication] openURL:url];

        soapResults = nil;
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
