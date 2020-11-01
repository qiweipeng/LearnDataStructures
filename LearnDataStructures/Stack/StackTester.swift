//
//  StackTester.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/28.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

class StackTester {
    
    func test1() {
        
        var stack = ArrayStack<Int>()
        
        for i in 0..<5 {
            stack.push(i)
            print(stack)
        }
        
        stack.pop()
        print(stack)
        
        /*
         Stack: [0] top
         Stack: [0, 1] top
         Stack: [0, 1, 2] top
         Stack: [0, 1, 2, 3] top
         Stack: [0, 1, 2, 3, 4] top
         Stack: [0, 1, 2, 3] top
         */
    }
    
    func test2() {
        let stack = LinkedListStack<Int>()
        
        for i in 0..<5 {
            stack.push(i)
            print(stack)
        }
        
        stack.pop()
        print(stack)
        
        /*
         Stack: top [0] ->nil
         Stack: top [1, 0] ->nil
         Stack: top [2, 1, 0] ->nil
         Stack: top [3, 2, 1, 0] ->nil
         Stack: top [4, 3, 2, 1, 0] ->nil
         Stack: top [3, 2, 1, 0] ->nil
         */
    }
    
    func test3() {
        
        let opCount = 1_000_000
        
        let arrayStack = ArrayStack<Int>()
        let time1 = testStack(arrayStack, opCount: opCount)
        print("ArrayStack: \(time1)")
        
        let linkedListStack = LinkedListStack<Int>()
        let time2 = testStack(linkedListStack, opCount: opCount)
        print("LinkedListStack: \(time2)")
        
        /*
         opCount = 100_000
         ArrayStack: 0.15502405166625977
         LinkedListStack: 0.19788002967834473
         
         opCount = 1_000_000
         ArrayStack: 1.5347490310668945
         LinkedListStack: 1.999122977256775
         
         数组栈性能略好，但是两者在一个等级上。
         */
    }
    
    // 这里使用了泛型约束，并使用了泛型的 where 语句规定具体类型为 Int，注意语法书写的。
    private func testStack<T: Stack>(_ stack: T, opCount: Int) -> CFAbsoluteTime where T.T == Int {
        var stack = stack
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<opCount {
            stack.push(Int(arc4random()%1000))
        }
        
        for _ in 0..<opCount {
            stack.pop()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        
        return endTime - startTime
    }
}
