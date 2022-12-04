//
//  UIImage+Extention.swift
//  Task
//
//  Created by trost.jk on 2022/09/18.
//

import Foundation
import Kingfisher

extension UIImageView {
    func setImage(
        with urlString: String?,
        placeholder: UIImage? = nil,
        kingfisherOptions: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        completion: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        guard let url = urlString?.percentEncodedUrl else {
            self.image = placeholder
            return
        }
        
        self.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: kingfisherOptions,
            completionHandler: completion
        )
    }
}

extension String {
    var percentEncodedUrl: URL? {
        self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed).flatMap(URL.init(string:))
    }
}
