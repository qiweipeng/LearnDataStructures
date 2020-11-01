//
//  Queue.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/28.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

/*
 队列协议
 
 队列的的操作也是数组的子集，不同的是，队列只能从一端（队尾）添加元素，只能从另一端（队首）取出元素。
 */
public protocol Queue {
    associatedtype T
    
    /// 队列是否为空。
    var isEmpty: Bool { get }
    /// 队列中元素数量。
    var count: Int { get }
    
    /// 入队。
    /// - Parameter element: 入队的元素。
    mutating func enqueue(_ element: T)
    
    /// 出队。
    @discardableResult
    mutating func dequeue() -> T?
    
    /// 队首元素。
    var front: T? { get }
}

/*
 类似栈的实现，这里也使用动态数组对队列进行一个实现。
 
 这个队列中的五个方法复杂度：
 var isEmpty: Bool { get }              O(1)
 var count: Int { get }                 O(1)
 mutating func enqueue(_ element: T)    O(1) 均摊
 mutating func dequeue() -> T?          O(n)
 var front: T? { get }                  O(1)
 
 可以看到，数组实现的队列最大问题就是出队的复杂度是 O(n)。
 */
public struct ArrayQueue<T>: Queue {
    
    private var array = [T]()
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    @discardableResult
    public mutating func dequeue() -> T? {
        guard !isEmpty else {
            return nil
        }
        
        return array.removeFirst()
    }
    
    public var front: T? {
        return array.first
    }
}

extension ArrayQueue: CustomStringConvertible {
    public var description: String {
        return "Queue: front " + array.description + " tail"
    }
}

/*
 这个队列和循环队列相比，不会将队尾元素插入到数组头部，而是将数组头部空间空缺，没过一段时间整体移除一次头部空缺，因此相对于数组队列，将出队操作优化为 O(1) 级别。
 由于其相对于数组队列，元素的位移操作是 lazy 的，就暂时将它命名为 LazyQueue。
 
 相对于循环队列，这个队列在时间上的性能是一个级别的，空间上的性能会略差，但是实现逻辑更简单。
 
 这个队列中的五个方法复杂度：
 var isEmpty: Bool { get }              O(1)
 var count: Int { get }                 O(1)
 mutating func enqueue(_ element: T)    O(1) 均摊
 mutating func dequeue() -> T?          O(1) 均摊
 var front: T? { get }                  O(1)
 
 这个队列解决了数组队列的问题，所有操作的性能都已经很好了。
 */
public struct LazyQueue<T>: Queue {
    
    private var array = [T?]()
    private var head = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var count: Int {
        return array.count - head
    }
    
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    @discardableResult
    public mutating func dequeue() -> T? {
        guard head < array.count, let element = array[head] else { return nil }
        
        array[head] = nil
        head += 1
        
        let percentage = Double(head)/Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        
        return element
    }
    
    public var front: T? {
        if isEmpty {
            return nil
        } else {
            return array[head]
        }
    }
}

extension LazyQueue: CustomStringConvertible {
    public var description: String {
        return "Queue: front " + Array(array.suffix(count)).map { $0! }.description + " tail"
    }
}

/*
链表队列。

这个队列中的五个方法复杂度：
var isEmpty: Bool { get }              O(1)
var count: Int { get }                 O(1)
func enqueue(_ element: T)             O(1)
func dequeue() -> T?                   O(1)
var front: T? { get }                  O(1)

这个队列同样各个操作的复杂度都是 O(1)。
*/
public struct LinkedListQueue<T>: Queue {
    
    private let linkedList = LinkedList<T>()
    
    public var isEmpty: Bool {
        return linkedList.isEmpty
    }
    
    public var count: Int {
        return linkedList.count
    }
    
    public func enqueue(_ element: T) {
        linkedList.append(element)
    }
    
    @discardableResult
    public func dequeue() -> T? {
        guard !isEmpty else {
            return nil
        }
        
        return linkedList.removeFirst()
    }
    
    public var front: T? {
        return linkedList.first
    }
}

extension LinkedListQueue: CustomStringConvertible {
    public var description: String {
        return "Queue: front " + linkedList.description + " tail"
    }
}
