//
//  Utils.swift
//  NewsApi
//
//  Created by Oleksandr Karpenko on 20.11.2020.
//

import UIKit
import Alamofire

extension UIImageView {
    
    func imageFromUrl(_ string: String) {
        guard let token = AppConfig.shared.accessToken else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let url = URL(string: string) {
                AF.request(url, headers: ["Authorization": "Bearer \(token)"]).response { (response) in
                    
                    switch response.result {
                    case .success(let data):
                        if let data = data, data.count > 20 {
                            self?.image = UIImage(data: data)
                        }
                    case .failure(let error):
                        print("error--->",error)
                    }
                }
            }
        }
    }
}
