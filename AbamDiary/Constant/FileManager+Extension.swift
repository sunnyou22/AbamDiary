//
//  FileManager+Extension.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/19.
//

import UIKit
import RealmSwift
import Zip

enum PathComponentName: String {
    case imageFile = "profile.jpg"
    case ABAMKeyFile
    case defaultImage
}

enum CodableError: Error {
    case jsonEncodeError
    case jsonDecodeError
}


enum DocumentPathError: Error {
    case directoryPathError
    case saveImageError
    case removeDirectoryError
    case compressionFailedError
    case fetchBackupFileError
    case restoreFailError
}

extension UIViewController {
    
    func documentDirectoryPath() -> URL? {
        
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
        
        return documentDirectory
    }
    
    func saveImageToDocument(fileName: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error🔴", error)
        }
    }
    
    func createFile(fileName: PathComponentName) -> URL {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("폴더를 생성할 수 없습니다")
            return URL(fileURLWithPath: "") }
        let fileURL = path.appendingPathComponent(fileName.rawValue)
        let myTextString = NSString(string: fileName.rawValue)
    
        do { //try문이기 땜눈에 do
            try myTextString.write(to: fileURL, atomically: true, encoding: String.Encoding.utf8.rawValue)
        } catch {
            print("=====> 이미지 폴더를 만들 수 없습니다")
        }
        
        return fileURL
    }
    
//    func saveImageToFolder(foldername: PathComponentName, filename: String, image: UIImage) {
//
//        guard let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//        let folderURL = documentsFolder.appendingPathComponent(foldername.rawValue)
//        let folderExists = (try? folderURL.checkResourceIsReachable()) ?? false // 폴더에 도달 가능?
//
//        do { //try문이기 땜눈에 do
//            if !folderExists { // 도달가능해
//                // 그럼 그 url에 해당하는 폴더 만들어
//                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: false)
//            }
//            let fileURL = folderURL.appendingPathComponent(filename) // 파일 경로 생성 및 저장
//            guard let data = image.jpegData(compressionQuality: 0.8) else { return }
//
//            do {
//                try data.write(to: fileURL)
//            } catch {
//                print(error, "====> 해당 이미지를 URL로 수정할 수 없습니다.")
//            }
//    }
    
//    func loadImageFromFolder(fileName: String, folderName: PathComponentName) -> UIImage? {
//        guard let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
//        let folderURL = documentsFolder.appendingPathComponent(folderName.rawValue)
//        let fileURL = folderURL.appendingPathComponent(fileName)
//
//        if FileManager.default.fileExists(atPath: fileURL.path) {
//            return UIImage(contentsOfFile: fileURL.path)
//
//        } else {
//            return UIImage(named: "ABAM")
//        }
//    }
    
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 이걸로 도큐먼트에 저장해줌 세부파일 경로(이미지 저장위치)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(named: "ABAM")
        }
        
        let image = UIImage(contentsOfFile: fileURL.path)
        
        return image
    }
    
//    func removeImageFromFolderDocument(fileName: String) {
//        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
//        let fileURL = documentDirectory.appendingPathComponent(fileName)
//
//        do {
//            try FileManager.default.removeItem(at: fileURL)
//        } catch let error {
//            view.makeToast("삭제할 이미지가 없습니다", duration: 1.5, position: .center)
//            print(error)
//        }
//    }
   
    func removeKeyFileDocument(fileName: PathComponentName) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
        let fileURL = documentDirectory.appendingPathComponent(fileName.rawValue)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            view.makeToast("삭제할 키파일이 없습니다", duration: 1.5, position: .center)
            print(error)
        }
    }
    
    func removeBackupFileDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
       
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            view.makeToast("삭제할 백업파일이 없습니다", duration: 1.5, position: .center)
            print(error)
        }
    }
    
// //제이슨 파일 다시 데이터로 만들기
    func DfetchJSONData() throws -> Data {
        guard let path = documentDirectoryPath() else { throw DocumentPathError.fetchBackupFileError }
       
        let DjsonDataPath = path.appendingPathComponent("diary.json")
        
        do {
            return try Data(contentsOf: DjsonDataPath)
        }
        catch {
            throw DocumentPathError.fetchBackupFileError
        }
    }
    
    //제이슨 파일 다시 데이터로 만들기
    func CfetchJSONData() throws -> Data {
        guard let path = documentDirectoryPath() else { throw DocumentPathError.fetchBackupFileError }
       
        let CjsonDataPath = path.appendingPathComponent("cheerup.json")
        
        do {
            return try Data(contentsOf: CjsonDataPath)
        }
        catch {
            throw DocumentPathError.fetchBackupFileError
        }
    }
    
    func fetchDocumentZipFile() -> [String] {
        
        do {
            guard let path = documentDirectoryPath() else { return [] } //도큐먼트 경로 가져옴
            
            let docs =  try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            print("👉 docs: \(docs)")
            
            let zip = docs.filter { $0.pathExtension == "zip" } //확장자가 모얀
            print("👉 zip: \(zip)")
            
            let result = zip.map { $0.lastPathComponent } //경로 다 보여줄 필요 없으니까 마지막 확장자를 string으로 가져오는 것
            print("👉 result: \(result)") // 오 이렇게 하면 폴더로 만들어서 관리하기도 쉬울듯
            
            return result
            
        } catch {
            print("Error🔴")
            return []
        }
    }
    
    //파일생성
    func createBackupFile(fileName: String, keyFile: PathComponentName, imageFile: PathComponentName) throws -> URL {
        
        var urlpath = [URL]()
        //도큐먼트트 위치에 백업 파일 확인
        guard let path = documentDirectoryPath() else {
            throw DocumentPathError.directoryPathError
        }
        
        let keyFileURL = createFile(fileName: keyFile)
        let imageFileURL = path.appendingPathComponent(imageFile.rawValue)
        let DencodedFilePath = path.appendingPathComponent("diary.json")
        let CencodedFilePath = path.appendingPathComponent("cheerup.json")
        
        print(imageFileURL)
        
        guard FileManager.default.fileExists(atPath: DencodedFilePath.path) && FileManager.default.fileExists(atPath: CencodedFilePath.path), FileManager.default.fileExists(atPath: keyFileURL.path) else {
            throw DocumentPathError.compressionFailedError
        }
        
        if FileManager.default.fileExists(atPath: imageFileURL.path) {
            urlpath.append(contentsOf: [DencodedFilePath, CencodedFilePath, keyFileURL, imageFileURL])
        } else {
            urlpath.append(contentsOf: [DencodedFilePath, CencodedFilePath, keyFileURL])
        }
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlpath, fileName: "\(fileName)") // 확장자 없으면 저장이 안됨
            print("Archive Lcation: \(zipFilePath.lastPathComponent)")
            return zipFilePath
        } catch {
            throw DocumentPathError.compressionFailedError
        }
    }
    
    //MARK: 다이어리 인코드
    func encodeDiary(_ diaryData: Results<Diary>) throws -> Data {
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encodedData: Data = try encoder.encode(diaryData)

            return encodedData
        } catch {
            throw CodableError.jsonEncodeError
        }
    }
    
    //MARK: 응원메세지 인코드
    func encodeCheerup(_ data: Results<CheerupMessage>) throws -> Data {
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let encodedData: Data = try encoder.encode(data)
            
            return encodedData
        } catch {
            throw CodableError.jsonEncodeError
        }
    }
    
    //다이어리 디코드
    @discardableResult
    func decoedDiary(_ diaryData: Data) throws -> [Diary]? {
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decodedData: [Diary] = try decoder.decode([Diary].self, from: diaryData)
            
            return decodedData
        } catch {
            throw CodableError.jsonDecodeError
        }
    }
  
    // 응원메세지 디코드
    @discardableResult
    func decoedCheerup(_ data: Data) throws -> [CheerupMessage]? {
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let decodedData: [CheerupMessage] =
            try decoder.decode([CheerupMessage].self, from: data)
            
            return decodedData
        } catch {
            throw CodableError.jsonDecodeError
        }
    }
    
    //도큐먼트에 저장
    func saveDataToDocument(data: Data, fileName: String) throws {
        guard let documentPath = documentDirectoryPath() else { throw DocumentPathError.directoryPathError
        }
        
        let jsonDataPath = documentPath.appendingPathComponent("\(fileName).json")
        try data.write(to: jsonDataPath)
    }
    
    //도큐먼트에 다이어리 인코드한거 저장하기 위해 준비 - 1
    func saveEncodedDiaryToDocument(tasks: Results<Diary>) throws {
        let encodedData = try encodeDiary(tasks)
        try saveDataToDocument(data: encodedData, fileName: "diary")
    }
    
    //도큐먼트에 응원메세지 인코드한거 저장하기 위해 준비 - 2
    func saveEncodeCheerupToDocument(tasks: Results<CheerupMessage>) throws {
        let encodedData = try encodeCheerup(tasks)
        try saveDataToDocument(data: encodedData, fileName: "cheerup")
    }
    
    //백업파일 복구하기
    func restoreRealmForBackupFile() throws {
        let DjsonData = try DfetchJSONData()
        let CjsonData = try CfetchJSONData()
        guard let DdecodedData = try decoedDiary(DjsonData) else { return }
        guard let CdecodedData = try decoedCheerup(CjsonData) else { return }
        
        try OneDayDiaryRepository.shared.localRealm.write {
            OneDayDiaryRepository.shared.localRealm.add(DdecodedData)
        }
        try CheerupMessageRepository.shared.localRealm.write({
            CheerupMessageRepository.shared.localRealm.add(CdecodedData)
        })
    }
   
    //도큐먼트 피커보여주기
    func showActivityViewController(backupFileURL: URL) throws {
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        self.present(vc, animated: true)
    }
    
    
    //언집하기
    func unzipFile(fileURL: URL, documentURL: URL) throws {
        do {
            try Zip.unzipFile(fileURL, destination: documentURL, overwrite: true, password: nil, progress: { progress in
            }, fileOutputHandler: { unzippedFile in
                print("압축풀기 완료")
            })
        }
        catch {
            throw DocumentPathError.restoreFailError
        }
    }
}
