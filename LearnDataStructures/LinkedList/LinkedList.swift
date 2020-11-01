//
//  LinkedList.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/28.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

/*
 之前学习的动态数组、栈、队列底层都是依托于静态数组，通过 resize 解决容量问题。
 链表是最简单的动态数据结构。
 
 优点：
 真正的动态，不需要处理固定容量的问题。
 缺点：
 丧失了随机访问的能力。（这也是数组的优点）
 
 单链表各个操作时间复杂度：
 func append(value: T)                          O(1) // 如果不添加 tail 的话复杂度为 O(n)
 func insert(_ value: T, at index: 0)           O(1)
 func insert(_ value: T, at index: Int)         O(n)
 
 func removeAll()                               O(1)
 func remove(at index: Int) -> T                O(n)
 func removeFirst() -> T                        O(1)
 func removeLast() -> T                         O(n)
 
 linkedList[n] = newValue                       O(n)
 
 var first: T? { get }                          O(1)
 var last: T? { get }                           O(1) // 如果不添加 tail 的话复杂度为 O(n)
 linkedList[n]                                  O(n)
 func contains(_ value: T) -> Bool              O(n)
 
 也就是说，总体来讲，对于链表来说，增删改查全是 O(n) 级别的。
 但是如果只是对链表头进行操作，那么不管是增删改查，都是 O(1) 级别的。
 
 链表的复杂度主要是花费在查找节点上，而具体删除或者插入的操作是很方便的，这点和数组不同，数组体现在查找特别快，但是删除或者插入比较麻烦。
 
 链表的增删改查操作可以尝试使用递归实现。
 
 这里实现的是一个具有尾指针的单链表。
 */
public final class LinkedList<T> {
    
    /// 节点类。
    private class Node {
        var value: T
        var next: Node?
        
        init(value: T) {
            self.value = value
        }
    }
    
    /// 头部节点。
    private var head: Node?
    /// 尾部节点。
    private var tail: Node?
    /// 元素数量。
    private var size: Int = 0
    
    /// 链表是否为空。
    public var isEmpty: Bool {
        return size == 0
    }
    
    /// 链表元素数量。
    public var count: Int {
        return size
    }
    
    /// 链表头。
    public var first: T? {
        return head?.value
    }
    
    /// 链表尾。
    public var last: T? {
        return tail?.value
    }
    
    /// 通过下标获取或设置指定索引的元素，如果索引错误则崩溃。
    public subscript(index: Int) -> T {
        
        set {
            let n = node(at: index)
            n.value = newValue
        }
        
        get {
            let n = node(at: index)
            return n.value
        }
    }
    
    /// 指定索引插入元素。
    /// - Parameters:
    ///   - value: 所插入的元素。
    ///   - index: 指定的索引。
    public func insert(_ value: T, at index: Int) {
        let newNode = Node(value: value)
        if index == 0 {
            newNode.next = head
            head = newNode
            
            if size == 0 {
                tail = newNode
            }
        } else if index == size {
            tail?.next = newNode
            tail = newNode
        } else {
            let prev = node(at: index-1)
            
            newNode.next = prev.next
            prev.next = newNode
        }
        size += 1
    }
    
    /// 链表尾部追加一个元素。
    /// - Parameter value: 新加的元素。
    public func append(_ value: T) {
        insert(value, at: size)
    }
    
    /// 删除链表所有元素。
    public func removeAll() {
        tail = nil
        head = nil
    }
    
    /// 删除指定索引的节点，并返回删除节点的元素。
    /// - Parameter index: 指定的索引。
    @discardableResult
    public func remove(at index: Int) -> T {
        
        var retNode: Node
        if index == 0 {
            let n = node(at: index)
            retNode = n
            if n.next == nil {
                tail = nil
            }
            head = n.next
            n.next = nil
            
        } else {
            let prev = node(at: index - 1)
            guard let n = prev.next else {
                fatalError("Index is illegal")
            }
            
            retNode = n
            if n.next == nil {
                tail = prev
            }
            prev.next = n.next
            n.next = nil
        }
        size -= 1
        
        return retNode.value
    }
    
    /// 删除链表头部节点，并返回其元素。
    @discardableResult
    public func removeFirst() -> T {
        return remove(at: 0)
    }
    
    /// 删除链表尾部节点，并返回其元素。
    @discardableResult
    public func removeLast() -> T {
        return remove(at: size - 1)
    }
    
    /// 根据闭包内容删除元素。
    /// - Parameter shouldBeRemoved: 传入的闭包或函数。
    public func removeAll(where shouldBeRemoved: (T) -> Bool) {
        
        while let node = head, shouldBeRemoved(node.value) {
            head = node.next
            node.next = nil
        }
        
        var prev = head
        while let n = prev?.next {
            if shouldBeRemoved(n.value) {
                prev?.next = n.next
                n.next = nil
            } else {
                prev = n
            }
        }
    }
    
    /// Map 函数。
    /// - Parameter transform: 映射函数。
    public func map<U>(_ transform: (T) -> U) -> LinkedList<U> {
      let result = LinkedList<U>()
      var node = head
      while let n = node {
        result.append(transform(n.value))
        node = n.next
      }
      return result
    }
    
    /// Filter 函数。
    /// - Parameter isIncluded: 判断包含的函数。
    public func filter(_ isIncluded: (T) -> Bool) -> LinkedList<T> {
        let result = LinkedList<T>()
        var node = head
        while let n = node {
          if isIncluded(n.value) {
            result.append(n.value)
          }
          node = n.next
        }
        return result
    }
    
    /// 获取指定索引的节点。如果索引错误则崩溃。
    /// - Parameter index: 指定索引。
    private func node(at index: Int) -> Node {
        
        // 当索引非法崩溃时可以输出自定义语句。
        guard index >= 0 && index < size else {
            fatalError("Index is illegal")
        }
        
        if index == size - 1 {
            return tail!
        }
        
        var node = head! // 索引限制，保证这里 head 不会为 nil。
        for _ in 0..<index {
            node = node.next!
        }
        
        return node
    }
}

extension LinkedList where T: Equatable {
    
    /// 是否包含某元素。
    /// - Parameter value: 某元素。
    public func contains(_ value: T) -> Bool {
        
        var node = head
        while let n = node {
            if n.value == value {
                return true
            }
            node = n.next
        }
        
        return false
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        
        var s = "["
        var node = head
        while node != nil {
          s += "\(node!.value)"
          node = node!.next
          if node != nil { s += ", " }
        }
        return s + "] ->nil"
    }
}
