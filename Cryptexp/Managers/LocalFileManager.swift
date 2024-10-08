import Foundation
import SwiftUI

final class LocalFileManager {
    
    static let shared = LocalFileManager()
    
    private init() {}
    
    //MARK: - Methods
    //MARK: Save
    func saveImage(image: UIImage, imageName: String, folderName: String) {
        // create folder
        createFolderIfNeeded(folderName: folderName)
        
        // get path
        guard let data = image.pngData(),
              let url = getURLForImage(imageName: imageName, folderName: folderName)
        else { return }
        
        // save for path
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image... imageName: \(imageName).  \(error)")
        }
    }
    
    //MARK: Get
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard let url = getURLForImage(imageName: imageName, folderName: folderName),
              FileManager.default.fileExists(atPath: url.path)
        else {
            return nil
        }
        
        return UIImage(contentsOfFile: url.path)
    }
}

//MARK: - Extensions
extension LocalFileManager {
    //MARK: Create Folder If Needed
    func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error to create directory FolderName: \(folderName). \(error)")
            }
        }
    }
    
    
    //MARK: Get URLs
    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil
        }
        return url.appendingPathComponent(folderName)
    }
    
    private func getURLForImage(imageName: String, folderName: String) -> URL? {
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}

