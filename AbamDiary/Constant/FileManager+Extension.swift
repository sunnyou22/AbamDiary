//
//  FileManager+Extension.swift
//  AbamDiary
//
//  Created by 방선우 on 2022/09/19.
//

import UIKit
import RealmSwift
import Zip

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
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 이걸로 도큐먼트에 저장해줌 세부파일 경로(이미지 저장위치)
        guard let data = image.jpegData(compressionQuality: 0.5) else { return } //용량을 줄이기 위함 용량을 키우는 건 못하고 작아질수밖에 없음
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error🔴", error)
        }
    }
    
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
        print(documentDirectory, "나는야 도큥")
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 이걸로 도큐먼트에 저장해줌 세부파일 경로(이미지 저장위치)
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "person")
        }
        
        let image = UIImage(contentsOfFile: fileURL.path)
        
        return image
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // 내 앱에 해당되는 도큐먼트 폴더가 있늬?
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            view.makeToast("삭제할 이미지가 없습니다", duration: 1.5, position: .center)
            print(error)
        }
    }
    
    func fetchJSONData() throws -> Data {
        guard let path = documentDirectoryPath() else { throw DocumentPathError.fetchBackupFileError }
        
        let jsonDataPath = path.appendingPathComponent("encodedData.json")
        
        do {
            return try Data(contentsOf: jsonDataPath)
        }
        catch {
            throw DocumentPathError.fetchBackupFileError
        }
    }
    
    
    func fetchDocumentZipFile() {
        
        do {
            guard let path = documentDirectoryPath() else { return } //도큐먼트 경로 가져옴
            
            let docs =  try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            print("👉 docs: \(docs)")
            
            let zip = docs.filter { $0.pathExtension == "zip" } //확장자가 모얀
            print("👉 zip: \(zip)")
            
            let result = zip.map { $0.lastPathComponent } //경로 다 보여줄 필요 없으니까 마지막 확장자를 string으로 가져오는 것
            print("👉 result: \(result)") // 오 이렇게 하면 폴더로 만들어서 관리하기도 쉬울듯
            
            
        } catch {
            print("Error🔴")
        }
    }
    
    //파일생성
    func createBackupFile() throws -> URL {
        
        var urlpath = [URL]()
        let fileNameDate = CustomFormatter.setDateFormatter(date: Date())
        //도큐먼트트 위치에 백업 파일 확인
        guard let path = documentDirectoryPath() else {
            throw DocumentPathError.directoryPathError
        }
        
        let encodedFilePath = path.appendingPathComponent("encodedData.json")
        
        guard FileManager.default.fileExists(atPath: encodedFilePath.path) else {
            throw DocumentPathError.compressionFailedError
        }
        
        urlpath.append(contentsOf: [encodedFilePath])
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlpath, fileName: "diary\(fileNameDate)") // 확장자 없으면 저장이 안됨
            print("Archive Lcation: \(zipFilePath.lastPathComponent)")
            return zipFilePath
        } catch {
            throw DocumentPathError.compressionFailedError
        }
    }
    
    //MARK: 다이어리 인코드
    func encodeDiary(_ diaryData: Results<Diary>) throws -> Data {
        
        do {
            let endoder = JSONEncoder()
            endoder.dateEncodingStrategy = .iso8601
            
            let encodedDate: Data = try endoder.encode(diaryData)
            
            return encodedDate
        } catch {
            throw CodableError.jsonEncodeError
        }
    }
    
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
    
    func saveDiaryDataToDocument(data: Data) throws {
        guard let documentPath = documentDirectoryPath() else { throw DocumentPathError.directoryPathError
        }
        
        let jsonDataPath = documentPath.appendingPathComponent("encodedData.json")
        print(jsonDataPath)
        try data.write(to: jsonDataPath)
    }
    
    func saveEncodedDiaryToDocument(tasks: Results<Diary>) throws {
        let encodedData = try encodeDiary(tasks)
        try saveDiaryDataToDocument(data: encodedData)
    }
    
    func showActivityViewController(backupFileURL: URL) throws {
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        
        self.present(vc, animated: true)
    }
    
    func restoreRealmForBackupFile() throws {
        let jsonData = try fetchJSONData()
        guard let decodedData = try decoedDiary(jsonData) else { return }
        try OneDayDiaryRepository.shared.localRealm.write {
            OneDayDiaryRepository.shared.localRealm.add(decodedData)
        }
    }
    
    func restoreData(zipLastPath: String) throws {
        guard let path = documentDirectoryPath() else {
            throw DocumentPathError.fetchBackupFileError
        }
        
        let fileURL = path.appendingPathComponent(zipLastPath)
        try unzipFile(fileURL: fileURL, documentURL: path)
    }
    
    func unzipFile(fileURL: URL, documentURL: URL) throws {
        do {
            try Zip.unzipFile(fileURL, destination: documentURL, overwrite: true, password: nil, progress: { progress in
                print(progress)
            }, fileOutputHandler: { unzippedFile in
                print("복구 완료")
            })
        }
        catch {
            throw DocumentPathError.restoreFailError
        }
    }
}
