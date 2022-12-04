//
//  RxSwift+Extention.swift
//  Task
//
//  Created by trost.jk on 2022/09/17.
//

import RxSwift
import RxCocoa

extension Reactive where Base: UIButton {
    
    public var throttleTap: Observable<ControlEvent<()>.Element> {
        return self.controlEvent(.touchUpInside)
            .throttle(.milliseconds(200), latest: false, scheduler: MainScheduler.instance)
    }
}

