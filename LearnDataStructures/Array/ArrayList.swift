//
//  ArrayList.swift
//  LearnDataStructures
//
//  Created by Weipeng Qi on 2020/3/27.
//  Copyright © 2020 Weipeng Qi. All rights reserved.
//

import Foundation

/*
 数组
 
 自定义的这个数组只练手用，后序的数据结构的实现不使用该数组。
 
 数组最大的优点是可以快速查询，scores[2]
 因此数组最好应用于 “索引有语意” 的情况
 
 关于时间复杂度：
 增 O(n)
 删 O(n)
 改 已知索引 O(1) 未知索引O(n)
 查 已知索引 O(1) 未知索引O(n)
 
 所以说，如果数组的索引有语义的情况下，改查的性能就会很高。
 对于增删，最好的情况是 O(1) 即增删在尾部，最差的情况是 O(n) 即增删在首位，平均还是 O(n)。
 */
public struct ArrayList<T> {
    
    private var data: [T]
    // 对于 Swift 来说，我们通过泛型创建的数组必须指定其中元素是什么，因为不会有默认是 0 的概念。
    private let initialValue: T
    // private(set) 代表外部只读，内部可读写，如果不设置 count，也可以直接将该变量设置为外部只读即可。
//    private(set) var size: Int
    private var size: Int
    
    /// 构造函数。
    /// - Parameters:
    ///   - capacity: 数组初始容量。
    ///   - initialValue: 数组默认初始值。
    public init(capacity: Int, initialValue: T) {
        data = Array<T>(repeating: initialValue, count: capacity)
        self.initialValue = initialValue
        size = 0
    }
    
    /// 构造函数，初始容量为 0。
    public init(initialValue: T) {
        data = Array<T>()
        self.initialValue = initialValue
        size = 0
    }
    
    /// 通过一个数组构造该动态数组。
    /// - Parameter array: 传入的数组。
    public init(array: [T], initialValue: T) {
        data = array
        self.initialValue = initialValue
        size = array.count
    }
    
    /// 数组当前元素数量。
    public var count: Int {
        return size
    }
    
    /// 数组当前容量。
    public var capacity: Int {
        return data.count
    }
    
    /// 数组元素是否为空。
    public var isEmpty: Bool {
        return size == 0
    }
    
    // 通过定义下标的方式为数组提供下标的读写，也就是 get 和 set 方法了。
    public subscript(index: Int) -> T {
        
        get {
            guard index >= 0 && index < size else {
                fatalError("Index out of range")
            }
            
            return data[index]
        }
        
        set {
            guard index >= 0 && index < size else {
                fatalError("Index out of range")
            }
            
            data[index] = newValue
        }
    }
    
    /// 数组首元素，如果不存在则返回 nil。
    public var first: T? {
        guard size > 0  else {
            return nil
        }
        
        return data[0]
    }
    
    /// 数组末尾元素，如果不存在则返回 nil。
    public var last: T? {
        guard size > 0 else {
            return nil
        }
        
        return data[size - 1]
    }
    
    /// 插入元素。
    /// - Parameters:
    ///   - newElement: 要插入的元素。
    ///   - i: 要插入元素的位置。
    public mutating func insert(_ newElement: T, at i: Int) {
        guard i >= 0 && i <= size else {
            fatalError("Array index is out of range")
        }
        
        if size == data.count {
            
            if data.count == 0 {
                resize(to: 1)
            } else {
                resize(to: 2 * data.count)
            }
        }
        
        // reversed() 复杂度为 O(1)
        for index in (i..<size).reversed() {
            data[index + 1] = data[index]
        }
        
        data[i] = newElement
        size += 1
    }
    
    /// 数组末尾添加元素。
    /// - Parameter newElement: 要添加的元素。
    public mutating func append(_ newElement: T) {
        insert(newElement, at: size)
    }
    
    /// 删除指定索引的元素。
    /// - Parameter index: 指定的索引。
    @discardableResult
    public mutating func remove(at index: Int) -> T {
        guard index >= 0 && index < size else {
            fatalError("Index out of range")
        }
        
        let ret = data[index]
        
        for i in index + 1..<size {
            data[i - 1] = data[i]
        }
        size -= 1;
        
        if size == data.count / 4 && data.count / 2 != 0 {
            resize(to: data.count / 2)
        }
        
        return ret
    }
    
    /// 删除首个元素
    @discardableResult
    public mutating func removeFirst() -> T {
        remove(at: 0)
    }
    
    /// 删除末尾元素
    @discardableResult
    public mutating func removeLast() -> T {
        remove(at: size - 1)
    }
    
    /*
     对于该算法复杂度的分析，最合适的应该是均摊复杂度分析，而不应该使用最坏的情况。因为 resize 操作是不可能每次添加元素都触发的。
     由于不是每次操作都触发，则这次的耗时可以分摊到每一次操作中。
     使用均摊复杂度分析的复杂度是 O(1) 级别的
     
     但是，如果我们正好在扩容和缩容的边界反复交替调用 addLast 和 removeLast 的话，复杂度就一直是 O(n) 级别的，这叫做复杂度震荡。
     为了防止复杂度震荡，我们可以在缩容的时候采取 lazy 的策略，即元素个数到 1/2 容量时先不要缩容，而等到更小，比如 1/4 的时候再进行。
     */
    /// 修改数组容量。
    /// - Parameter newCapacity: 新的容量。
    public mutating func resize(to newCapacity: Int) {
        
        guard newCapacity >= size else {
            fatalError("New capacity is illegal")
        }
        
        var newData: [T] = [T](repeating: initialValue, count: newCapacity)
        
        if size > 0 {
            for i in 0..<size {
                newData[i] = data[i]
            }
        }
        data = newData
    }
}

extension ArrayList: CustomStringConvertible {
    public var description: String {
        var str: String = "["
        
        if size > 0 {
            for i in 0..<size {
                if i != size - 1 {
                    str.append("\(data[i]), ")
                } else {
                    str.append("\(data[i])")
                }
            }
        }
        
        str.append("]")
        
        return str
    }
}

extension ArrayList where T: Equatable {
    
    // 对于该方法，data[i] == element 要求 T 必须是可判等的，所以类似 Swift 数组中的实现，需要额外放进一个 extension，这里必须要求 T 满足 Equatable 协议。
    // 事实上，对于 Swift 自带的数组，如果 T 不满足 Equatable 协议，也是无法使用该方法的。
    /// 数组是否包含某元素。
    /// - Parameter element: 判断的元素。
    public func contains(_ element: T) -> Bool {
        guard size > 0 else {
            return false
        }
        
        for i in 0..<size {
            if data[i] == element {
                return true
            }
        }
        
        return false
    }
    
    /// 查找某元素所在的第一个索引，如没有则返回 nil。
    /// - Parameter element: 查找的元素。
    public func firstIndex(of element: T) -> Int? {
        guard size > 0 else {
            return nil
        }
        
        for i in 0..<size {
            if data[i] == element {
                return i
            }
        }
        
        return nil
    }
}

