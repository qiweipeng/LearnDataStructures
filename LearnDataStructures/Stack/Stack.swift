//
//  Stack.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/28.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

/*
 栈协议
 
 栈对应的操作是数组的子集。
 对于栈的理解，其实它就是一个数组，只不过只能从一端添加元素，也只能从这一端删除元素。
 栈是一种后进先出的数据结构。
 
 栈的应用：
 1. 编辑器中的 Undo 操作，通常就是使用一个栈来维护的。
 2. 程序调用的系统栈。
    比如我们执行 A 函数，执行到第 2 行后其调用了 B 函数，那么 A 函数执行就暂停，开始调用 B 函数，此时就有一个栈来维护这个调用过程，类似 A2 就被 push 到栈里，记录 A 函数当前执行到第 2 行。类似的 B3 也可能被 push 到栈中去执行 C 函数，C 函数执行完了继续执行 B，那么栈就会执行一个 pop 操作。通过栈顶的记录，计算机就找到了继续执行哪个函数以及执行到哪里了。
 3. 编辑器中的括号匹配。
 
 由于栈的实现在底层我们可以有多种实现方式，因此对于「栈」我们定义为接口，而具体实现我们再使用一个类。
 */
public protocol Stack {
    associatedtype T
    
    /// 栈是否为空。
    var isEmpty: Bool { get }
    /// 栈中元素数量。
    var count: Int { get }
    
    /// 入栈。
    /// - Parameter element: 入栈的元素。
    mutating func push(_ element: T)
    /// 出栈。
    @discardableResult
    mutating func pop() -> T?
    
    /// 查看栈顶元素。
    func top() -> T?
}

/*
 数组栈
 
 这个栈中的五个方法复杂度：
 var isEmpty: Bool { get }           O(1)
 var count: Int { get }              O(1)
 mutating func push(_ element: T)    O(1) 均摊
 mutating func pop() -> T?           O(1) 均摊
 func top() -> T?                    O(1)
 
 可见这个栈的性能是不错的。
 
 分析：
 这里只分析 push 和 pop 操作，其中对数组的末尾元素的添加和删除复杂度都是 O(1)，这里需要额外考虑的是数组容量不足时的 resize 操作，但是 resize 操作不是每次都会发生，平均到每次操作上，也只会让复杂度变为大约 O(2)，所以均摊复杂度还是 O(1)。
 */
public struct ArrayStack<T>: Stack {
    
    private var array = [T]()
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    @discardableResult
    public mutating func pop() -> T? {
        // popLast 和 removeLast() 是不同的，前者返回的是可选型，数组为空时不会崩溃。
        return array.popLast()
    }
    
    public func top() -> T? {
        return array.last
    }
}

extension ArrayStack: CustomStringConvertible {
    public var description: String {
        return "Stack: " + array.description + " top"
    }
}

/*
链表栈

这个栈中的五个方法复杂度：
var isEmpty: Bool { get }           O(1)
var count: Int { get }              O(1)
func push(_ element: T)             O(1)
func pop() -> T?                    O(1)
func top() -> T?                    O(1)

链表栈和数组栈在各个操作上都是同一个级别的。
*/
public struct LinkedListStack<T>: Stack {
    
    private let linkedList = LinkedList<T>()
    
    public var isEmpty: Bool {
        return linkedList.isEmpty
    }
    
    public var count: Int {
        return linkedList.count
    }
    
    public func push(_ element: T) {
        linkedList.insert(element, at: 0)
    }
    
    @discardableResult
    public func pop() -> T? {
        guard !isEmpty else {
            return nil
        }
        
        return linkedList.removeFirst()
    }
    
    public func top() -> T? {
        return linkedList.first
    }
}

extension LinkedListStack: CustomStringConvertible {
    public var description: String {
        return "Stack: top " + linkedList.description
    }
}
