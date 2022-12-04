//
//  DetailViewModel.swift
//  Task
//
//  Created by trost.jk on 2022/09/20.
//

import Foundation

class DetailViewModel: RxViewModel, RxViewModelProtocol {
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    struct Dependency {
        let companyName: String
    }
    
    var input: DetailViewModel.Input!
    var output: DetailViewModel.Output!
    var dependency: DetailViewModel.Dependency!
    
    init(dependency: Dependency) {
        super.init()
        
        self.input = DetailViewModel.Input()
        self.output = DetailViewModel.Output()
        
        self.dependency = dependency
        self.bindInputs()
        self.bindOutputs()
    }
    
    func bindInputs() {

    }
    
    func bindOutputs() {
        
    }
}
