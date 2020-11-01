//
//  SetTester.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/28.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

class SetTester {
    
    func test1() {
        let linkedListSet = LinkedListSet<Int>()
        let bstSet = BinarySearchTreeSet<Int>()
        
        let time1 = CFAbsoluteTimeGetCurrent()
        for _ in 0..<10_000 {
            let random = Int(arc4random()%10000)
            linkedListSet.insert(random)
        }
        
        for i in 0..<10_000 {
            linkedListSet.remove(i)
        }
        let time2 = CFAbsoluteTimeGetCurrent()
        for _ in 0..<10_000 {
            let random = Int(arc4random()%10000)
            bstSet.insert(random)
        }
        
        for i in 0..<10_000 {
            bstSet.remove(i)
        }
        let time3 = CFAbsoluteTimeGetCurrent()
        
        print(time2 - time1)
        print(time3 - time2)
        
        /*
         打印结果：
         2.8797590732574463
         0.03473389148712158
         
         可见二分搜索树实现的集合性能明显更好。
         */
    }
    
    func test2() {
        let linkedListSet = LinkedListSet<Int>()
        let bstSet = BinarySearchTreeSet<Int>()
        
        let time1 = CFAbsoluteTimeGetCurrent()
        for i in 0..<10_000 {
            linkedListSet.insert(i)
        }
        
        for i in 0..<10_000 {
            linkedListSet.remove(i)
        }
        let time2 = CFAbsoluteTimeGetCurrent()
        for i in 0..<10_000 {
            bstSet.insert(i)
        }
        
        for i in 0..<10_000 {
            bstSet.remove(i)
        }
        let time3 = CFAbsoluteTimeGetCurrent()
        
        print(time2 - time1)
        print(time3 - time2)
        
        /*
         打印结果：
         4.518419981002808
         4.0840840339660645
         
         这次测试完全按照顺序添加元素，导致二分搜索树退化成了链表，于是性能退化成和链表一个水平了。
         */
    }
}
