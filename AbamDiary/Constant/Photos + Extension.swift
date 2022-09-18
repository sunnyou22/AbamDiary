//
//  Photos + Extension.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/18.
//

import UIKit
import Photos
import PhotosUI

extension SettiongViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
    
    func presentCamara() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        vc.cameraFlashMode = .off
        
        present(vc, animated: true, completion: nil)
    }
    
    func presentAlbum() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary // 사라질 예정 그럼 크롭은...?
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.settingView.profileimageView.image = image
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {

            saveImageToDocument(fileName: "profile.jpg", image: (self.settingView.profileimageView.image ?? UIImage(systemName: "person"))!)
           
        } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            saveImageToDocument(fileName: "profile.jpg", image: (self.settingView.profileimageView.image ?? UIImage(systemName: "person"))!)
        }
        
        dismiss(animated: true)
        settingView.profileimageView.image = loadImageFromDocument(fileName: "profile.jpg")
    }

}
