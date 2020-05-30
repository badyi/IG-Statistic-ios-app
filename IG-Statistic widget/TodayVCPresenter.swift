//
//  TodayVCPresenter.swift
//  IG-Statistic widget
//
//  Created by и on 28.05.2020.
//  Copyright © 2020 Бадый Шагаалан. All rights reserved.
//

import UIKit

protocol TodayVCPdelegate: AnyObject {
    func reloadAt(index: Int)
}

final class TodayVCPresenter {
    var model: infoModel!
    let credentials: Credentials
    let service: Service
    weak var delegate: TodayVCPdelegate?
    
    init(_ credentials: Credentials, _ delegate: TodayVCPdelegate) {
        self.credentials = credentials
        self.delegate = delegate
        service = Service()
        model = infoModel(self)
    }

    func getMainProfileInfo() {
        service.getMainProfileInfo(credentials) { result in //[weak self] result in
            switch result {
            case let .success(profileMainInfo):
                self.model.profile = profileMainInfo
            case let .failure(error):
                print(error)
            }
        }
     }
    
    func getProfileImage() {
        guard let imageUrl = model.getImgURL() else {
            return
        }
        if model.image != nil { return }
        service.getImage(imageUrl) { result in
            switch result {
            case let .success(image):
                self.model.image = image
            case let .failure(error):
                print(error)
            }
        }
    }
    
    func getImage() -> UIImage? {
        return model.image
    }
}

extension TodayVCPresenter: infoModelDelegate {
    func loadImage() {
        getProfileImage()
    }
    
    func reloadAt(index: Int) {
        DispatchQueue.main.async { 
            self.delegate?.reloadAt(index: index)
        }
    }
}
