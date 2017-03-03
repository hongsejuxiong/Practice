//
//  BaseTabBarController.m
//  darongtong
//
//  Created by darongtong on 15/9/17.
//  Copyright © 2015年 rongtong. All rights reserved

#import "BaseTabBarController.h"
#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "MyViewViewController.h"
#import "FollowViewController.h"
#import "ConversationListController.h" //会话列表
#import "ConversationViewController.h" //会话界面
#import "CallViewController.h"
#import "UserProfileManager.h"
//
#import "GroupViewController.h"//坛
#import "NSObject+RedBadge.h"
#import "Pin_SiftViewController.h"//品

//
#import "LoginViewController.h"
#import "BaseNavigationController.h"
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
@interface BaseTabBarController ()<UIAlertViewDelegate, IChatManagerDelegate, EMCallManagerDelegate,UITabBarDelegate>

{
    ConversationViewController *_chatListVC;
    EMConnectionState _connectionState;
    ConversationListController *groupVc;
    FollowViewController *follow;
//    GroupViewController *pinVc;
    Pin_SiftViewController *pinmenuvc;
    DaRongTongUser *userSingle;
    MyViewViewController *my;
}
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

@implementation BaseTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //begin
    userSingle=[DaRongTongUser sharedSingleton];
    NSUserDefaults *userKeyInfo =[NSUserDefaults standardUserDefaults];
    userSingle.tokenString=[userKeyInfo objectForKey:@"token"];
    userSingle.huanxinUserId=[userKeyInfo objectForKey:@"huanxinUserId"];
    userSingle.head_pic=[userKeyInfo objectForKey:@"headicon"];
    userSingle.customer_id =[userKeyInfo objectForKey:@"customer_id"];
    userSingle.nickName=[userKeyInfo objectForKey:@"nick_name"];
    userSingle.fullname=[userKeyInfo objectForKey:@"fullname"];
    userSingle.sex=[userKeyInfo objectForKey:@"sex"];
    userSingle.born=[userKeyInfo objectForKey:@"born"];
    userSingle.industry=[userKeyInfo objectForKey:@"industry"];
    userSingle.telephone=[userKeyInfo objectForKey:@"telephone"];
    userSingle.location=[userKeyInfo objectForKey:@"location"];
    userSingle.qrCodeUrl=[userKeyInfo objectForKey:@"qrcode"];
    BOOL isAutoLogin = [[EaseMob sharedInstance].chatManager isAutoLoginEnabled];
    if (!isAutoLogin && ![userSingle.huanxinUserId isEqualToString:@""]) {
        [self loginHuanXin];
    }else if([userSingle.huanxinUserId isEqualToString:@""]){
        [self loginOut];
    }
    //end
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 49)];
    backView.backgroundColor = [UIColor colorWithHexStringTest:@"#222426" alpha:1];
    [self.tabBar insertSubview:backView atIndex:0];
    self.tabBar.opaque = YES;
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *home = [mainStory instantiateViewControllerWithIdentifier:@"home"];
    home.title=@"大容通";
    UIImage *unCilckHomeImage = [[UIImage imageNamed:@"darongtong"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    home.tabBarItem.image=unCilckHomeImage;
    UIImage *clickHomeImage = [[UIImage imageNamed:@"darongtongclick"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    home.tabBarItem.selectedImage =clickHomeImage;
    //    [home.tabBarItem setTitleTextAttributes:textDefaultColor forState:UIControlStateNormal];
    //    [home.tabBarItem setTitleTextAttributes:textSelColor forState:UIControlStateSelected];
    [self unSelectedTapTabBarItems:home.tabBarItem];
    [self selectedTapTabBarItems:home.tabBarItem];
    //   关注
    follow =[mainStory instantiateViewControllerWithIdentifier:@"followviewid"];
    follow.title = @"个性";
    UIImage *unClickFollow = [[UIImage imageNamed:@"gexing"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    follow.tabBarItem.image = unClickFollow;
    UIImage *clickFollow =[[UIImage imageNamed:@"gexingclick"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    follow.tabBarItem.selectedImage = clickFollow;
    [self unSelectedTapTabBarItems:follow.tabBarItem];
    [self selectedTapTabBarItems:follow.tabBarItem];
    //    follow.tabBarItem.badgeValue=@"";//红点
    //  坛
//    begin
    groupVc = [mainStory instantiateViewControllerWithIdentifier:@"conversationhistory"];
    groupVc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"坛"                                                                                     image:nil
                                                         tag:0];
    UIImage *unClickChatList = [[UIImage imageNamed:@"tan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *clickChatList = [[UIImage imageNamed:@"tanclick"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    groupVc.tabBarItem.image = unClickChatList;
    groupVc.tabBarItem.selectedImage = clickChatList;
    [self unSelectedTapTabBarItems:groupVc.tabBarItem];
    [self selectedTapTabBarItems:groupVc.tabBarItem];

    //  品
    pinmenuvc = [mainStory instantiateViewControllerWithIdentifier:@"pinvcId"];
    pinmenuvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"品"                                                       image:nil
                                                       tag:0];
    UIImage *unpin = [[UIImage imageNamed:@"pin"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *clickpin = [[UIImage imageNamed:@"pinclick"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    pinmenuvc.tabBarItem.image = unpin;
    pinmenuvc.tabBarItem.selectedImage = clickpin;
    [self unSelectedTapTabBarItems:pinmenuvc.tabBarItem];
    [self selectedTapTabBarItems:pinmenuvc.tabBarItem];
    //  我
    my = [mainStory instantiateViewControllerWithIdentifier:@"mycenter"];
    my.title=@"我";
    UIImage *unMyClick = [[UIImage imageNamed:@"me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage * myClick = [[UIImage imageNamed:@"meclick"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    my.tabBarItem.image =unMyClick;
    my.tabBarItem.selectedImage =myClick;
    [my.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"greenheadpic"] forBarMetrics:UIBarMetricsDefault];
    ////    [my.tabBarItem setTitleTextAttributes:textSelColor forState:UIControlStateSelected];
    [self unSelectedTapTabBarItems:my.tabBarItem];
    [self selectedTapTabBarItems:my.tabBarItem];
    self.viewControllers = [NSArray arrayWithObjects:home,follow,groupVc,pinmenuvc,my, nil];
    //    //通知
    //    NSNotification * notice = [NSNotification notificationWithName:@"red" object:nil userInfo:@{@"1":@"123"}];
    //    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    // begin 环信
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginHuanXin) name:@"userLoginSucceed" object:nil];
#warning 把self注册为SDK的delegate
    [self registerNotifications];
    //退出登录或者token过期
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:KLoginOutNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callOutWithChatter:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callControllerClose:) name:@"callControllerClose" object:nil];
    //end
    //    [self setupUnreadMessageCount];
    
}
//登录环信
-(void) loginHuanXin
{
    DaRongTongUser *user=[DaRongTongUser sharedSingleton];
    if (user.huanxinUserId.length>0 && user.tokenString.length>0) {
        //    异步登陆账号
        [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:user.huanxinUserId
                                                            password:kHuanXinPassword
                                                          completion:
         ^(NSDictionary *loginInfo, EMError *error) {
             if (loginInfo && !error) {
                 //设置是否自动登录
                 [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                 //
                 //获取数据库中数据
                 [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                 //获取群组列表
                 [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                 //             发送自动登陆状态通知
                 //             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             }
             else
             {
                 //                 switch (error.errorCode)
                 //                 {
                 //                     case EMErrorNotFound:
                 //                         TTAlertNoTitle(error.description);
                 //                         break;
                 //                     case EMErrorNetworkNotConnected:
                 //                         TTAlertNoTitle(NSLocalizedString(@"error.connectNetworkFail", @"No network connection!"));
                 //                         break;
                 //                     case EMErrorServerNotReachable:
                 //                         TTAlertNoTitle(NSLocalizedString(@"error.connectServerFail", @"Connect to the server failed!"));
                 //                         break;
                 //                     case EMErrorServerAuthenticationFailure:
                 //                         TTAlertNoTitle(error.description);
                 //                         break;
                 //                     case EMErrorServerTimeout:
                 //                         TTAlertNoTitle(NSLocalizedString(@"error.connectServerTimeout", @"Connect to the server timed out!"));
                 //                         break;
                 //                     default:
                 ////                         TTAlertNoTitle(NSLocalizedString(@"login.fail", @"Login failure"));
                 //                         break;
                 //                 }
             }
         } onQueue:nil];
    }
    
    
}
-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    UIColor *defaultColor=[UIColor colorWithHexStringTest:@"#545455" alpha:1];
    NSDictionary *textDefaultColor = [NSDictionary dictionaryWithObjectsAndKeys:defaultColor,NSForegroundColorAttributeName,[UIFont systemFontOfSize:kFontSmall12],NSFontAttributeName,nil];
    
    [tabBarItem setTitleTextAttributes:textDefaultColor forState:UIControlStateNormal];
}

-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    NSDictionary *textSelColor = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor redColor], NSForegroundColorAttributeName,[UIFont systemFontOfSize:kFontSmall12],NSFontAttributeName,nil];
    [tabBarItem setTitleTextAttributes:textSelColor
                              forState:UIControlStateSelected];
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (groupVc) {
        if (unreadCount > 0) {
            groupVc.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
        }else{
            groupVc.tabBarItem.badgeValue = nil;
        }
    }
    //icon
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
    
}

-(void)loginOut
{
    //登出
    NSUserDefaults *userKeyInfo =[NSUserDefaults standardUserDefaults];
    [userKeyInfo setValue:nil forKey:@"token"];
    userSingle=[DaRongTongUser sharedSingleton];
    userSingle.tokenString=nil;
    userSingle.tokenString=nil;
    userSingle.customer_id=nil;
    userSingle.head_pic=nil;
    userSingle.qrCodeUrl=nil;
    userSingle.born=nil;
    userSingle.telephone=nil;
    userSingle.nickName=nil;
    userSingle.sex=nil;
    userSingle.fullname=nil;
    NSUserDefaults *defaultInfo =UserDefaults;
    [defaultInfo setValue:nil forKey:@"headicon"];
    //
    //    [self.navigationController popViewControllerAnimated:YES];
    //    环信注销
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error && info) {
            NSLog(@"退出成功");
        }
    } onQueue:nil];
    KPostNotification(@"updateUserInfoSucced");
    
    MMPopupItemHandler block =^(NSInteger index){
        UIStoryboard *story=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
        LoginViewController *login=[story instantiateViewControllerWithIdentifier:@"loginStoryID"];
        login.isPresent=YES;
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:login];
        [self presentViewController:nav animated:YES completion:nil];
        
    };
    NSArray *items =
    @[MMItemMake(@"稍后", MMItemTypeNormal, nil),MMItemMake(@"登录", MMItemTypeHighlight, block)];
    MMAlertView *alertView = [[MMAlertView alloc] initWithTitle:@"提示"
                                                         detail:@"是否登录"
                                                          items:items];
    [alertView show];
    
    
}
#pragma mark - call

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    if (!bCanRecord) {
        UIAlertView * alt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"setting.microphoneNoAuthority", @"No microphone permissions") message:NSLocalizedString(@"setting.microphoneAuthority", @"Please open in \"Setting\"-\"Privacy\"-\"Microphone\".") delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
        [alt show];
    }
    
    return bCanRecord;
}

- (void)callOutWithChatter:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        if (![self canRecord]) {
            return;
        }
        
        EMError *error = nil;
        NSString *chatter = [object objectForKey:@"chatter"];
        EMCallSessionType type = [[object objectForKey:@"type"] intValue];
        EMCallSession *callSession = nil;
        if (type == eCallSessionTypeAudio) {
            callSession = [[EaseMob sharedInstance].callManager asyncMakeVoiceCall:chatter timeout:50 error:&error];
        }
        else if (type == eCallSessionTypeVideo){
            if (![CallViewController canVideo]) {
                return;
            }
            callSession = [[EaseMob sharedInstance].callManager asyncMakeVideoCall:chatter timeout:50 error:&error];
        }
        
        if (callSession && !error) {
            [[EaseMob sharedInstance].callManager removeDelegate:self];
            
            CallViewController *callController = [[CallViewController alloc] initWithSession:callSession isIncoming:NO];
            callController.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self presentViewController:callController animated:NO completion:nil];
        }
        
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error", @"error") message:error.description delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
}

- (void)callControllerClose:(NSNotification *)notification
{
    //    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //    [audioSession setActive:YES error:nil];
    
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}


#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
    //    [_chatListVC refreshDataSource];//begin
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        
        //        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        //        if (!isAppActivity) {
        //            [self showNotificationWithMessage:message];
        //        }else {
        //            [self playSoundAndVibration];
        //        }
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        YYLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
}
- (void)dealloc
{
    [self unregisterNotifications];
}
//begin

//end
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --uitabbar delegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    userSingle =[DaRongTongUser sharedSingleton];
    UINavigationBar *navBar = [UINavigationBar appearance];
    if (!userSingle.tokenString && !([item.title isEqualToString:@"大容通"] || [item.title isEqualToString:@"我"])) {
        KPostNotification(KLoginOutNotification)
    }else if ([item.title isEqualToString:@"关注"])
    {
        follow.tabBarItem.badgeValue=nil;
        [navBar setBackgroundImage:[UIImage imageNamed:@"headpic"] forBarMetrics:UIBarMetricsDefault];
        
    }else if([item.title isEqualToString:@"坛"]){
        //        [navBar setBackgroundImage:[UIImage imageNamed:@"headpic"] forBarMetrics:UIBarMetricsDefault];
    }else if([item.title isEqualToString:@"我"]){
        //        [navBar setBackgroundImage:[UIImage imageNamed:@"greenheadpic"] forBarMetrics:UIBarMetricsDefault];
        
    }else{
    }
    //    if ([item.title isEqualToString:@"关注"])
    //    {
    //        follow.tabBarItem.badgeValue=nil;
    //        if (!userSingle.tokenString) {
    //            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
    //            LoginViewController *login=[story instantiateViewControllerWithIdentifier:@"loginStoryID"];
    //            login.isPresent=YES;
    //            BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:login];
    //            [self presentViewController:navi animated:YES completion:nil];
    //        }
    //    }else if([item.title isEqualToString:@"坛"])
    //    {
    //        if (!userSingle.tokenString) {
    //            UIStoryboard *story=[UIStoryboard storyboardWithName:@"Login" bundle:nil];
    //            LoginViewController *login=[story instantiateViewControllerWithIdentifier:@"loginStoryID"];
    //            login.isPresent=YES;
    //            BaseNavigationController *navi = [[BaseNavigationController alloc] initWithRootViewController:login];
    //            [self presentViewController:navi animated:YES completion:nil];
    //
    //        }
    //    }
    [navBar setBackgroundImage:[UIImage imageNamed:@"greenheadpic"] forBarMetrics:UIBarMetricsDefault];
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
