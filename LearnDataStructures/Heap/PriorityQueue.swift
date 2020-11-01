//
//  PriorityQueue.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/31.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

/*
 优先队列
 
 func enqueue(_ element: T)             O(logn)
 func dequeue() -> T?                   O(logn)
 */
public struct PriorityQueue<T>: Queue {
    
    private var heap: Heap<T>
    
    public init(sort: @escaping (T, T) -> Bool) {
        heap = Heap(sort: sort)
    }
    
    public var isEmpty: Bool {
        heap.isEmpty
    }
    
    public var count: Int {
        return heap.count
    }
    
    public mutating func enqueue(_ element: T) {
        heap.insert(element)
    }
    
    public mutating func dequeue() -> T? {
        return heap.remove()
    }
    
    public var front: T? {
        return heap.peek()
    }
}
