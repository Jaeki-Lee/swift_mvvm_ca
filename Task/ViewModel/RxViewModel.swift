//
//  RxViewModel.swift
//  Task
//
//  Created by trost.jk on 2022/09/17.
//

import Foundation
import RxSwift
import RxCocoa

protocol Deinitializable {
    func deinitialize()
}

protocol RxViewModelProtocol: Deinitializable {
    associatedtype Input
    associatedtype Output
    associatedtype Dependency
    
    var input: Input! { get }
    var output: Output! { get }
}

class RxViewModel: NSObject, Deinitializable {
    var disposeBag = DisposeBag()
    
    func deinitialize() {
        self.disposeBag = DisposeBag()
    }
    
    override init() {
        super.init()
        self.disposeBag = DisposeBag()
    }
    
}
