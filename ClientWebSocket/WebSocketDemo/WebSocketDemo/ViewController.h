//
//  ViewController.h
//  fuckdemo
//
//  Created by da zhan on 13-7-17.
//  Copyright (c) 2013年 da zhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"
#import "MessagesViewController.h"
@interface ViewController : MessagesViewController<SocketIODelegate>{
    SocketIO * socketIO;
    UILabel *tt;
    UITextField *messageTF;
}
@property (strong, nonatomic) NSMutableArray *messages;
@end
