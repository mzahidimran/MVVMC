//
//  ThreadSafeCollection.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 11/21/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
class ThreadSafeCollection<Element> {
  
    // Concurrent synchronization queue
    private let queue = DispatchQueue(label: "ThreadSafeCollection.queue", attributes: .concurrent)
  
    private var _elements: [Element] = []
  
    var elements: [Element] {
        var result: [Element] = []
        
        queue.sync { // Read
            result = _elements
        }

        return result
    }
    
    init(elements:[Element] = []) {
        self._elements = elements
    }
  
    func append(_ element: Element, completion:@escaping ()->Void) {
        // Write with .barrier
        // This can be performed synchronously or asynchronously not to block calling thread.
        queue.async(flags: .barrier) {
            self._elements.append(element)
            completion()
        }
    }
    
    func append(_ elements: [Element], completion:@escaping ()->Void) {
        // Write with .barrier
        // This can be performed synchronously or asynchronously not to block calling thread.
        queue.async(flags: .barrier) {
            self._elements.append(contentsOf: elements)
            completion()
        }
    }
    
    func clean(andAppend elements: [Element], completion:@escaping ()->Void)  {
        queue.async(flags: .barrier) {
            self._elements.removeAll()
            self._elements.append(contentsOf: elements)
            completion()
        }
    }
}
