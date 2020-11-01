//
//  MapTester.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/28.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

class MapTester {
    func test1() {
        let map = LinkedListMap<String, Int>()
        map["Hi"] = 2
        map["Hello"] = 6
        print(map)
        
        map.removeValue(forKey: "Hi")
        
        map["Oli"] = 3
        map["Hello"] = 5
        map["Roger"] = 5
        map["Apple"] = 5
        print(map)
    }
    
    func test2() {
        let map = BinarySearchTreeMap<String, Int>()
        map["Hi"] = 2
        map["Hello"] = 6
        print(map)
        
        map.removeValue(forKey: "Hi")
        map["Oli"] = 3
        map["Hello"] = 5
        map["Roger"] = 5
        map["Apple"] = 5
        print(map)
    }
    
    func test3() {
        
        let linkedListMap = LinkedListMap<Int, Int>()
        let bstMap = BinarySearchTreeMap<Int, Int>()
        
        let time1 = CFAbsoluteTimeGetCurrent()
        for i in 0..<10_000 {
            let random = Int(arc4random()%10000)
            linkedListMap[random] = i
        }
        
        let time2 = CFAbsoluteTimeGetCurrent()
        for i in 0..<10_000 {
            let random = Int(arc4random()%10000)
            bstMap[random] = i
        }
        
        let time3 = CFAbsoluteTimeGetCurrent()
        
        print(time2 - time1)
        print(time3 - time2)
        
        /*
         打印结果：
         1.3970839977264404
         0.02455902099609375
         
         这里仅仅测试插入/修改，二分搜索树的实现性能要远好于链表的实现。
         */
    }
    
    func test4() {
        let linkedListMap = LinkedListMap<Int, Int>()
        let bstMap = BinarySearchTreeMap<Int, Int>()
        
        let time1 = CFAbsoluteTimeGetCurrent()
        for i in 0..<10_000 {
            linkedListMap[i] = i
        }
        
        let time2 = CFAbsoluteTimeGetCurrent()
        for i in 0..<10_000 {
            bstMap[i] = i
        }
        
        let time3 = CFAbsoluteTimeGetCurrent()
        
        print(time2 - time1)
        print(time3 - time2)
        
        /*
         打印结果：
         2.428871989250183
         4.965176939964294
         
         二分搜索树退化为链表，复杂度退化为 O(n)。
         */
    }
}
