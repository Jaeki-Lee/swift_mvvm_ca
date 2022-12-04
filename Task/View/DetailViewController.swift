//
//  DetailViewController.swift
//  Task
//
//  Created by trost.jk on 2022/09/20.
//

import UIKit
import SnapKit
import Then

class DetailViewController: RxViewController<DetailViewModel> {
    
    static func newInstance(companyName: String) -> DetailViewController {
        let instance = DetailViewController()
        let viewModel = DetailViewModel(
            dependency: DetailViewModel.Dependency(
                companyName: companyName
            )
        )
        
        instance.viewModel = viewModel
        
        return instance
    }

    let companyNameLabel = UILabel().then {
        $0.text = "회사 이름"
        $0.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.companyNameLabel.text = self.viewModel.dependency.companyName
        
        self.view.addSubview(companyNameLabel)
        self.companyNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }
}
