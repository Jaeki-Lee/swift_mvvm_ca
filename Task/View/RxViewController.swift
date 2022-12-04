//
//  RxViewController.swift
//  Task
//
//  Created by trost.jk on 2022/09/17.
//

import Foundation
import RxSwift
import RxCocoa

class RxViewController<T: RxViewModel>: UIViewController, Deinitializable {
    typealias ViewModel = T
    
    var viewModel: ViewModel!
    
    var disposeBag = DisposeBag()
    
    func deinitialize() {
        self.disposeBag = DisposeBag()
        self.viewModel.deinitialize()
        self.viewModel = nil
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if self.parent == nil {
            self.deinitialize()
        }
        
    }
}
