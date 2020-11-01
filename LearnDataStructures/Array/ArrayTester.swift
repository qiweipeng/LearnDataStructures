//
//  ArrayTester.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/27.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

class ArrayTester {
    
    /// Swift 默认数组与自定义数组性能对比。
    func test1() {

        var arr1 = Array<Int>()
        var arr2 = ArrayList<Int>(initialValue: 0)

        // 循环向数组首位插入 1000 以内的随机数。
        let time1 = CFAbsoluteTimeGetCurrent()

        for _ in 0..<1_000 {
            arr1.insert(Int(arc4random()%1000), at: 0)
        }

        let time2 = CFAbsoluteTimeGetCurrent()

        for _ in 0..<1_000 {
            arr2.insert(Int(arc4random()%1000), at: 0)
        }
        let time3 = CFAbsoluteTimeGetCurrent()

        // 循环修改元素
        for i in 0..<1_000 {
            arr1[i] = Int(arc4random()%1000)
        }

        let time4 = CFAbsoluteTimeGetCurrent()

        for i in 0..<1_000 {
            arr2[i] = Int(arc4random()%1000)
        }

        let time5 = CFAbsoluteTimeGetCurrent()

        // 循环删除数组末尾元素。
        for _ in 0..<1_000 {
            arr1.removeLast()
        }
        let time6 = CFAbsoluteTimeGetCurrent()

        for _ in 0..<1_000 {
            arr2.removeLast()
        }
        let time7 = CFAbsoluteTimeGetCurrent()

        print(time2 - time1) // (1) 0.0016750097274780273
        print(time3 - time2) // (2) 0.2138199806213379
        print(time4 - time3) // (3) 0.0008569955825805664
        print(time5 - time4) // (4) 0.0008729696273803711
        print(time6 - time5) // (5) 0.0006029605865478516
        print(time7 - time6) // (6) 0.0009970664978027344

        /*
         数组从首位插入是插入元素的最差情况（删除类似），复杂度为 O(n)，(1)(2)的时间明显慢于后面四个
         尾部删除元素（类似还有尾部增加元素）是删除元素中最好情况，复杂度为 O(1)
         修改元素复杂度为 O(1)
         
         Swift 自带数组在比较差的情况性能是明显好过自定义的数组的。
         */
    }
}
