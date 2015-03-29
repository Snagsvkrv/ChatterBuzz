//
//  СhatViewController.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/18/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "СhatViewController.h"
#import "ChatMessageTableViewCell.h"
#import "CBCategory.h"
#import "CBUser.h"
#import "ShowTrendViewController.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource, QBActionStatusDelegate>

@property (nonatomic, strong) NSMutableArray *messages;
@property (nonatomic, weak) IBOutlet UIView *typingView;
@property (nonatomic, weak) IBOutlet UITextField *messageTextField;
@property (nonatomic, weak) IBOutlet UIButton *sendMessageButton;
@property (nonatomic, weak) IBOutlet UIButton *changeTopicButton;
@property (nonatomic, weak) IBOutlet UITableView *messagesTableView;
@property (nonatomic, strong) QBChatRoom *chatRoom;
@property (nonatomic, strong) CBCategory *category;
@property (nonatomic) int selectedTrend;
@property (nonatomic, strong) Trend *trend;
- (IBAction )sendMessage:(id)sender;

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.selectedTrend = 0;
	// Do any additional setup after loading the view.
    self.changeTopicButton.layer.borderColor = [UIColor blueColor].CGColor;
    self.changeTopicButton.layer.borderWidth = 1.0;
    
    self.messages = [NSMutableArray array];

    self.messagesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Set keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    // Set chat notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatDidReceiveMessageNotification:)
                                                 name:kNotificationDidReceiveNewMessage object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chatRoomDidReceiveMessageNotification:)
                                                 name:kNotificationDidReceiveNewMessageFromRoom object:nil];
    
    // Set title
    if(self.dialog.type == QBChatDialogTypePrivate){
        QBUUser *recipient = [LocalStorageService shared].usersAsDictionary[@(self.dialog.recipientID)];
        self.title = recipient.login == nil ? recipient.email : recipient.login;
    }else{
        self.title = self.dialog.name;
    }

    // Join room
    if(self.dialog.type != QBChatDialogTypePrivate){
        self.chatRoom = [self.dialog chatRoom];
        [[ChatService instance] joinRoom:self.chatRoom completionBlock:^(QBChatRoom *joinedChatRoom) {
            // joined
        }];
    }
    
    // get messages history
    
    __weak __typeof(self)weakSelf = self;
    [QBRequest messagesWithDialogID:self.dialog.ID successBlock:^(QBResponse *response, NSArray *messages) {
        
        if(messages.count > 0){
            [weakSelf.messages addObjectsFromArray:messages];
            //
            [weakSelf.messagesTableView reloadData];
            [weakSelf.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.messages.count-1 inSection:0]
                                              atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }

        
    } errorBlock:^(QBResponse *response) {
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.chatRoom leaveRoom];
    self.chatRoom = nil;
}

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

#pragma mark
#pragma mark Actions

- (IBAction)sendMessage:(id)sender{
    if(self.messageTextField.text.length == 0){
        return;
    }
    
    // create a message
    QBChatMessage *message = [[QBChatMessage alloc] init];
    message.text = self.messageTextField.text;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    [message setCustomParameters:params];
    
    // 1-1 Chat
    if(self.dialog.type == QBChatDialogTypePrivate){
        // send message
        message.recipientID = [self.dialog recipientID];
        message.senderID = [LocalStorageService shared].currentUser.ID;

        [[ChatService instance] sendMessage:message];
        
        // save message
        [self.messages addObject:message];

    // Group Chat
    }else {
        [[ChatService instance] sendMessage:message toRoom:self.chatRoom];
    }
    
    // Reload table
    [self.messagesTableView reloadData];
    if(self.messages.count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    // Clean text field
    [self.messageTextField setText:nil];
}


#pragma mark
#pragma mark Chat Notifications

- (void)chatDidReceiveMessageNotification:(NSNotification *)notification{

    QBChatMessage *message = notification.userInfo[kMessage];
    if(message.senderID != self.dialog.recipientID){
        return;
    }
    
    // save message
    [self.messages addObject:message];
    
    // Reload table
    [self.messagesTableView reloadData];
    if(self.messages.count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)chatRoomDidReceiveMessageNotification:(NSNotification *)notification{
    QBChatMessage *message = notification.userInfo[kMessage];
    NSString *roomJID = notification.userInfo[kRoomJID];
    
    if(![self.chatRoom.JID isEqualToString:roomJID]){
        return;
    }
    
    // save message
    [self.messages addObject:message];
    
    // Reload table
    [self.messagesTableView reloadData];
    if(self.messages.count > 0){
        [self.messagesTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0]
                                      atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}


#pragma mark
#pragma mark UITableViewDelegate & UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ChatMessageCellIdentifier = @"ChatMessageCellIdentifier";
    
    ChatMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatMessageCellIdentifier];
    if(cell == nil){
        cell = [[ChatMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatMessageCellIdentifier];
    }
    
    QBChatAbstractMessage *message = self.messages[indexPath.row];
    //
    [cell configureCellWithMessage:message];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QBChatAbstractMessage *message = self.messages[indexPath.row];
    NSLog(@"bhi bhi %@", message.text);
    NSString *substring =[message.text substringToIndex:3];
    if (message.text.length > 6 && [substring isEqualToString:@"Top"]) {
        [self performSegueWithIdentifier:@"show_trend" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier  isEqual: @"show_trend"]) {
        ShowTrendViewController *vc = (ShowTrendViewController *)[segue destinationViewController];
        if (self.trend) {
            vc.trend = self.trend;
        } else {
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    QBChatAbstractMessage *chatMessage = [self.messages objectAtIndex:indexPath.row];
    CGFloat cellHeight = [ChatMessageTableViewCell heightForCellWithMessage:chatMessage];
    return cellHeight;
}

-(IBAction) getNewTopic {
    if (!self.category) {
        NSString *urlString = [NSString stringWithFormat:@"http://localhost:3000/fetch/trends_by_user.json?user_id_1=%@&user_id_2=3", [[CBUser sharedManager] user_id]];
        NSURL *aUrl = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:60.0];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-type"];
        [request setHTTPMethod:@"GET"];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: [responseBody dataUsingEncoding:NSUTF8StringEncoding]
                                                                  options: NSJSONReadingMutableContainers
                                                                    error: &error];
             self.category = [[CBCategory alloc] initWithDict:dict];
             dispatch_async(dispatch_get_main_queue(), ^{
                 self.trend = self.category.trends[self.selectedTrend];
                 self.selectedTrend += 2;
                 if (self.selectedTrend > self.category.trends.count - 1) {
                     self.selectedTrend = 0;
                 }
                 self.messageTextField.text = [NSString stringWithFormat:@"Topic: %@           \nDescription: %@", self.trend.name, self.trend.summary];
                 [self sendMessage:self.sendMessageButton];

             });
         }];
        [queue waitUntilAllOperationsAreFinished];
    }
    if (self.selectedTrend > 0) {
        if (self.selectedTrend > self.category.trends.count - 1) {
            self.selectedTrend = 0;
        }
        self.trend = self.category.trends[self.selectedTrend];
        self.messageTextField.text = [NSString stringWithFormat:@"Topic: %@\nurl: %@\nDescription: %@", self.trend.name, self.trend.url, self.trend.summary];
        [self sendMessage:self.sendMessageButton];
        self.selectedTrend += 1;
    }
}

#pragma mark
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

//
//-(CGFloat) getKeyboardHeight:(NSNotification *) note {
//    NSDictionary *info = [note userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
//    CGFloat deltaHeight = kbSize.height - _currentKeyboardHeight;
//    // Write code to adjust views accordingly using deltaHeight
//    _currentKeyboardHeight = kbSize.height;
//}

#pragma mark
#pragma mark Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
		self.typingView.transform = CGAffineTransformMakeTranslation(0, -210);
//        self.sendMessageButton.transform = CGAffineTransformMakeTranslation(0, -210);
        self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                  self.messagesTableView.frame.origin.y,
                                                  self.messagesTableView.frame.size.width,
                                                  self.messagesTableView.frame.size.height-212);
    }];
}

- (void)keyboardWillHide:(NSNotification *)note
{
    [UIView animateWithDuration:0.3 animations:^{
		self.typingView.transform = CGAffineTransformIdentity;
//        self.sendMessageButton.transform = CGAffineTransformIdentity;
        self.messagesTableView.frame = CGRectMake(self.messagesTableView.frame.origin.x,
                                                  self.messagesTableView.frame.origin.y,
                                                  self.messagesTableView.frame.size.width,
                                                  self.messagesTableView.frame.size.height+212);
    }];
}

@end
