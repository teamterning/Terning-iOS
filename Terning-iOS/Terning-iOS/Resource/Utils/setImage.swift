//
//  setImage.swift
//  Terning-iOS
//
//  Created by 이명진 on 7/8/24.
//

import UIKit
import SwiftUI
import Kingfisher

public extension UIImageView {
    func setImage(with urlString: String, placeholder: String? = nil, completion: ((UIImage?) -> Void)? = nil) {
        let cache = ImageCache.default
        if urlString.isEmpty {
            // URL 빈 이미지로 넘겨 받았을 경우, 아래에 UIImage에 기본 사진을 추가 하면 된다.
            self.image = UIImage(named: "defaultImage")
        } else {
            cache.retrieveImage(forKey: urlString) { result in
                result.success { imageCache in
                    if let image = imageCache.image {
                        self.image = image
                        completion?(image)
                    } else {
                        self.setNewImage(with: urlString, placeholder: placeholder, completion: completion)
                    }
                }.catch { _ in
                    self.setNewImage(with: urlString, placeholder: placeholder, completion: completion)
                }
            }
        }
    }
    
    private func setNewImage(with urlString: String, placeholder: String? = "img_placeholder", completion: ((UIImage?) -> Void)? = nil) {
        guard let url = URL(string: urlString) else { return }
        let resource = Kingfisher.KF.ImageResource(downloadURL: url, cacheKey: urlString)
        let placeholderImage = UIImage(named: placeholder ?? "img_placeholder")
        
        self.kf.setImage(
            with: resource,
            placeholder: placeholderImage,
            options: [
                .scaleFactor(UIScreen.main.scale/4),
                .transition(.fade(0.5)),
                .cacheMemoryOnly
            ],
            completionHandler: { result in
                result.success { imageResult in
                    completion?(imageResult.image)
                }
            }
        )
    }
}

struct RemoteImageView: View {
    let urlString: String
    
    var body: some View {
        KFImage(URL(string: urlString))
            .placeholder {
                Image("img_placeholder") // 로드 중에 표시할 placeholder
                    .resizable()
                    .scaledToFit()
            }
            .resizable()
            .fade(duration: 0.5)
            .loadDiskFileSynchronously()
            .cacheMemoryOnly()
            .scaledToFit()
    }
}
