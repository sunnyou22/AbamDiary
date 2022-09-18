//
//  Photos + Extension.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/18.
//

import UIKit
import Photos
import PhotosUI

extension SettiongViewController: PHPickerViewControllerDelegate {
   
    func setAuthorizationStatus() {
        
        //권한 요청
        let repuiredAccessLevel: PHAccessLevel = .readWrite
        
        PHPhotoLibrary.requestAuthorization(for: repuiredAccessLevel) { authorizationStatus in
            switch authorizationStatus { // map하고 비슷하네
            case .authorized:
                print("권한 허락됨")
            case .limited:
                print("제한된 사진만 허용")
            default:
                // 권한 요청을 거절했을 때 조치
                
                print("거절")
            }
        }
        
        //권한 설정
        let accessLevel: PHAccessLevel = .readWrite
        let authorizationStatus = PHPhotoLibrary.authorizationStatus(for: accessLevel)
        
        switch authorizationStatus {
        case .limited:
            print("제한된 권한")
        default:
            //권한요청을 거절했을 때 조치
            print("거절")
        }
    }
    
    func clickedSelectProfileButton() {
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images, .screenshots])
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.modalPresentationStyle = .fullScreen
        picker
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    self.settingView.profileimageView.image = image as? UIImage
                }
            }
        } else {
            // noimage
        }
    }
}
