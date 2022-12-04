//
//  CompanyTypeTableViewCell.swift
//  Task
//
//  Created by trost.jk on 2022/09/18.
//

import UIKit

class CompanyTypeTableViewCell: UITableViewCell {
    
    //company and review type 셀 공통 UI
    @IBOutlet weak var companyAndReviewCommonView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var updateDateLabel: UILabel!
    @IBOutlet weak var reviewSummaryLabel: UILabel!
    //company type UI
    @IBOutlet weak var companyTypeView: UIView!
    @IBOutlet weak var salaryLabel: UILabel!
    @IBOutlet weak var interviewQuestionLabel: UILabel!
    //review type UI
    @IBOutlet weak var reviewTypeView: UIView!
    @IBOutlet weak var prosPointLabel: UILabel!
    @IBOutlet weak var consPointLabel: UILabel!
    //cellTypeHorizontalTheme type 셀
    @IBOutlet weak var hotCompaniesLabel: UILabel!
    @IBOutlet weak var hotCompaniesCollectionView: UICollectionView!
    
    static let defaultReuseIdentifier = "CompanyTypeTableViewCell"
    
    var recommendRecruits = [RecruitItem]()
    
    var navigationController: UINavigationController?
    
    private func cofigureCollectionView() {
        let nib = UINib.init(nibName: RecuruitCollectionViewCell.defaultReuseIdentifier, bundle: nil)
        self.hotCompaniesCollectionView.register(nib, forCellWithReuseIdentifier: RecuruitCollectionViewCell.defaultReuseIdentifier)

        self.hotCompaniesCollectionView.delegate = self
        self.hotCompaniesCollectionView.dataSource = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.cofigureCollectionView()
    }
    
    func render(cellItem: CellItem, navigationController: UINavigationController?) {
        self.navigationController = navigationController
        
        switch cellItem.cellType {
        case .cellTypeCompany:
            self.setCompanyTypeView(cellItem: cellItem)
        case .cellTypeReview:
            self.setReviewTypeView(cellItem: cellItem)
        case .cellTypeHorizontalTheme:
            self.setTypeHorizontalThemeView(cellItem: cellItem)
        }
    }
    
    private func setReviewTypeView(cellItem: CellItem) {
        guard let logoImagePath = cellItem.logoPath,
              let rate = cellItem.rateTotalAvg,
              let companyName = cellItem.name,
              let industryName = cellItem.industryName,
              let updateDate = cellItem.updateDate,
              let reviewSummary = cellItem.reviewSummary else { return }
        
        //image
        self.logoImageView.layer.cornerRadius = 4
        self.logoImageView.layer.borderColor = UIColor.Gray03.cgColor
        self.logoImageView.layer.borderWidth = 1
        
        self.logoImageView.tintColor = .lightGray.withAlphaComponent(0.5)
        self.logoImageView.setImage(
            with: logoImagePath,
            placeholder: UIImage(systemName: "circle.dashed")) { [weak self] result in
                guard let image = try? result.get().image else { return }
                self?.logoImageView.image = image
            }
        
        self.companyNameLabel.text = companyName
        
        self.industryLabel.text = industryName
        
        let updatedDate = updateDate.components(separatedBy: "T")
        var convertedUpdateDate = updatedDate[0]
        convertedUpdateDate = convertedUpdateDate.replacingOccurrences(of: "-", with: ".")
        self.updateDateLabel.text = convertedUpdateDate
        
        self.reviewSummaryLabel.text = reviewSummary
        
        //view 숨김처리
        self.companyTypeView.isHidden = true
        self.hotCompaniesLabel.isHidden = true
        self.hotCompaniesCollectionView.isHidden = true
        
        self.companyAndReviewCommonView.isHidden = false
        self.reviewTypeView.isHidden = false
        
        if let prosPoint = cellItem.pros,
           let consPoint = cellItem.cons
        {
            self.prosPointLabel.text = prosPoint
            self.consPointLabel.text = consPoint
        }
    }
    
    private func setCompanyTypeView(cellItem: CellItem) {
        guard let logoImagePath = cellItem.logoPath,
              let rate = cellItem.rateTotalAvg,
              let companyName = cellItem.name,
              let industryName = cellItem.industryName,
              let updateDate = cellItem.updateDate,
              let reviewSummary = cellItem.reviewSummary else { return }
        
        //image
        self.logoImageView.layer.cornerRadius = 4
        self.logoImageView.layer.borderColor = UIColor.Gray03.cgColor
        self.logoImageView.layer.borderWidth = 1
        
        self.logoImageView.tintColor = .lightGray.withAlphaComponent(0.5)
        self.logoImageView.setImage(
            with: logoImagePath,
            placeholder: UIImage(systemName: "circle.dashed")) { [weak self] result in
                guard let image = try? result.get().image else { return }
                self?.logoImageView.image = image
            }
        
        self.companyNameLabel.text = companyName
        
        self.industryLabel.text = industryName
        
        let updatedDate = updateDate.components(separatedBy: "T")
        var convertedUpdateDate = updatedDate[0]
        convertedUpdateDate = convertedUpdateDate.replacingOccurrences(of: "-", with: ".")
        self.updateDateLabel.text = convertedUpdateDate
        
        self.reviewSummaryLabel.text = reviewSummary
        
        //view 숨김처리
        self.reviewTypeView.isHidden = true
        self.hotCompaniesLabel.isHidden = true
        self.hotCompaniesCollectionView.isHidden = true
        
        self.companyAndReviewCommonView.isHidden = false
        self.companyTypeView.isHidden = false
        
        if let salaryAvg = cellItem.salaryAvg,
           let interviewQuestion = cellItem.interviewQuestion
        {
            var salary = ""
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let rewordNumberString = numberFormatter.string(from: NSNumber(value: salaryAvg)) {
                salary = rewordNumberString
            }
            
            self.salaryLabel.text = "\(salary)"
            self.interviewQuestionLabel.text = interviewQuestion
        }
        
    }
    
    private func setTypeHorizontalThemeView(cellItem: CellItem) {
        if let recruitItems = cellItem.recommendRecruit {
            self.recommendRecruits = recruitItems
        }
        
        self.companyAndReviewCommonView.isHidden = true
        self.reviewTypeView.isHidden = true
        self.companyTypeView.isHidden = true
        
        self.hotCompaniesLabel.isHidden = false
        self.hotCompaniesCollectionView.isHidden = false
        
        self.hotCompaniesCollectionView.reloadData()
    }
    
}

extension CompanyTypeTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendRecruits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = self.hotCompaniesCollectionView.dequeueReusableCell(
            withReuseIdentifier: RecuruitCollectionViewCell.defaultReuseIdentifier,
            for: indexPath
        ) as! RecuruitCollectionViewCell

        cell.render(recruitItem: recommendRecruits[indexPath.row], bookMarkRelay: nil, isNeedBookmark: false)

        return cell
    }
}

extension CompanyTypeTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: 160, height: 228)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    }
}

extension CompanyTypeTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recruitItem = self.recommendRecruits[indexPath.row]
        
        let instance = DetailViewController.newInstance(companyName: recruitItem.title)
        
        self.navigationController?.pushViewController(instance, animated: true)
    }
}
