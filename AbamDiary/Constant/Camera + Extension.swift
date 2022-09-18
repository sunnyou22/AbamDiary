//
//  Camera + Extension.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/18.
//

import Foundation
import UIKit
import YPImagePicker

extension SettiongViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func clickedSelectProfileButton() {
        
        let picker = YPImagePicker()
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto { //찍고 나서 사진을 고를 때임
                print(photo.fromCamera) // Image source (camera or library)
                print(photo.image) // Final image selected by the user
                print(photo.originalImage) // original image selected by the user, unfiltered
                print(photo.originalImage) // Transformed image, can be nil
                print(photo.exifMeta) // Print exif meta data of original image.
                
                self.settingView.profileimageView.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil) // 맨 먼저 실행시키면 넥스트를 눌러도 안꺼지고 nil나옴 여기 클로저안에 넣어줘야 사진을 고르고 빠져나옴 => 빠져나와야하 이 함수가끝나나봄.
        }
        present(picker, animated: true, completion: nil) // 카메라를 띄움 클로저가 가장 먼저 실행되지만 사진이 없어서 nil이라 사진을 찍을 때 위의 클로저가 한 번 더 실행됨
    }
    
    func cameraButtonClicked() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            print("사용불가 + 사용자에게 토스트 혹은 얼럿")
            return
        }
        
        picker.sourceType = .camera
        picker.allowsEditing = true
        present(picker, animated:  true)
    }
    
    func photoLibraryClicked() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {// 없어질 수 있음
            print("사용불가 + 사용자에게 토스트 혹은 얼럿")
            return
        }
        
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
        }
//    
//    func saveToPhotoLibrary() {
//        if let image = settingView.profileimageView.image {
//            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//            print("저장됨")
//        }
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.settingView.profileimageView.image = image
            dismiss(animated: true)
        }
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
