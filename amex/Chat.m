//
//  Chat.m
//  amex
//
//  Created by Etay Luz on 8/1/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

#import "Chat.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "amex-Swift.h"




@interface Chat () <UITextFieldDelegate, AVAudioPlayerDelegate>
@property UIButton *accountButton;
@property UITextField *topTextField;
@property UITextField *bottomTextField;
@property UIImageView *topTextBox;
@property BOOL done;
@property NSInteger topOffset;
@property UIScrollView   *scrollView;
@property NSData *queuedAudio;
@property (nonatomic, strong) AVAudioPlayer *player;
@property AVSpeechSynthesizer *synth;
@property BOOL      isAudioOn;
@property BOOL      isAudioPlaying;
@property UIView *waitingMessage;
@property int textIndex;
@property int entranceCount;
@property NSMutableArray *optionButtons;
@property NSTimer       *timer;
@property UIImageView   *waitAnimation;
@property int            animationIndex;
@property UIButton *overview;
@property UIButton *backButton;

@end

@implementation Chat

- (void)viewDidLoad
{
  
  [super viewDidLoad];
  UIImageView *background = [UIImageView new];
  background.frame = Frame(0, 0, 768, 1024);
  background.image = [UIImage imageNamed:@"ChatBackground"];
  [self.view addSubview:background];
  self.animationIndex = 1;
  self.entranceCount = 1;
  self.isAudioOn = YES;
  self.accountButton = [UIButton new];
  self.accountButton.frame = Frame(150, 970, 80, 60);
  [self.accountButton addTarget:self action:@selector(tappedAccountButton) forControlEvents:UIControlEventTouchUpInside];
  self.accountButton.backgroundColor = [UIColor clearColor];
//  ShowViewBorders(self.accountButton);
  [self.view addSubview:self.accountButton];
  
  self.backButton = [UIButton new];
  self.backButton.frame = Frame(0, 0, 60, 80);
  [self.backButton addTarget:self action:@selector(tappedBackButton) forControlEvents:UIControlEventTouchUpInside];
  self.backButton.backgroundColor = [UIColor clearColor];
//  ShowViewBorders(self.backButton);
  [self.view addSubview:self.backButton];
  
  

  
  self.topOffset = 0;
  self.scrollView = [UIScrollView new];
  self.scrollView.showsVerticalScrollIndicator = NO;
  self.scrollView.frame = Frame(0,110,768,820);
  self.scrollView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:self.scrollView];
  
  UIImageView *overlay = [UIImageView new];
  overlay.frame = Frame(0, 130, 768, 60);
//  overlay.backgroundColor = [UIColor redColor];
  overlay.image = [UIImage imageNamed:@"Overlay.png"];
//  [self.view addSubview:overlay];
  
  UIVisualEffect *blurEffect;
  blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
  UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
  visualEffectView.frame = Frame(0, 130, 768, 60);
//  [self.view addSubview:visualEffectView];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"<your date format goes here"];
  NSDate *date = [NSDate date];
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
  NSInteger hour = [components hour];
  NSInteger minute = [components minute];
  NSString *AmPm = @"AM";
  if (hour > 11) {
    AmPm = @"PM";
  }
  hour %= 12;

  if (hour == 0) {
    hour = 12;
  }
  
  UILabel *dateLabel = [UILabel new];
  dateLabel.text = [NSString stringWithFormat:@"Today, %ld:%02ld %@", (long)hour, (long)minute, AmPm];
  dateLabel.frame = Frame(Denormalize(self.scrollView.frame.size.width * 0.46), self.topOffset, 200, 30);
  dateLabel.textColor = [UIColor whiteColor];
//  [self.scrollView addSubview:dateLabel];
  
//  self.topOffset += 70;
  
  self.bottomTextField = [UITextField new];
  self.bottomTextField.backgroundColor = [UIColor whiteColor];
  int height = 20;
  self.bottomTextField.frame = Frame(73, 942, 600, height);
  self.bottomTextField.placeholder = @"Tell me how I can help.";
  self.bottomTextField.text = @"Tell me how I can help.";
  self.bottomTextField.textColor = [UIColor colorWithRed:0.608 green:0.608 blue:0.608 alpha:1.00];
  self.bottomTextField.font = [UIFont systemFontOfSize:Normalize(17)];
  self.bottomTextField.delegate = self;
  [self.bottomTextField setReturnKeyType:UIReturnKeySend];
//  self.bottomTextField.backgroundColor = [UIColor redColor];
  //  ShowViewBorders(self.bottomTextField);
  [self.view addSubview:self.bottomTextField];
  
  self.topTextBox = [UIImageView new];
  self.topTextBox.frame = Frame(0, 0, 768, 42);
  self.topTextBox.image = [UIImage imageNamed:@"Textbox"];
  self.topTextBox.contentMode = UIViewContentModeScaleAspectFill;
  self.topTextBox.alpha = 1;
  self.topTextBox.userInteractionEnabled = YES;
  //    [self.view addSubview:self.textFieldMic];
  self.bottomTextField.inputAccessoryView = self.topTextBox;
  
  self.topTextField = [UITextField new];
  self.topTextField.clearButtonMode = UITextFieldViewModeNever;
  [self.topTextField setReturnKeyType:UIReturnKeySend];
  self.topTextField.frame = Frame(75, 10, 620, 25);
  self.topTextField.backgroundColor = [UIColor whiteColor];
  self.topTextField.attributedPlaceholder =
  [[NSAttributedString alloc] initWithString:@"Tell me how I can help."
                                  attributes:@{
                                               NSForegroundColorAttributeName: self.bottomTextField.textColor,
                                               NSFontAttributeName : self.bottomTextField.font
                                               }
   ];
  
  self.topTextField.font = [UIFont systemFontOfSize:Normalize(17)];
  self.topTextField.delegate = self;
  //    self.textField.userInteractionEnabled = NO;
//  self.topTextField.backgroundColor = [UIColor greenColor];
  [self.topTextBox addSubview:self.topTextField];
  
  UIButton *sendButton = [UIButton new];
  sendButton.frame = Frame(700, 0, 80, 40);
  [sendButton addTarget:self action:@selector(tappedSendButton) forControlEvents:UIControlEventTouchUpInside];
  sendButton.backgroundColor = [UIColor clearColor];
//  ShowViewBorders(sendButton);
  [self.topTextBox addSubview:sendButton];
  
  self.topTextField.inputAccessoryView = self.topTextBox;
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(changeFirstResponder)
                                               name:UIKeyboardDidShowNotification
                                             object:nil];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(dismissKeyboard)];
  
  [self.view addGestureRecognizer:tap];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  
  self.done = YES;
  
  self.textIndex = 1;

//  [self addWatsonChat:@"Give me a sec..." waiting:YES];
  
//  [self addWatsonChat:@"Hello, I’m Watson.\n\nWhat question do you have for me today?" waiting:NO];
//  [self addWatsonChat:@"Hello, I’m Watson.\n\nWhat question do you have for me today?" waiting:NO];
//  [self addWatsonChat:@"Hello, I’m Watson.\n\nWhat question do you have for me today?" waiting:NO];
//  [self addWatsonChat:@"Hello, I’m Watson.\n\nWhat question do you have for me today?" waiting:NO];
//  [self addWatsonChat:@"Hello, I’m Watson.\n\nWhat question do you have for me today?" waiting:NO];

//  [self addUserChat:@"My husband and I will be in Madrid on September 1st through the 4th. Then we will be in Ibiza until the 11th."];
//  [self addWatsonChat:@"Yes, I can offer you the Gold Delta SkyMiles card with $0 intro annual fee for the first year, then $95 annually. You could get a decision in as little as 60 seconds.[Apply]" waiting:NO];
//  NSArray *responseArray = @[@"This is a bummer.  We offer several cards that waive the foreign transaction fees.[Learn More]",
//                    @"Also, since you're traveling abroad I recommend you set up a Travel Notifications on your card.\n\nWould you like for me to set that up? [Yes,No]"];
//  
//  for (NSString *response in responseArray) {
//    NSString *watsonResponse = [response stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
//    double delayInSeconds = [responseArray indexOfObject:response];
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC * 0));
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//      [self addWatsonChat:watsonResponse waiting:NO];
//    });
//  }
  [self sendUserText:@"Hi!"];
  
  self.overview = [UIButton new];
  
  self.overview.frame = Frame(0, 0, 769, 973);
  [self.overview setImage:[UIImage imageNamed:@"Overview"] forState:UIControlStateNormal];
  [self.overview setImage:[UIImage imageNamed:@"Overview"] forState:UIControlStateSelected];
  [self.overview setImage:[UIImage imageNamed:@"Overview"] forState:UIControlStateHighlighted];
  [self.overview addTarget:self action:@selector(moveOverview) forControlEvents:UIControlEventTouchUpInside];
  
  [self.view addSubview:self.overview];
  [self.view bringSubviewToFront:self.overview];

}

- (void)tappedBackButton
{
  [self.view bringSubviewToFront:self.overview];
  [self.view endEditing:YES];
  
  [UIView animateWithDuration:0.3 animations:^{
    self.overview.frame = Frame(0, 0, 769, 973);
  }];
  
  
}

-(void)moveOverview
{
  [UIView animateWithDuration:0.3 animations:^{
    self.overview.frame = Frame(-769, 0, 769, 973);
  }];
  
}

-(void)tappedSendButton
{
  [self textFieldShouldReturn:self.topTextField];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [self.topTextField resignFirstResponder];
  [self addUserChat:self.topTextField.text];
  self.bottomTextField.placeholder = @"Tell me how I can help.";
  self.bottomTextField.text = @"Tell me how I can help.";
  
  self.done = NO;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.7 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    self.done = YES;
  });
  return YES;
}

-(void)keyboardWillShow
{
  if (self.topOffset > 550) {
    self.scrollView.frame = Frame(0,Denormalize(self.scrollView.frame.origin.y),
                                  Denormalize(self.scrollView.frame.size.width),
                                  1024/2);
    CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height + 20);
    [self.scrollView setContentOffset:bottomOffset animated:YES];
  }
}

-(void)changeFirstResponder
{

/*
if (self.done) {
    //    self.topTextField.text = @"";

#if (TARGET_OS_SIMULATOR)
    self.entranceCount--;
    if (self.entranceCount == 0) {
      self.entranceCount = 2;
      if (self.textIndex == 1) {
        self.topTextField.text = @"Hi. Does my card charge foreign transaction fees?";
        self.textIndex++;
      }
      else if (self.textIndex == 2) {
        self.topTextField.text = @"Bummer, my husband and I are going to Spain next month.";
        self.textIndex = 4;
      }
      else if (self.textIndex == 3) {
        self.topTextField.text = @"Yes";
        self.textIndex++;
      }
      else if (self.textIndex == 4) {
        self.topTextField.text = @"My husband and I will be in Madrid on September 1st through the 4th. Then we will be in Ibiza until the 11th.";
        self.textIndex++;
      }
      else if (self.textIndex == 5) {
        self.topTextField.text = @"Which cards waive the foreign transaction fee?";
        self.textIndex++;
      }
      else if (self.textIndex == 6) {
        self.topTextField.text = @"Hmmm. Sure, I’ll give it a try. I have an active Twitter account.";
        self.textIndex++;
      }
      else if (self.textIndex == 7) {
        self.topTextField.text = @"@alexsmith";
        self.textIndex++;
      }
      else if (self.textIndex == 8) {
        self.topTextField.text = @"Do you have something with a lower annual fee?";
        self.textIndex++;
      }
      else if (self.textIndex == 9) {
        self.topTextField.text = @"Apply";
        self.textIndex++;
      }
    }
#endif
    [self.topTextField becomeFirstResponder];
  } else {
    [self.topTextField resignFirstResponder];
    [self.bottomTextField resignFirstResponder];
    self.scrollView.frame = Frame(0,Denormalize(self.scrollView.frame.origin.y),
                                  Denormalize(self.scrollView.frame.size.width),
                                  799 - 33);
  }
*/
}

- (void)dismissKeyboard
{
  
  self.bottomTextField.text = @"Tell me how I can help.";
  self.topTextField.text = @"";
  self.done = NO;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    self.done = YES;
  });
  
  //  [self.view endEditing:YES];
  [self.topTextField resignFirstResponder];
  [self.bottomTextField resignFirstResponder];
}

- (void)tappedAccountButton {
//  self.topTextBox.image = [UIImage imageNamed:@""];
//  self.topTextField.inputAccessoryView = nil;
//  self.topTextField.hidden = YES;
//  [self.view endEditing:YES];
  [self.navigationController popViewControllerAnimated:NO];
}


// DENNIS
-(void)sendUserText:(NSString*)userChat
{
 
/*
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  //Duncan and Chris
  //  NSURL *url = [NSURL URLWithString:@"https://gateway.watsonplatform.net/dialog/api/v1/dialogs/e4bbe8ef-26ce-4087-acec-30120fca3f70/conversation"];
//  NSURL *url = [NSURL URLWithString:@"https://gateway.watsonplatform.net/dialog/api/v1/dialogs/2eb9f251-af51-41ce-898b-072695ce247f/conversation"];
  
  //New instance
  NSURL *url = [NSURL URLWithString:@"https://gateway.watsonplatform.net/dialog/api/v1/dialogs/a52c8399-666d-41a4-aec7-ad204e89fc90/conversation"];

  [request setURL:url];
  [request setHTTPMethod:@"POST"];
  [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
  //Duncan and Chris
  //  [request setValue:@"Basic NzQ0MDE0MDUtNWIyNS00NTEzLWExMGItZDAwODdlZDQzM2M5OlFONXVBbHVNWm05ZQ==" forHTTPHeaderField:@"Authorization"];
  //[request setValue:@"Basic ZmJlNmI3MjYtMmE1My00ZDIyLWI3Y2YtNmZkMjdiNTZhNTk3OlNWNjNxM3FiS084QQ==" forHTTPHeaderField:@"Authorization"]
  
  // New instance
  [request setValue:@"Basic Yzk3ZmNiNWEtYTI0OS00MmY5LTkyYzAtN2Y0OTQ2ZWVlMzc0OlFSbzNremJ3M1VQTA==" forHTTPHeaderField:@"Authorization"];
  
  NSString *post = [NSString stringWithFormat:@"input=%@",userChat];
  post = [post stringByAppendingString:[NSString stringWithFormat:@"&conversation_id=%@",@"45"]];
  post = [post stringByAppendingString:[NSString stringWithFormat:@"&client_id=%@",@"59"]];
  //Duncan and Chris
  //    post = [post stringByAppendingString:[NSString stringWithFormat:@"&conversation_id=%@",@"4108433"]];
  //    post = [post stringByAppendingString:[NSString stringWithFormat:@"&client_id=%@",@"4298176"]];
  NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
  [request setHTTPBody:postData];
  
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
  
  // DENNIS
  NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (data) {
      dispatch_async(dispatch_get_main_queue(), ^{
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSLog(@"%@", [NSString stringWithFormat:@"JSON: %@", json]);
        NSArray *responseArray = json[@"response"];
        
        //        responseArray = @[@"OK great. I see you are in San Francisco.",
        //                          @"SHOWMAP?LAT=37.655595&LON=-122.410100",
        //                          @"Would you like me to setup an appointment for you?"];
        for (NSString *response in responseArray) {
          NSString *watsonResponse = [response stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
          double delayInSeconds = [responseArray indexOfObject:response];
          dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC * 2));
          dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
              
        [self addWatsonChat:watsonResponse waiting:NO];
          });
        }
      });
    }
  }];
  
  [postDataTask resume];

*/
    
    WatsonConvo *WC = [WatsonConvo new];
    
    [WC sendToConvo:userChat chatViewController:self];
  
  
    
}

-(void)addUserChat:(NSString*)text
{
  if (text.length == 0) {
    return;
  }
  
  AVSpeechBoundary speechBoundary;
  [self.synth stopSpeakingAtBoundary:speechBoundary];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    int padding = 80;
    
    UIView *messageBouble = [UIView new];
    messageBouble.alpha = 0;
    messageBouble.backgroundColor = [UIColor colorWithRed:0.969 green:0.973 blue:0.976 alpha:1.00];
//    messageBouble.layer.cornerRadius = Normalize(25);
    messageBouble.frame = Frame(padding, self.topOffset, 1080 - padding * 2, 0);
    [self.scrollView addSubview:messageBouble];
    
    padding = 20;
    
    UILabel *message = [UILabel new];
    message.frame = Frame(padding, 7, 550, 0);
    message.numberOfLines = 0;
    message.font = [UIFont fontWithName:@"SanFranciscoText-RegularG1" size:17];
    message.text = text;
    
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 30.f;
    style.maximumLineHeight = 30.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,};
    message.attributedText = [[NSAttributedString alloc] initWithString:text
                                                             attributes:attributtes];
    
    [message sizeToFit];
    int width = Denormalize(message.frame.size.width) + 45;
    message.textColor = [UIColor blackColor];
    message.clipsToBounds = YES;
    message.backgroundColor = [UIColor clearColor];
    [messageBouble addSubview:message];
    
    messageBouble.frame = CGRectMake(Normalize(768 - 125 - width),
                                     messageBouble.frame.origin.y,
                                     Normalize(width),
                                     message.frame.size.height + Normalize(20));
    
    UIView *corner = [UIView new];
    corner.alpha = 0;
    int dimension = 10;
    corner.frame = CGRectMake(messageBouble.frame.size.width - dimension/2,
                              10,
                              dimension,
                              dimension);
    corner.backgroundColor = [UIColor whiteColor];
    corner.transform = CGAffineTransformMakeRotation(M_PI_2/2);
    
    [messageBouble addSubview:corner];
    
    UIImageView *userIcon = [UIImageView new];
    userIcon.frame = Frame(725 - 60, self.topOffset, 70, 70);
    userIcon.contentMode = UIViewContentModeScaleAspectFill;
    userIcon.image = [UIImage imageNamed:@"User"];
    [self.scrollView addSubview:userIcon];
    
    self.topOffset += Denormalize(messageBouble.frame.size.height) + 70;
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,Normalize(self.topOffset + 100));
    if (Denormalize(self.scrollView.frame.size.height) < self.topOffset) {
      CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
      [self.scrollView setContentOffset:bottomOffset animated:YES];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
      messageBouble.alpha = 1;
      corner.alpha = 1;
    }];
  });
  
  [self addWatsonChat:@"Give me a sec..." waiting:YES];
  [self sendUserText:text];
  self.topTextField.text = @"";
}

-(void)addWatsonChat:(NSString*)text waiting:(BOOL)isWaiting
{
  [self.waitingMessage removeFromSuperview];
  text = [text stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
  
  
  // DENNIS - THIS IS WHERE THE OPTIONS ARE LISTED FOR THE BUTTONS
  // EXAMPLE: [Yes,No]
  // Example: [Lost card, Replace card]
  NSString *pattern = @"\\[.*\\]";
  NSError  *error = nil;
  
  NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
  NSArray* matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];
  NSString *optionsString;
  for (NSTextCheckingResult* match in matches) {
    NSRange group1 = [match rangeAtIndex:0];
    if (group1.location < text.length) {
      optionsString = [text substringWithRange:group1];
      text = [text stringByReplacingOccurrencesOfString:optionsString withString:@""];
    }
  }
  
  optionsString = [optionsString stringByReplacingOccurrencesOfString:@"[" withString:@""];
  optionsString = [optionsString stringByReplacingOccurrencesOfString:@"]" withString:@""];
  NSArray *options = [optionsString componentsSeparatedByString:@","];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    int padding = 0;
    
    UIImageView *watsonIcon = [UIImageView new];
    watsonIcon.frame = Frame(25, self.topOffset, 70, 70);
    watsonIcon.contentMode = UIViewContentModeScaleAspectFill;
    watsonIcon.image = [UIImage imageNamed:@"Watson"];
    [self.scrollView addSubview:watsonIcon];
    
    UIView *messageBouble = [UIView new];
    messageBouble.alpha = 0;
    messageBouble.backgroundColor = [UIColor whiteColor];
//    messageBouble.layer.cornerRadius = Normalize(20);
    messageBouble.frame = Frame(150, self.topOffset, 600, 0);
    [self.scrollView addSubview:messageBouble];
    
    
    UIView *corner = [UIView new];
    corner.alpha = 1;
    int dimension = 10;
    corner.frame = CGRectMake(-dimension/ 2,
                              13,
                              dimension,
                              dimension);
    corner.backgroundColor = [UIColor whiteColor];
    corner.transform = CGAffineTransformMakeRotation(M_PI_2/2);
    [messageBouble addSubview:corner];
    
    if (isWaiting) {
      self.waitingMessage = messageBouble;
    }
    
//    UIView *blueLine = [UIView new];
    
    if (isWaiting) {
      self.waitAnimation = [UIImageView new];
      self.waitAnimation.frame = Frame(8, 16, 5, 25);
      self.waitAnimation.contentMode = UIViewContentModeScaleAspectFill;
      self.waitAnimation.image = [UIImage imageNamed:@"1.png"];
      
      self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(updateAnimation) userInfo:nil repeats:YES];
      [messageBouble addSubview:self.waitAnimation];
    } else {
      [self.timer invalidate];
//      blueLine.alpha = 0;
//      blueLine.backgroundColor = [UIColor colorWithRed:0.486 green:0.780 blue:1.000 alpha:1.00];
//      blueLine.layer.cornerRadius = Normalize(5);
//      blueLine.frame = Frame(8, 16, 5, 24);
//      [messageBouble addSubview:blueLine];
    }
    
    padding = 20;
    
    UILabel *message = [UILabel new];
    message.frame = Frame(padding,
                          5,
                          Denormalize(messageBouble.frame.size.width) - padding * 2,
                          0);
    message.numberOfLines = 0;
    message.font = [UIFont fontWithName:@"SanFranciscoText-RegularG1" size:17];
    message.text = text;
    
    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = 30.f;
    style.maximumLineHeight = 30.f;
    NSDictionary *attributtes = @{NSParagraphStyleAttributeName : style,
                                  NSFontAttributeName : [UIFont fontWithName:@"SanFranciscoText-RegularG1" size:17]};
    message.attributedText = [[NSAttributedString alloc] initWithString:text
                                                             attributes:attributtes];
    
    [message sizeToFit];
    int width = Denormalize(message.frame.size.width) + 45;
    message.textColor = [UIColor blackColor];
    message.clipsToBounds = YES;
    message.backgroundColor = [UIColor clearColor];
    [messageBouble addSubview:message];
    
    messageBouble.frame = CGRectMake(120,
                                     messageBouble.frame.origin.y,
                                     Normalize(width),
                                     message.frame.size.height + Normalize(20));
    

    
    int leftOffset = 60;
    self.optionButtons = [NSMutableArray new];
    for (NSString *option in options) {
      
      UIButton *optionButton = [UIButton new];
      [self.optionButtons addObject:optionButton];
      int buttonWidth;
      if (option.length < 4) {
        buttonWidth = 80;
      }
      else {
        buttonWidth = 119;
      }
      
      optionButton.frame = Frame(leftOffset, self.topOffset + Denormalize(message.frame.size.height) + 33, buttonWidth, 35);
      //      optionButton.backgroundColor = [UIColor redColor];
      optionButton.layer.cornerRadius = 18;
      [optionButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
      [optionButton setTitle:option forState:UIControlStateNormal];
      
      [optionButton sizeToFit];
      
      optionButton.frame = Frame(leftOffset,
                                 self.topOffset + Denormalize(message.frame.size.height) + 33,
                                 Denormalize(optionButton.frame.size.width) + 50,
                                 35);

      [optionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      optionButton.backgroundColor = [UIColor colorWithRed:0.333 green:0.588 blue:0.902 alpha:1.00];
      if ([option isEqualToString:@"Learn More"]) {
        optionButton.userInteractionEnabled = NO;
      }
      //  ShowViewBorders(self.micButton1);
      [self.scrollView addSubview:optionButton];
      
      leftOffset += optionButton.frame.size.width + 30;
    }
    
    if (isWaiting == NO) {
      self.topOffset += Denormalize(messageBouble.frame.size.height) + 70;
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,Normalize(self.topOffset + 100));
    if (Denormalize(self.scrollView.frame.size.height) < self.topOffset) {
      CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height);
      [self.scrollView setContentOffset:bottomOffset animated:YES];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
      messageBouble.alpha = 1;
//      blueLine.alpha = 1;
    }];
    if (isWaiting == NO) {
      [self getWatsonVoice:text];
    }
    
    
    
    //    AVSpeechUtterance *utterance = [AVSpeechUtterance
    //                                    speechUtteranceWithString:text];
    //    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-GB"]; //en-ZA, en-GB is nice //ar-SA, de-DE, ru-RU funny
    //    self.synth = [[AVSpeechSynthesizer alloc] init];
    //    [self.synth speakUtterance:utterance];
  });
}

-(void)updateAnimation
{
  self.animationIndex++;
  
  if (self.animationIndex == 21) {
    self.animationIndex = 1;
  }
  
  self.waitAnimation.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.png", (long)self.animationIndex]];
  
}

-(void)tappedOptionButton:(UIButton*)selectedOptionButton {
  for (UIButton *optionButton in self.optionButtons) {
    if (optionButton != selectedOptionButton) {
      [optionButton removeFromSuperview];
    }
    else {
      if ([selectedOptionButton.titleLabel.text isEqualToString:@"Apply"]) {
        [self addForm];
      } else if ([selectedOptionButton.titleLabel.text isEqualToString:@"Submit"]) {
        [self addWatsonChat:@"Congratulations!\n\nYou’ve been approved! Your card will be mailed to you in 3-5 business days. In the meantime, learn about your instant account number - you can begin using a $1,000 line of credit at Delta.com today." waiting:NO];
      } else {
        [self sendUserText:optionButton.titleLabel.text];
      }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
      optionButton.frame = Frame(Denormalize(self.scrollView.frame.size.width - optionButton.frame.size.width),
                                 Denormalize(optionButton.frame.origin.y),
                                 Denormalize(optionButton.frame.size.width),
                                 Denormalize(optionButton.frame.size.height));
      optionButton.backgroundColor = [UIColor whiteColor];
      [optionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      optionButton.userInteractionEnabled = NO;
    }];
  }
}

-(void)addForm
{
  [self getWatsonVoice:@"Great. Here is the application"];

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    UIImageView *form = [UIImageView new];
    form.frame = Frame(60, self.topOffset, 417, 708);
    form.image = [UIImage imageNamed:@"Form"];
    [self.scrollView addSubview:form];
    
    self.topOffset += 710;
    
    UIButton *optionButton = [UIButton new];
    [self.optionButtons addObject:optionButton];
    int buttonWidth = 184;
    optionButton.frame = Frame(60, self.topOffset, buttonWidth, 35);
    //      optionButton.backgroundColor = [UIColor redColor];
    optionButton.layer.cornerRadius = 18;
    [optionButton addTarget:self action:@selector(tappedOptionButton:) forControlEvents:UIControlEventTouchUpInside];
    [optionButton setTitle:@"Submit" forState:UIControlStateNormal];
    [optionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    optionButton.backgroundColor = [UIColor colorWithRed:0.333 green:0.588 blue:0.902 alpha:1.00];
    //  ShowViewBorders(self.micButton1);
    self.topOffset += 50;
    [self.scrollView addSubview:optionButton];
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,Normalize(self.topOffset + 100));
    if (Denormalize(self.scrollView.frame.size.height) < self.topOffset) {
      CGPoint bottomOffset = CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height - 100);
      [self.scrollView setContentOffset:bottomOffset animated:YES];
    }
  });
}

// DENNIS
-(void)getWatsonVoice:(NSString*)text
{
  text = [text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
  
  NSString *urlString = @"https://d5e5ca34-f670-4a7f-98c7-1643d83ecc1d:N8UAQQPXw10Z@stream.watsonplatform.net/text-to-speech/api/v1/synthesize?accept=audio/wav&voice=en-US_MichaelVoice";
  urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&text=%@", text]];
  NSURL *url = [NSURL URLWithString:urlString];
  
  //  NSMutableData *songData=[[NSData dataWithContentsOfURL:url] mutableCopy];
  //  SpeechToText *speechToText = [SpeechToText new];
  //  [speechToText repairWAVHeader:songData];
  //
  //
  //  NSError *error;
  ////  self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
  //  self.player = [[AVAudioPlayer alloc] initWithData:songData error:&error];
  //  [self.player play];
  
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:url];
  [request setHTTPMethod:@"GET"];
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
  
  // DENNIS
  NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (data) {
      //      if ((self.player.rate != 0) && (self.player.error == nil)) {
      if(self.isAudioPlaying){
        NSLog(@"getWatsonVoice: New audio in while old audio playing");
        //do what you want here
        self.queuedAudio = data;
        return;
      }
      self.isAudioPlaying = YES;
      [self playAudioWithData:data];
      
    }
  }];
  
  [postDataTask resume];
}

-(void)playAudioWithData:(NSData*)data
{
  NSError *error;
  NSMutableData *audioData = [data mutableCopy];
  SpeechtoText *speechToText = [SpeechtoText new];
  [speechToText repairWAVHeader:audioData];
  self.player = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
  self.player.delegate = self;
  if (self.isAudioOn) {
    self.player.volume = 1.0;
  } else {
    self.player.volume = 0.0;
  }
  
  [self.player play];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag;
{
  self.isAudioPlaying = NO;
  if (self.queuedAudio && self.player.playing == NO) {
    NSLog(@"Playing queued audio");
    [self playAudioWithData:self.queuedAudio];
    self.queuedAudio = nil;
  }
  
  NSLog(@"audioPlayerDidFinishPlaying");
}

@end



