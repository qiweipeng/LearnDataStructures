//
//  LinkedListTester.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/28.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

class LinkedListTester {
    
    func test1() {
        let linkedList = LinkedList<Int>()
        print(linkedList)
        print(linkedList.isEmpty)
        
        // 增
        for i in 1...10 {
            linkedList.append(i)
        }
        linkedList.append(11)
        linkedList.insert(0, at: 0)
        print(linkedList)
        
        // 查
        print(linkedList[7])
        print(linkedList.first ?? "")
        print(linkedList.last ?? "")
        print(linkedList.contains(6))
        print(linkedList.contains(15))
        
        // 改
        linkedList[3] = 30
        print(linkedList)
        
        // map
        let mapLinkedList = linkedList.map { (value) -> Int in
            value + 10
        }
        print(mapLinkedList)
        
        // filter
        let filterLinkedList = linkedList.filter { (value) -> Bool in
            value % 3 == 1
        }
        print(filterLinkedList)
        
        // 删
        linkedList.removeFirst()
        print(linkedList)
        linkedList.removeLast()
        print(linkedList)
        linkedList.remove(at: 0)
        print(linkedList)
        
        linkedList.removeAll { (value) -> Bool in
            value % 2 == 0
        }
        print(linkedList)
        
        /*
         打印结果：
         [] ->nil
         true
         [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11] ->nil
         7
         0
         11
         true
         false
         [0, 1, 2, 30, 4, 5, 6, 7, 8, 9, 10, 11] ->nil
         [10, 11, 12, 40, 14, 15, 16, 17, 18, 19, 20, 21] ->nil
         [1, 4, 7, 10] ->nil
         [1, 2, 30, 4, 5, 6, 7, 8, 9, 10, 11] ->nil
         [1, 2, 30, 4, 5, 6, 7, 8, 9, 10] ->nil
         [2, 30, 4, 5, 6, 7, 8, 9, 10] ->nil
         [5, 7, 9] ->nil
         */
        
    }
    
    func test2() {
        let linkedList1 = LinkedList<Int>()
        let linkedList2 = LinkedList<Int>()
        
        let time1 = CFAbsoluteTimeGetCurrent()
        // FIXME: 当前实现的链表这里添加元素如果过多，比如 100000 的时候最终会崩溃；但是如果程序结束前使用 remove 方法将元素移除使链表元素最终没有那么多就不会崩溃。
        for _ in 0..<50000 {
            linkedList1.insert(Int(arc4random()%1000), at: 0)
        }
        let time2 = CFAbsoluteTimeGetCurrent()
        for _ in 0..<50000 {
            linkedList2.append(Int(arc4random()%1000))
        }
        let time3 = CFAbsoluteTimeGetCurrent()
        
        print(time2 - time1)
        print(time3 - time2)
        
        /*
         打印结果：
         0.052745938301086426
         0.05307507514953613
         
         说明这个链表从尾部添加元素和从头部添加性能相当。
         */
    }
}
