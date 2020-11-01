//
//  QueueTester.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/28.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

class QueueTester {
    
    /// 测试数组队列。
    func test1() {
        var queue = ArrayQueue<Int>()
        
        for i in 0..<10 {
            queue.enqueue(i)
            print(queue)
            
            if i % 3 == 2 {
                queue.dequeue()
                print(queue)
            }
        }
        
        /*
         Queue: front [0] tail
         Queue: front [0, 1] tail
         Queue: front [0, 1, 2] tail
         Queue: front [1, 2] tail
         Queue: front [1, 2, 3] tail
         Queue: front [1, 2, 3, 4] tail
         Queue: front [1, 2, 3, 4, 5] tail
         Queue: front [2, 3, 4, 5] tail
         Queue: front [2, 3, 4, 5, 6] tail
         Queue: front [2, 3, 4, 5, 6, 7] tail
         Queue: front [2, 3, 4, 5, 6, 7, 8] tail
         Queue: front [3, 4, 5, 6, 7, 8] tail
         Queue: front [3, 4, 5, 6, 7, 8, 9] tail
         */
    }
    
    /// 测试优化后的队列。
    func test2() {
        var queue = LazyQueue<Int>()
        
        for i in 0..<10 {
            queue.enqueue(i)
            print(queue)
            
            if i % 3 == 2 {
                queue.dequeue()
                print(queue)
            }
        }
        
        /*
         Queue: front [0] tail
         Queue: front [0, 1] tail
         Queue: front [0, 1, 2] tail
         Queue: front [1, 2] tail
         Queue: front [1, 2, 3] tail
         Queue: front [1, 2, 3, 4] tail
         Queue: front [1, 2, 3, 4, 5] tail
         Queue: front [2, 3, 4, 5] tail
         Queue: front [2, 3, 4, 5, 6] tail
         Queue: front [2, 3, 4, 5, 6, 7] tail
         Queue: front [2, 3, 4, 5, 6, 7, 8] tail
         Queue: front [3, 4, 5, 6, 7, 8] tail
         Queue: front [3, 4, 5, 6, 7, 8, 9] tail
         */
    }
    
    /// 测试链表队列。
    func test3() {
        let queue = LinkedListQueue<Int>()
        
        for i in 0..<10 {
            queue.enqueue(i)
            print(queue)
            
            if i % 3 == 2 {
                queue.dequeue()
                print(queue)
            }
        }
        
        /*
         Queue: front [0] ->nil tail
         Queue: front [0, 1] ->nil tail
         Queue: front [0, 1, 2] ->nil tail
         Queue: front [1, 2] ->nil tail
         Queue: front [1, 2, 3] ->nil tail
         Queue: front [1, 2, 3, 4] ->nil tail
         Queue: front [1, 2, 3, 4, 5] ->nil tail
         Queue: front [2, 3, 4, 5] ->nil tail
         Queue: front [2, 3, 4, 5, 6] ->nil tail
         Queue: front [2, 3, 4, 5, 6, 7] ->nil tail
         Queue: front [2, 3, 4, 5, 6, 7, 8] ->nil tail
         Queue: front [3, 4, 5, 6, 7, 8] ->nil tail
         Queue: front [3, 4, 5, 6, 7, 8, 9] ->nil tail
         */
    }
    
    /// 不同实现方式的队列性能对比。
    func test4() {
        
        let opCount = 1_000_000
        
        let arrayQueue = ArrayQueue<Int>()
        let time1 = testQueue(arrayQueue, opCount: opCount)
        print("ArrayQueue: \(time1)")
        
        let lazyQueue = LazyQueue<Int>()
        let time2 = testQueue(lazyQueue, opCount: opCount)
        print("LazyQueue: \(time2)")
        
        let linkedListQueue = LinkedListQueue<Int>()
        let time3 = testQueue(linkedListQueue, opCount: opCount)
        print("LinkedListQueue: \(time3)")
        
        /*
        opCount = 100_000
        ArrayQueue: 1.121593952178955
        LazyQueue: 0.15566504001617432
        LinkedListQueue: 0.206170916557312
        
        opCount = 1_000_000
        ArrayQueue: 90.82065796852112
        LazyQueue: 1.4719690084457397
        LinkedListQueue: 1.9228450059890747
        */
    }
    
    // 这里使用了泛型约束，并使用了泛型的 where 语句规定具体类型为 Int，注意语法书写的。
    private func testQueue<T: Queue>(_ queue: T, opCount: Int) -> CFAbsoluteTime where T.T == Int {
        
        var queue = queue
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<opCount {
            queue.enqueue(Int(arc4random()%1000))
        }
        
        for _ in 0..<opCount {
            queue.dequeue()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        
        return endTime - startTime
    }
}
