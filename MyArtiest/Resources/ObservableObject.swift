//
//  ObservableObject.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/20/24.
//

import Foundation

final class ObservableObject<T> {
    
    // MARK: - Properties
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    private var listener: ((T) -> Void)?
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: @escaping(T) -> Void) {
        listener(value)
        self.listener = listener
    }
}
