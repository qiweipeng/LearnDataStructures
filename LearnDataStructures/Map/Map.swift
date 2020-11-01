//
//  Map.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/28.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

/*
 映射协议
 
 映射可以使用链表实现，也可以使用二分搜索树实现，当然也可以使用哈希表实现，和集合是很像的。
 和集合不同的是，映射中每个节点不仅仅要包含一个值，而是要有一组键值对，所有我们无法直接使用之前实现的链表和二分搜索树中的接口，而需要重新实现。
 整体性能上可以参考集合的对比，依然是二分搜索树实现的优于链表实现的，之后哈希表实现的由于其无序，性能还会略好于搜索树实现的。
 复杂度水平都是和集合是相同的。
 */
public protocol Map {
    associatedtype Key
    associatedtype Value
    
    /// 映射是否为空。
    var isEmpty: Bool { get }
    
    /// 映射中元素的数量。
    var count: Int { get }
    
    /// 是否包含。
    /// - Parameter key: 指定的 key。
    func contains(_ key: Key) -> Bool
    
    /// 下标，实现 get set add 方法。
    subscript(key: Key) -> Value? { get set }
    
    /// 移除指定 key 的元素。
    /// - Parameter key: 指定的 key。
    mutating func removeValue(forKey key: Key) -> Value?
    
    /// 移除所有。
    mutating func removeAll()
}

/*
 链表实现的映射。
 
            操作                                          链表映射
 func contains(_ key: Key) -> Bool                         O(n)
 subscript(key: Key) -> Value? { get set }                 O(n)
 func removeValue(forKey key: Key) -> Value?               O(n)
 
 链表实现的映射的增删改查操作都必须对链表进行遍历，复杂度都是 O(n)，性能并不够好。
 */
public class LinkedListMap<Key: Equatable, Value>: Map {
    
    /// 节点类。
    private class Node {
        var key: Key
        var value: Value
        var next: Node?
        
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
    }
    
    /// 头部节点。
    private var head: Node?
    /// 元素数量。
    private var size: Int = 0
    
    /// 寻找指定 key 的节点。
    /// - Parameter key: 指定的 key。
    /// - Returns: 找到的节点。
    private func node(_ key: Key) -> Node? {
        
        var node = head
        while let n = node {
            if n.key == key {
                return node
            }
            node = n.next
        }
        
        return nil
    }
    
    public var isEmpty: Bool {
        return size == 0
    }
    
    public var count: Int {
        return size
    }
    
    public func contains(_ key: Key) -> Bool {
        return node(key) != nil
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return node(key)?.value
        }
        set {
            guard let node = node(key) else {
                if let value = newValue {
                    let newNode = Node(key: key, value: value)
                    newNode.next = head
                    head = newNode
                    
                    size += 1
                }
                return
            }
            
            if let value = newValue {
                node.value = value
            } else {
                removeValue(forKey: key)
            }
        }
    }
    
    @discardableResult
    public func removeValue(forKey key: Key) -> Value? {
        
        guard let node = head else { return nil }
        
        if node.key == key {
            head = node.next
            node.next = nil
            size -= 1
            return node.value
        } else {
            var prev: Node? = node
            
            while let n = prev?.next {
                if n.key == key {
                    prev?.next = n.next
                    n.next = nil
                    size -= 1
                    return n.value
                }
                prev = prev?.next
            }
            
            return nil
        }
    }
    
    public func removeAll() {
        head = nil
    }
}

extension LinkedListMap: CustomStringConvertible {
    public var description: String {
        var s = "["
        var node = head
        while node != nil {
            s += "\(node!.key)" + ": " + "\(node!.value)"
          node = node!.next
          if node != nil { s += ", " }
        }
        return s + "]"
    }
}


/*
二分搜索树实现的映射。

           操作                                          BSTMap     最优/平均     最坏
func contains(_ key: Key) -> Bool                         O(h)    O(logn)      O(n)
subscript(key: Key) -> Value? { get set }                 O(h)    O(logn)      O(n)
func removeValue(forKey key: Key) -> Value?               O(h)    O(logn)      O(n)

二分搜索树实现的映射可以类比集合，特点都是类似。
*/
public class BinarySearchTreeMap<Key: Comparable, Value>: Map {
    
    /// 节点类。
    private class Node: CustomStringConvertible {
        
        var key: Key
        var value: Value
        var left: Node?
        var right: Node?
        
        init(key: Key, value: Value) {
            self.key = key
            self.value = value
        }
        var description: String {
            var s = ""
            if let left = left {
                s += "(" + left.description + ") <- "
            }
            s += "\(key)" + ": " + "\(value)"
            if let right = right {
                s += " -> (" + right.description + ")"
            }
            return s
        }
    }
    
    /// 根节点。
    private var root: Node?
    /// 节点数量。
    private var size: Int = 0
    
    public var isEmpty: Bool {
        return size == 0
    }
    
    public var count: Int {
        return size
    }
    
    public func contains(_ key: Key) -> Bool {
        return contains(key, in: root)
    }
    
    private func contains(_ key: Key, in node: Node?) -> Bool {
        guard let node = node else {
            return false
        }
        
        if node.key == key {
            return true
        } else if node.key > key {
            return contains(key, in: node.left)
        } else {
            return contains(key, in: node.right)
        }
    }
    
    public subscript(key: Key) -> Value? {
        get {
            return find(key, in: root)?.value
        }
        set {
            if let value = newValue {
                root = insert(key, value, to: root)
            } else {
                removeValue(forKey: key)
            }
        }
    }
    
    private func insert(_ key: Key, _ value: Value, to node: Node?) -> Node {
        guard let node = node else {
            size += 1
            return Node(key: key, value: value)
        }
        
        if node.key > key {
            node.left = insert(key, value, to: node.left)
        } else if node.key < key {
            node.right = insert(key, value, to: node.right)
        } else {
            node.value = value
        }
        
        return node
    }
    
    private func find(_ key: Key, in node: Node?) -> Node? {
        guard let node = node else { return nil }
        
        if node.key == key {
            return node
        } else if node.key > key {
            return find(key, in: node.left)
        } else {
            return find(key, in: node.right)
        }
    }
    
    @discardableResult
    public func removeValue(forKey key: Key) -> Value? {
        guard let node = find(key, in: root) else { return nil }
        root = remove(key, from: root)
        return node.value
    }
    
    private func minimum(_ node: Node) -> Node {
        guard let left = node.left else {
            return node
        }
        
        return minimum(left)
    }
    
    private func removeMinimum(from node: Node) -> Node? {
        
        if node.left == nil {
            let right = node.right
            node.right = nil
            size -= 1
            return right
        }

        node.left = removeMinimum(from: node.left!)
        return node
    }
    
    private func remove(_ key: Key, from node: Node?) -> Node? {
        guard let node = node else {
            return nil
        }
        // value 和 node 节点的值做比较，如果较小就去左子树寻找，如果较大就去右子树寻找
        if key < node.key {
            node.left = remove(key, from: node.left)
            return node
        } else if key > node.key {
            node.right = remove(key, from: node.right)
            return node
        } else {
            // value 正好等于 node 节点的值
            
            // 待删除节点右子树为空
            if node.left == nil {
                let right = node.right
                node.right = nil
                size -= 1
                return right
            }
            
            // 待删除节点右子树为空
            if node.right == nil {
                let left = node.left
                node.left = nil
                size -= 1
                return left
            }
            
            // 待删除节点左右子树均不为空
            // 找到比待删除节点大的最小节点，即待删除节点右子树的最小节点
            // 用这个节点顶替待删除节点的位置。
            let successor = minimum(node.right!)
            successor.right = removeMinimum(from: node.right!)
            successor.left = node.left
            node.left = nil
            node.right = nil
            
            return successor
        }
    }
    
    public func removeAll() {
        root = nil
    }
}

extension BinarySearchTreeMap: CustomStringConvertible {
    
    public var description: String {
        guard let root = root else {
            return "nil"
        }
        
        return root.description
    }
}
