//
//  ViewController.m
//  fuckdemo
//
//  Created by da zhan on 13-7-17.
//  Copyright (c) 2013年 da zhan. All rights reserved.
//

 

#import "ViewController.h"
#import "SocketIOPacket.h"
#import "SocketIOJSONSerialization.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    socketIO = [[SocketIO alloc] initWithDelegate:self];
    //socketIO.useSecure = YES;
    [socketIO connectToHost:@"localhost" onPort:8127];
    //[socketIO connectToHost:@"10.13.50.158" onPort:80];
    
//    messageTF=[[UITextField alloc]initWithFrame:CGRectMake(0,6,220,30)];
//    messageTF.layer.cornerRadius=6;
//    messageTF.layer.borderColor=[[UIColor blackColor] CGColor];
//    messageTF.layer.borderWidth=2;
//    messageTF.backgroundColor=[UIColor whiteColor];
//    messageTF.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
//    messageTF.placeholder=@"请输入消息格式";
//    [self.view addSubview:messageTF];
//    
//    
//    UIButton *sendbutton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
//    sendbutton.frame=CGRectMake(230,4 ,50,40);
//    [sendbutton setTitle:@"send" forState:UIControlStateNormal];
//    [sendbutton setTitle:@"send" forState:UIControlStateHighlighted];
//    [sendbutton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:sendbutton];
//    
//    tt =[[UILabel alloc]initWithFrame:CGRectMake(0, 50, 320, 100)];
//    tt.lineBreakMode=NSLineBreakByWordWrapping;
//    tt.numberOfLines=0;
//    [self.view addSubview:tt];
    
    
    self.title = @"机器人";
    
    self.messages = [[NSMutableArray alloc] initWithObjects:nil];

}


-(void)sendMessage{
    
    [self sendMessageToWebSocket:messageTF.text];
}

-(void)sendMessageToWebSocket:(NSString *)str
{
    SocketIOCallback cb = ^(id argsData) {
        NSDictionary *response = argsData;
        // do something with response
        NSLog(@"ack arrived: %@", response);
    };
    [socketIO sendMessage:str withAcknowledge:cb];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}




- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveEvent()");
    NSString *receiveData=packet.data;
    NSData *utf8Data = [receiveData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictemp=(NSDictionary *)[SocketIOJSONSerialization objectFromJSONData:utf8Data error:nil];
    NSDictionary *aadic=(NSDictionary *)[[dictemp objectForKey:@"args"] objectAtIndex:0];
    NSString * temp = [aadic objectForKey:@"text"];
   // tt.text=temp;
    NSLog(@"temp==%@",temp);
    if (![temp isEqualToString:@"connectok"]) {
        [self.messages addObject:temp];
        
        if((self.messages.count - 1) % 2)
            [MessageSoundEffect playMessageSentSound];
        else
            [MessageSoundEffect playMessageReceivedSound];
        
        [self finishSend];
    }
    
}

- (void) socketIO:(SocketIO *)socket failedToConnectWithError:(NSError *)error
{
    NSLog(@"failedToConnectWithError() %@", error);
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count;
}

#pragma mark - Messages view controller
- (BubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row % 2) ? BubbleMessageStyleIncoming : BubbleMessageStyleOutgoing;
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.row];
}

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    
    [self sendMessageToWebSocket:text];
    [self.messages addObject:text];
    
    if((self.messages.count - 1) % 2)
        [MessageSoundEffect playMessageSentSound];
    else
        [MessageSoundEffect playMessageReceivedSound];
    
    [self finishSend];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
