//
//  Heap.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/31.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

/*
 堆
 
 优先队列就是出队永远需要优先级对高的。优先队列针对的是动态的情况，如果是静态的，那么只需要排序一次即可。
 
 如果使用之前的线性数据结构实现优先队列，入队操作是 O(1)，但是出队操作需要遍历找到优先级最高的元素，因此是 O(n)。
 如果专门维护一个顺序的线性结构，也就是入队直接排序好，那么入队复杂度为 O(n)，出队复杂度为 O(1)。
 使用堆实现的优先队列，入队出队复杂度均为 O(logn)
 
 对于满二叉树，就是所有非叶子节点均既有左孩子，又有右孩子。
 完全二叉树不一定是满二叉树，但是其不满的部分一定是在树的右下侧。也就是除了最底层之外，上面的是一个满二叉树，最底层从左开始放置元素。
 
 二叉堆是一棵完全二叉树。
 堆中某个节点的值总是不大于其父节点的值，这叫做最大堆。相应也可以定义最小堆。
 
 因为二叉堆是一个完全二叉树，其实也能使用数组来表示这个完全二叉树，即分别按照层数从上倒下，从左到右放进数组，根节点放进索引为 1的位置，以此类推。
 
 放进数组后，假如某节点索引为 i，那么左孩子节点索引就是 2i，右孩子节点索引就是 2i+1，其父节点索引就是 i/2
 如果根节点位置直接放进索引为 0的位置，那么放进数组后，假如某节点索引为 i，那么左孩子节点索引就是 2i + 1，右孩子节点索引就是 2i+2，其父节点索引就是 (i - 1)/2
 对于完全二叉树，寻找最后一个非叶子节点的索引就是找最后一个节点的父亲节点
 
 需要注意的是，完全二叉树是不会退化为链表的，所以这个时间复杂度是可以一直保持的。
 
 我们实现的是二叉堆，相应的也就有三叉堆、四叉堆等等
 对于 d叉堆来说，层数有可能更少，这在有些操作上会让速度更快
 但是比如下沉操作，就要考虑 d 个子节点而不是 2 个
 
 更高级的堆还有 索引堆，它可以操作堆中的某个元素
 二项堆
 斐波那契堆
 */
public struct Heap<T> {
    
    private var nodes = [T]()
    
    // 排序标准。
    private var orderCriteria: (T, T) -> Bool
    
    /// 构造函数。
    /// - Parameter sort: 排序方式。
    public init(sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
    }
    
    /// Heapify 一个数组。
    /// - Parameters:
    ///   - array: 传入的数组。
    ///   - sort: 排序方式。
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
        configureHeap(from: array)
    }
    
    /*
     如果将一个数组中元素依次插入到一个新堆中，复杂度是 O(nlogn)，但是 Heapify 的复杂度是 O(n)。
     */
    private mutating func configureHeap(from array: [T]) {
        nodes = array
        for i in stride(from: (nodes.count / 2 - 1), through: 0, by: -1) {
            shiftDown(i)
        }
    }
    
    /// 堆是否为空。
    public var isEmpty: Bool {
        return nodes.isEmpty
    }
    
    /// 堆元素个数。
    public var count: Int {
        return nodes.count
    }
    
    // 父节点索引。
    @inline(__always) internal func parentIndex(ofIndex i: Int) -> Int {
        return (i - 1) / 2
    }
    
    // 左孩子索引。
    @inline(__always) internal func leftChildIndex(ofIndex i: Int) -> Int {
        return 2 * i + 1
    }
    
    // 右孩子索引。
    @inline(__always) internal func rightChildIndex(ofIndex i: Int) -> Int {
        return 2 * i + 2
    }
    
    /// 查看堆顶元素。
    /// - Returns: 队首元素。
    public func peek() -> T? {
        return nodes.first
    }
    
    
    /// 堆插入新元素。
    /// - Parameter value: 新元素。
    public mutating func insert(_ value: T) {
        nodes.append(value)
        shiftUp(nodes.count - 1)
    }
    
    /// 替换堆顶元素。
    /// - Parameter value: 新元素。
    /// - Returns: 原队首元素。
    public mutating func replace(value: T) -> T? {
        guard !isEmpty else { return nil }
        
        let ret = peek()
        // replace 操作将两个 O(logn) 操作合二为一，变成了一个 O(logn) 的操作。
        nodes[0] = value
        shiftDown(0)
        
        return ret
    }
    
    /// 删除堆顶元素。
    /// - Returns: 堆顶元素。
    @discardableResult
    public mutating func remove() -> T? {
        guard !nodes.isEmpty else { return nil }
        
        if nodes.count == 1 {
            return nodes.removeLast()
        } else {
            let value = nodes[0]
            nodes[0] = nodes.removeLast()
            shiftDown(0)
            return value
        }
    }
    
    // 删除堆中指定索引元素。
    @discardableResult
    private mutating func remove(at index: Int) -> T? {
        guard index < nodes.count else { return nil }
        
        let size = nodes.count - 1
        if index != size {
            nodes.swapAt(index, size)
            shiftDown(from: index, until: size)
            shiftUp(index)
        }
        return nodes.removeLast()
    }
    
    private mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = nodes[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)
        
        while childIndex > 0 && orderCriteria(child, nodes[parentIndex]) {
            nodes[childIndex] = nodes[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(ofIndex: childIndex)
        }
        
        nodes[childIndex] = child
    }
    
    private mutating func shiftDown(from index: Int, until endIndex: Int) {
        let leftChildIndex = self.leftChildIndex(ofIndex: index)
        let rightChildIndex = leftChildIndex + 1
        
        var first = index
        if leftChildIndex < endIndex && orderCriteria(nodes[leftChildIndex], nodes[first]) {
            first = leftChildIndex
        }
        if rightChildIndex < endIndex && orderCriteria(nodes[rightChildIndex], nodes[first]) {
            first = rightChildIndex
        }
        if first == index { return }
        
        nodes.swapAt(index, first)
        shiftDown(from: first, until: endIndex)
    }
    
    private mutating func shiftDown(_ index: Int) {
        shiftDown(from: index, until: nodes.count)
    }
}
