//
//  Photos + Extension.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/18.
//

import UIKit
import Photos
import PhotosUI
import CropViewController

extension SettiongViewController: UIImagePickerControllerDelegate, PHPickerViewControllerDelegate, UINavigationControllerDelegate {
    
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

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.settingView.profileimageView.image = image
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
           
            CustomFileManager.shared.saveImageToDocument(fileName: "profile.jpg", image: (self.settingView.profileimageView.image ?? UIImage(systemName: "person"))!)
        }
        
        dismiss(animated: true)
        settingView.profileimageView.image = CustomFileManager.shared.loadImageFromDocument(fileName: profileImage)
    }
    
    func presentAlbum() {
      
        configuration.selectionLimit = 1
        configuration.filter = .any(of: [.images])
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            let itemProvider = results.first?.itemProvider
            if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async { [weak self] in
                        guard let selectedImage = image as? UIImage else { return }// NSItemProviderReading?를 다운캐스팅 시켜줌
                        let cropViewController = CropViewController(croppingStyle: .circular, image: selectedImage)
                        cropViewController.delegate = self
                        cropViewController.doneButtonColor = .systemBlue
                        cropViewController.cancelButtonColor = .systemRed
                        cropViewController.doneButtonTitle = "완료"
                        cropViewController.cancelButtonTitle = "취소"
                        self?.present(cropViewController, animated: true)
                    }
                }
            }
        }
    }

extension SettiongViewController: CropViewControllerDelegate {
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        self.settingView.profileimageView.image = image
        CustomFileManager.shared.saveImageToDocument(fileName: "profile.jpg", image: (self.settingView.profileimageView.image ?? UIImage(systemName: "person"))!)
        settingView.profileimageView.image = CustomFileManager.shared.loadImageFromDocument(fileName: profileImage)
        self.dismiss(animated: true)
       
    }
}

    
    
    
