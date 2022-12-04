//
//  TaskViewModel.swift
//  Task
//
//  Created by trost.jk on 2022/09/17.
//

import Foundation
import RxSwift
import RxCocoa

class TaskViewModel: RxViewModel, RxViewModelProtocol {
    
    //자음 검색으로 위한 배열
    let hangul = ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
    
    struct Input {
        let requestRecruitItems: PublishRelay<Void>
        let requestCellItems: PublishRelay<Void>
        let searchingCompany: PublishRelay<String>
        let recruitBookmark: PublishRelay<Int>
    }
    
    struct Output {
        var responseRecruitItems: Signal<[RecruitItem]>
        var responseCellItems: Signal<[CellItem]>
    }
    
    struct Dependency {
        let taskInteractor: TaskInteractorProtocol
    }
    
    var input: TaskViewModel.Input!
    var output: TaskViewModel.Output!
    var dependency: TaskViewModel.Dependency!
    
    var recruitButtonTapped = true
    var companyButtonTapped = false
    
    var recruitItems = [RecruitItem]()
    var cellItems = [CellItem]()
    
    //inputRelay
    var requestRecruitItemsRelay = PublishRelay<Void>()
    var requestCellItemsRelay = PublishRelay<Void>()
    var searchingCompanyRelay = PublishRelay<String>()
    var recruitBookmarkRelay = PublishRelay<Int>()
    
    //outputRelay
    var responseRecruitItemsRelay = PublishRelay<[RecruitItem]>()
    var responseCellItemsRelay = PublishRelay<[CellItem]>()
    
    init(dependency: Dependency) {
        super.init()
        
        self.dependency = dependency
        self.input = TaskViewModel.Input(
            requestRecruitItems: self.requestRecruitItemsRelay,
            requestCellItems: self.requestCellItemsRelay,
            searchingCompany: self.searchingCompanyRelay,
            recruitBookmark: self.recruitBookmarkRelay
        )
        self.output = TaskViewModel.Output(
            responseRecruitItems: self.responseRecruitItemsRelay.asSignal(),
            responseCellItems: self.responseCellItemsRelay.asSignal()
        )
        
        self.bindInputs()
        self.bindOutputs()
    }
    
    private func bindInputs() {
        self.requestRecruitItemsRelay
            .flatMap {
                self.dependency.taskInteractor.getRecruitItems()
            }
            .withUnretained(self)
            .subscribe { (self, result) in
                
                self.recruitItems = result.recruitItems
                
                self.responseRecruitItemsRelay.accept(self.recruitItems)
                
            }.disposed(by: self.disposeBag)
        
        self.requestCellItemsRelay
            .flatMap {
                self.dependency.taskInteractor.getCellItems()
            }
            .withUnretained(self)
            .subscribe { (self, result) in
                
                self.cellItems = result.cellItems
                
                self.responseCellItemsRelay.accept(self.cellItems)

            }.disposed(by: self.disposeBag)
        
        self.searchingCompanyRelay
            .withUnretained(self)
            .subscribe { (self, name) in

                if self.recruitButtonTapped {
                    //검색어가 없으면 리스트 전체 표시
                    if name == "" {
                        self.responseRecruitItemsRelay.accept(self.recruitItems)
                    } else {
                        //검색어가 있으면 검색 기업 매칭(없으면 검색 결과 없음 화면 표시)
                        self.searchAndSetRecruitItems(name: name)
                    }
                } else {
                    if name == "" {
                        self.responseCellItemsRelay.accept(self.cellItems)
                    } else {
                        //검색어가 있으면 검색 기업 매칭(없으면 검색 결과 없음 화면 표시)
                        self.searchAndSetCellItems(name: name)
                    }
                }
            }.disposed(by: self.disposeBag)
        
        self.recruitBookmarkRelay
            .withUnretained(self)
            .subscribe { (self, id) in
                if var selectedItem = self.recruitItems.first{ $0.id == id  },
                   let selectedItemIndex = self.recruitItems.firstIndex(of: selectedItem)
                {

                    self.recruitItems[selectedItemIndex].isBookmark = !self.recruitItems[selectedItemIndex].isBookmark
                    
                    self.responseRecruitItemsRelay.accept(self.recruitItems)
                }
            }.disposed(by: self.disposeBag)

    }
    
    private func bindOutputs() {
        
    }
    
    private func searchAndSetRecruitItems(name: String) {
        self.responseRecruitItemsRelay.accept(
            self.recruitItems.filter {
                // 초성인경우
                if self.isChosung(word: name) {
                    return ($0.title.contains(name) || self.chosungCheck(word: $0.title).contains(name))
                }
                // 디폴트 동일문자열 검색
                else {
                    return $0.title.contains(name)
                }
            }
        )
    }
    
    private func searchAndSetCellItems(name: String) {
        self.responseCellItemsRelay.accept(
            self.cellItems.filter {
                if $0.cellType != CellType.cellTypeHorizontalTheme {
                    // 초성인경우
                    if self.isChosung(word: name) {
                        return ($0.name!.contains(name) || self.chosungCheck(word: $0.name!).contains(name))
                    }
                    // 디폴트 동일문자열 검색
                    else {
                        return $0.name!.contains(name)
                    }
                } else {
                    return false
                }
            }
        )
    }
}

extension TaskViewModel {

    func chosungCheck(word: String) -> String {
        var result = ""

        // 문자열하나씩 짤라서 확인
        for char in word {
            let octal = char.unicodeScalars[char.unicodeScalars.startIndex].value
            if 44032...55203 ~= octal { // 유니코드가 한글값 일때만 분리작업
                let index = (octal - 0xac00) / 28 / 21
                result = result + hangul[Int(index)]
            }
        }
        
        return result
    }
    
    func isChosung(word: String) -> Bool {
        
        var isChosung = false
        for char in word {
            
            if 0 < hangul.filter({ $0.contains(char)}).count {
                isChosung = true
            } else {
                isChosung = false
                break
            }
        }
        return isChosung
    }

}
