//
//  DoubleCycleLinkList.m
//  OC版数据结构
//
//  Created by 崇 on 2018/10/22.
//  Copyright © 2018年 崇. All rights reserved.
//

#import "DoubleCycleLinkList.h"

@interface DoubleCycleLinkListNode : NSObject

/**
 节点元素值
 */
@property (nonatomic, assign) NSInteger element;

/**
 下一个节点
 */
@property (nonatomic, strong) DoubleCycleLinkListNode *nextNode;

/**
 前一个节点
 */
@property (nonatomic, strong) DoubleCycleLinkListNode *prevNode;

@end

@implementation DoubleCycleLinkListNode

- (instancetype)initWithItem:(NSInteger)item {
    self = [super init];
    if (self) {
        self.element = item;
    }
    
    return self;
}

@end


@interface DoubleCycleLinkList()

/**
 链表头节点
 */
@property (nonatomic, strong) DoubleCycleLinkListNode *headNode;

@end

@implementation DoubleCycleLinkList

- (instancetype)initWithNode:(DoubleCycleLinkListNode *)node {
    
    self = [super init];
    if (self) {
        self.headNode = node;
        // 判断node不为空的情况，循环指向自己
        if (node) {
            node.nextNode = node;
            node.prevNode = node;
        }
    }
    return self;
}

- (BOOL)isEmpty {
    return self.headNode == nil;
}

- (NSInteger)length {
    if ([self isEmpty]) return 0;
    DoubleCycleLinkListNode *cur = self.headNode;
    NSInteger count = 1;
    while (cur.nextNode != self.headNode) {
        count++;
        cur = cur.nextNode;
    }
    return count;
}

- (void)travel {
    // 空链表的情况
    if ([self isEmpty]) return;
    
    DoubleCycleLinkListNode *cur = self.headNode;
    
    while (cur.nextNode != self.headNode) {
        NSLog(@"%ld", cur.element);
        cur = cur.nextNode;
    }
    
    // 退出循环，cur指向尾节点，但尾节点的元素未打印
    NSLog(@"%ld", cur.element);
}

// 链表头部添加元素，头插法

- (void)insertNodeAtHeadWithItem:(NSInteger)item {
    
    DoubleCycleLinkListNode *node = [[DoubleCycleLinkListNode alloc] initWithItem:item];
    if ([self isEmpty]) {
        self.headNode = node;
        node.nextNode = node;
        node.prevNode = node;
    }
    else {
        DoubleCycleLinkListNode *cur = self.headNode;
        while (cur.nextNode != self.headNode) {
            cur = cur.nextNode;
        }
        /**
         * 退出循环后，cur指向尾节点。
         * 因为是头插法，所以node是新头节点
         */
        node.nextNode = self.headNode;  // node向后是原head
        self.headNode.prevNode = node;  // 原head向前是node
        node.prevNode = cur;            // node向前，循环到尾节点
        cur.nextNode = node;            // 尾节点向后，循环到现头节点node
        self.headNode = node;
    }
}

// 链表尾部添加元素，尾插法
- (void)appendNodeWithItem:(NSInteger)item {
    
    DoubleCycleLinkListNode *node = [[DoubleCycleLinkListNode alloc] initWithItem:item];
    if ([self isEmpty]) {
        self.headNode = node;
        node.nextNode = node;
        node.prevNode = node;
    }
    else {
        DoubleCycleLinkListNode *cur = self.headNode;
        while (cur.nextNode != self.headNode) {
            cur = cur.nextNode;
        }
        /**
         * 退出循环后，cur指向尾节点。
         * 因为是尾插法，所以node是新尾节点
         */
        cur.nextNode = node;            // 原尾节点cur向后是现尾节点node
        node.prevNode = cur;            // 现尾节点node向前是原尾节点cur
        node.nextNode = self.headNode;  // 现尾节点node向后，循环到头节点
        self.headNode.prevNode = node;  // 头节点向前，循环到现尾节点node
    }
}

// 指定位置添加元素
- (void)insertNodeWithItem:(NSInteger)item atIndex:(NSInteger)index {
    
    if (index <= 0) {
        [self insertNodeAtHeadWithItem: item];
    }
    else if (index > ([self length] - 1)) {
        [self appendNodeWithItem: item];
    }
    else {
        DoubleCycleLinkListNode *cur = self.headNode;
        NSInteger count = 0;
        while (count < index) {
            count++;
            cur = cur.nextNode;
        }
        /*
         * 当循环退出后，cur指向index位置
         * cur是原index位置节点
         * node是现index位置节点
         */
        DoubleCycleLinkListNode *node = [[DoubleCycleLinkListNode alloc] initWithItem:item];
        node.nextNode = cur;            // node向后是cur
        node.prevNode = cur.prevNode;   // 未修改cur的prevNode前，node向前是cur的prevNode
        cur.prevNode.nextNode = node;   // 未修改cur的prevNode前，cur的prevNode向后是node
        cur.prevNode = node;            // 修改了cur的prevNode后，cur向前是node
    }
}

// 删除节点
- (void)removeNodeWithItem:(NSInteger)item {
    
    if ([self isEmpty]) return;
    
    DoubleCycleLinkListNode *cur = self.headNode;
    while (cur.nextNode != self.headNode) {
        if (cur.element == item) {
            // 1.删除头节点的情况
            if (cur == self.headNode) {
                // 先找到尾节点
                DoubleCycleLinkListNode *tail = self.headNode;
                while (tail.nextNode != self.headNode) {
                    tail = tail.nextNode;
                }
                // 循环结束后，tail指向当前尾节点
                self.headNode = cur.nextNode;   // cur就是头节点。让头节点指向其下一节点，即删除头节点
                self.headNode.prevNode = tail;  // 新头节点向前,循环到尾节点rear
                tail.nextNode = self.headNode;  // 尾节点rear向后，循环到新头节点
            }
            // 2.删除非头节点的情况
            else {
                cur.prevNode.nextNode = cur.nextNode;   // 看图解析
                cur.nextNode.prevNode = cur.prevNode;   // 看图解析
            }
            return;
        }
        else {
            cur = cur.nextNode;
        }
        // 退出循环，cur指向尾节点
        if (cur.element == item) {
            if (cur == self.headNode) {
                // 如果cur指向头节点，证明链表只有一个节点
                self.headNode = nil;
            }
            else {
                cur.prevNode.nextNode = cur.nextNode;   // 看图解析
                cur.nextNode.prevNode = cur.prevNode;   // 看图解析
            }
        }
    }
}

// 查找节点是否存在
- (BOOL)searchNodeWithItem:(NSInteger)item {
    
    if ([self isEmpty]) return NO;
    DoubleCycleLinkListNode *cur = self.headNode;
    while (cur.nextNode != self.headNode) {
        if (cur.element == item) {
            return YES;
        }
        else {
            cur = cur.nextNode;
        }
    }
    // 退出循环，cur指向尾节点
    if (cur.element == item) {
        return YES;
    }
    return NO;
}

@end
