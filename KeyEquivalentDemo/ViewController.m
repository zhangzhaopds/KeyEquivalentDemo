//
//  ViewController.m
//  KeyEquivalentDemo
//
//  Created by 张昭 on 16/8/31.
//  Copyright © 2016年 张昭. All rights reserved.
//

#import "ViewController.h"

#import <Carbon/Carbon.h>

@interface ViewController ()

//@property (nonatomic, strong) 
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHotKeyEvent:) name:@"HotKeyEvent" object:nil];
    [self costomHotKey];
    
}



- (void)handleHotKeyEvent:(NSNotification *)noti {

    NSInteger hotKeyID = [[noti.userInfo objectForKey:@"hotKeyID"] intValue];
    
    if ( hotKeyID == 4) {
        self.view.window.backgroundColor = [NSColor blackColor];
    }
}


- (void)keyUp:(NSEvent *)theEvent {
    NSLog(@"%hu", theEvent.keyCode);
}

// 注册快捷键
- (void)costomHotKey {
    
    // 1、声明相关参数
    EventHotKeyRef myHotKeyRef;
    EventHotKeyID myHotKeyID;
    EventTypeSpec myEvenType;
    myEvenType.eventClass = kEventClassKeyboard;    // 键盘类型
    myEvenType.eventKind = kEventHotKeyPressed;     // 按压事件
    
    // 2、定义快捷键
    myHotKeyID.signature = 'yuus';  // 自定义签名
    myHotKeyID.id = 4;              // 快捷键ID

#pragma mark 注册快捷键
    // 3、注册快捷键
    // 参数一：keyCode; 如18代表1，19代表2，21代表4，49代表空格键，36代表回车键
    // 快捷键：command+4
    RegisterEventHotKey(21, cmdKey, myHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);
    
    // 快捷键：command+option+4
//    RegisterEventHotKey(21, cmdKey + optionKey, myHotKeyID, GetApplicationEventTarget(), 0, &myHotKeyRef);

    
    // 5、注册回调函数，响应快捷键
    InstallApplicationEventHandler(&hotKeyHandler, 1, &myEvenType, NULL, NULL);

    
}



// 4、自定义C类型的回调函数
OSStatus hotKeyHandler(EventHandlerCallRef nextHandler, EventRef anEvent, void *userData) {
    
    EventHotKeyID hotKeyRef;
    
    GetEventParameter(anEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hotKeyRef), NULL, &hotKeyRef);
    
    unsigned int hotKeyId = hotKeyRef.id;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotKeyEvent" object:nil userInfo:@{@"hotKeyID": @(hotKeyId)}];
    
    switch (hotKeyId) {
        case 4:
            // do something
            NSLog(@"%d", hotKeyId);
            break;
        default:
            break;
    }
    return noErr;
}






- (IBAction)commandOneBtnClicked:(NSButton *)sender {
    self.view.window.backgroundColor = [NSColor redColor];
}

- (IBAction)commandTwoBtnClicked:(NSButton *)sender {
    self.view.window.backgroundColor = [NSColor yellowColor];
}

- (IBAction)commandThreeBtnClicked:(NSButton *)sender {
    self.view.window.backgroundColor = [NSColor greenColor];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
