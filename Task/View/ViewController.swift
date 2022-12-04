//
//  ViewController.swift
//  Task
//
//  Created by trost.jk on 2022/09/15.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: RxViewController<TaskViewModel> {

    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var recruitButton: UIButton!
    @IBOutlet weak var companyButton: UIButton!
    
    @IBOutlet weak var searcingTextField: UITextField!
    //채용 CollectionView
    @IBOutlet weak var recruitCollectionView: UICollectionView!
    //기업 TableView
    @IBOutlet weak var companyTableView: UITableView!
    //검색결과 없음 라벨
    @IBOutlet weak var noResultTitle: UILabel!
    
    //MARK: - View
    private func setButton() {
        if self.viewModel.recruitButtonTapped {
            self.activeRecruitBtn()
        } else {
            self.inActiveRecruitBtn()
        }
        
        if self.viewModel.companyButtonTapped {
            self.activeCompanyBtn()
        } else {
            self.inActiveCompanyBtn()
        }
    }
    
    private func activeRecruitBtn() {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let recruitAtrributedString: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle,
        ]
        let recruitMutableAttributedString = NSMutableAttributedString(string: "채용", attributes: recruitAtrributedString)
        
        self.recruitButton.backgroundColor = UIColor.JPGreen
        self.recruitButton.layer.borderColor = UIColor.clear.cgColor
        self.recruitButton.setAttributedTitle(recruitMutableAttributedString, for: .normal)
        self.recruitButton.layer.cornerRadius = 15
    }
    
    private func inActiveRecruitBtn() {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let recruitAtrributedString: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle,
        ]
        let recruitMutableAttributedString = NSMutableAttributedString(string: "채용", attributes: recruitAtrributedString)
        
        self.recruitButton.backgroundColor = UIColor.white
        self.recruitButton.layer.borderColor = UIColor.Gray03.cgColor
        self.recruitButton.layer.borderWidth = 1
        self.recruitButton.setAttributedTitle(recruitMutableAttributedString, for: .normal)
        self.recruitButton.layer.cornerRadius = 15
    }
    
    private func activeCompanyBtn() {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let companyAtrributedString: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 15),
            .foregroundColor: UIColor.white,
            .paragraphStyle: paragraphStyle,
        ]
        let companyMutableAttributedString = NSMutableAttributedString(string: "기업", attributes: companyAtrributedString)
        
        self.companyButton.backgroundColor = UIColor.JPGreen
        self.companyButton.layer.borderWidth = 1
        self.companyButton.layer.borderColor = UIColor.clear.cgColor
        self.companyButton.setAttributedTitle(companyMutableAttributedString, for: .normal)
        self.companyButton.layer.cornerRadius = 15
    }
    
    private func inActiveCompanyBtn() {
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        let companyAtrributedString: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .foregroundColor: UIColor.black,
            .paragraphStyle: paragraphStyle,
        ]
        let companyMutableAttributedString = NSMutableAttributedString(string: "기업", attributes: companyAtrributedString)
        
        self.companyButton.backgroundColor = UIColor.white
        self.companyButton.layer.borderWidth = 1
        self.companyButton.layer.borderColor = UIColor.Gray03.cgColor
        self.companyButton.setAttributedTitle(companyMutableAttributedString, for: .normal)
        self.companyButton.layer.cornerRadius = 15
    }
    
    fileprivate func cofigureTextField() {
        self.searcingTextField.delegate = self
        self.searcingTextField.keyboardType = .webSearch
        self.searcingTextField.returnKeyType = UIReturnKeyType.search
    }
    
    fileprivate func cofigureCollectionView() {
        self.recruitCollectionView.delegate = self
        self.recruitCollectionView.dataSource = self
        
        let nib = UINib.init(nibName: RecuruitCollectionViewCell.defaultReuseIdentifier, bundle: nil)
        self.recruitCollectionView.register(nib, forCellWithReuseIdentifier: RecuruitCollectionViewCell.defaultReuseIdentifier)
    }
    
    fileprivate func configureTableView() {
        self.companyTableView.delegate = self
        self.companyTableView.dataSource = self
        
        let companyTypeCellNib = UINib.init(nibName: CompanyTypeTableViewCell.defaultReuseIdentifier, bundle: nil)
        self.companyTableView.register(companyTypeCellNib, forCellReuseIdentifier: CompanyTypeTableViewCell.defaultReuseIdentifier)
        
        self.companyTableView.rowHeight = UITableView.automaticDimension
        self.companyTableView.estimatedRowHeight = 250
        
        self.companyTableView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        self.setViewModel()
        
        self.cofigureTextField()
        self.cofigureCollectionView()
        self.configureTableView()
        self.setButton()
        self.noResultTitle.isHidden = true
        
        self.bindInput()
        self.bindOutput()
        
        //초기데이터
        self.viewModel.requestRecruitItemsRelay.accept(())
        self.viewModel.requestCellItemsRelay.accept(())
    }

    private func setViewModel() {
        let viewModel = TaskViewModel(
            dependency: TaskViewModel.Dependency(
                taskInteractor: TaskInteractor(
                    taskRepository: TaskRepository()
                )
            )
        )
        
        self.viewModel = viewModel
    }
    
    //MARK: - Binder
    func bindInput() {
        self.recruitButton.rx.throttleTap
            .withUnretained(self)
            .subscribe { (self, _) in
                //채용 버튼 클릭 상태변경
                self.viewModel.recruitButtonTapped = !self.viewModel.recruitButtonTapped
                
                //채용 버튼이 활성화 상태라면
                if self.viewModel.recruitButtonTapped {
                    //회사 버튼 비활성
                    self.viewModel.companyButtonTapped = false
                    //채용 콜렉션뷰 갱신
                    self.companyTableView.isHidden = true
                    self.recruitCollectionView.isHidden = false
                }
                //상태에 맞게 버튼 UI 변경
                self.setButton()
            }.disposed(by: self.disposeBag)

        self.companyButton.rx.throttleTap
            .withUnretained(self)
            .subscribe { (self, _) in
                //회사 버튼 클릭 상태변경
                self.viewModel.companyButtonTapped = !self.viewModel.companyButtonTapped
                
                //회사 버튼이 활성화 상태라면
                if self.viewModel.companyButtonTapped {
                    //채용 버튼 비활성
                    self.viewModel.recruitButtonTapped = false
                    //회사 테이블뷰 갱신
                    self.recruitCollectionView.isHidden = true
                    self.companyTableView.isHidden = false
                }
                //상태에 맞게 버튼 UI 변경
                self.setButton()
            }.disposed(by: self.disposeBag)

    }
    
    var recruitItems = [RecruitItem]()
    var cellItems = [CellItem]()
    
    func bindOutput() {
        self.viewModel.output
            .responseRecruitItems
            .withUnretained(self)
            .emit { (self, recruitItems) in
                
                self.recruitItems = recruitItems
                
                if self.recruitItems.count > 0 {
                    self.noResultTitle.isHidden = true
                    
                    self.recruitCollectionView.isHidden = false
                    self.recruitCollectionView.reloadData()
                } else {
                    self.recruitCollectionView.isHidden = true
                    self.noResultTitle.isHidden = false
                }

            }.disposed(by: self.disposeBag)
        
        self.viewModel.output
            .responseCellItems
            .withUnretained(self)
            .emit { (self, cellItems) in
                
                self.cellItems = cellItems

                if self.cellItems.count > 0 {
                    self.noResultTitle.isHidden = true
                    
                    self.companyTableView.isHidden = false
                    self.companyTableView.reloadData()
                } else {
                    self.companyTableView.isHidden = true
                    self.noResultTitle.isHidden = false
                }
                
            }.disposed(by: self.disposeBag)
        
    }
}

//MARK: - TextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            self.viewModel.searchingCompanyRelay.accept(text)
        }
        
        self.dismissKeyboard()
        
        return true
    }
    
}


//MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.recruitItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recruitCollectionView.dequeueReusableCell(
            withReuseIdentifier: RecuruitCollectionViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as! RecuruitCollectionViewCell
        
        cell.render(recruitItem: self.recruitItems[indexPath.row],
                    bookMarkRelay: self.viewModel.recruitBookmarkRelay,
                    isNeedBookmark: true
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recruitItem = self.recruitItems[indexPath.row]
        
        let instance = DetailViewController.newInstance(companyName: recruitItem.title)
        
        self.navigationController?.pushViewController(instance, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let minimumInteritemSpacing = CGFloat(15)
        let minimumLineSpacing = CGFloat(20)

        let cellWidth = (width - minimumInteritemSpacing - (minimumLineSpacing * 2)) / 2
        
        return CGSize(width: cellWidth, height: 226)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.viewModel.cellItems[indexPath.row].cellType == CellType.cellTypeHorizontalTheme {
            return 300
        } else {
            return UITableView.automaticDimension
        }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = companyTableView.dequeueReusableCell(
            withIdentifier: CompanyTypeTableViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as! CompanyTypeTableViewCell
        
        cell.render(cellItem: self.viewModel.cellItems[indexPath.row],
                    navigationController: self.navigationController)
        
        cell.layoutIfNeeded()
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recruitItem = self.recruitItems[indexPath.row]
        
        let instance = DetailViewController.newInstance(companyName: recruitItem.title)
        
        self.navigationController?.pushViewController(instance, animated: true)
    }
}
