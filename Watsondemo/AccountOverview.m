//
//  ViewController.m
//  amex
//
//  Created by Etay Luz on 7/28/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

#import "AccountOverview.h"
#import "AppDelegate.h"
#import "Chat.h"

@interface AccountOverview ()
@property UIButton *chatButton;
@end

@implementation AccountOverview

- (void)viewDidLoad {
  [super viewDidLoad];

  UIImageView *background = [UIImageView new];
  background.frame = Frame(0, 0, 768, 1024);
  background.image = [UIImage imageNamed:@"AccountOverview"];
  [self.view addSubview:background];
  
  self.chatButton = [UIButton new];
  self.chatButton.frame = Frame(560, 970, 80, 60);
  [self.chatButton addTarget:self action:@selector(tappedChatButton) forControlEvents:UIControlEventTouchUpInside];
  self.chatButton.backgroundColor = [UIColor clearColor];
//  ShowViewBorders(self.chatButton);
  [self.view addSubview:self.chatButton];
}

-(void)tappedChatButton
{
  Chat *chat = [Chat new];
  [self.navigationController pushViewController:chat animated:NO];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
