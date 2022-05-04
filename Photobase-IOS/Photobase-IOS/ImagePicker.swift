//
//  ImagePicker.swift
//  Photobase-IOS
//
//  Created by Micah Perez on 3/16/22.
//

import Foundation
import SwiftUI

class ImagePickerCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    @Binding var iname: String
    @Binding var domainOnline: Bool
    
    
    init(image: Binding<UIImage?>, isShown: Binding<Bool>, iname: Binding<String>, domainOnline: Binding<Bool>) {
        _image = image
        _isShown = isShown
        _iname = iname
        _domainOnline = domainOnline
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let uiImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = uiImage
            isShown = false
        }
        if (domainOnline == true) {
            uploadImage(urlName: "https://" + iname + ".loca.lt/post-test", image: image!)
        }
        else {
            saveImage(image: image!)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
    
    //func uploadImage(urlName: String, paramName: String, fileName: String, image: UIImage) {
    func uploadImage(urlName: String, image: UIImage) {
        let url = URL(string: urlName)

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        print(urlName)

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        
        // Add the image data to the raw http request data
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd:HH:mm:ss"
        let currentDate = NSDate.now
        let stringDate = formatter.string(from: currentDate)
        
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=photodata; filename=photodata".data(using: .utf8)!)
        data.append("Content-Type: image/\(stringDate)\r\n\r\n".data(using: .utf8)!)
        data.append(image.jpegData(compressionQuality: 0.1)!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print(json)
                }
            }
        }).resume()
    }

    //Save an image to internal phone directory (if not connected to the server)
    func saveImage(image: UIImage) {
        guard
            let data = image.jpegData(compressionQuality: 1.0) else {
                print("Error getting data.")
                return
            }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd:HH:mm:ss"
        let currentDate = NSDate.now
        let stringDate = formatter.string(from: currentDate)
        

        let default_path = FileManager.default.temporaryDirectory
        let dirPath = default_path.appendingPathComponent("photobase")
        
        //See if photobase sub directory exists within temp
        if (!FileManager.default.fileExists(atPath: dirPath.path)) {
            //If not, try creating it
            do
            {
                try FileManager.default.createDirectory(atPath: dirPath.path, withIntermediateDirectories: true, attributes: nil)
                print("tmp/photobase directory created!")
            }
            catch
            {
                print("Unable to create directory \(error.localizedDescription)")
            }
        }
        
        
        let path = dirPath
            .appendingPathComponent("\(stringDate)")
        
        do {
            try data.write(to: path)
            print("Success Saving Image to tmp/photobase")
        } catch {
            print("Error Saving Image to tmp/photobase")
        }
    }
    
}


struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = UIImagePickerController
    typealias Coordinator = ImagePickerCoordinator
    
    @Binding var image: UIImage?
    @Binding var isShown: Bool
    var sourceType: UIImagePickerController.SourceType = .camera
    @Binding var iname: String
    @Binding var domainOnline: Bool
    
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
    func makeCoordinator() -> ImagePicker.Coordinator {
        return ImagePickerCoordinator(image: $image, isShown: $isShown, iname: $iname, domainOnline: $domainOnline)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
        
    }
    
}

