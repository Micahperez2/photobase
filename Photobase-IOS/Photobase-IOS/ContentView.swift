//
//  ContentView.swift
//  ios-photobase
//
//  Created by Micah Perez on 2/26/22.
//

import SwiftUI

struct ContentView: View {
    @State private var name: String = ""
    @State private var isvalidURL: Bool = false
    
    @State private var showSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var domainOnline: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    
    @State private var image: UIImage?
    
    
    let offBlack = Color(red: 0.11, green: 0.11, blue: 0.12)
    let photoPurple = Color(red: 0.729, green: 0.333, blue: 0.827)
    
    var body: some View {
        ZStack {
                offBlack
                .ignoresSafeArea(.all)
                
                VStack(alignment: .center) {
                Text("Photobase")
                    .font(.custom("Chalkduster", size: 60))
                    .foregroundColor(photoPurple)
                    .frame(width: 350, height: 200, alignment: .center)
                    
//                Image(uiImage: image ?? UIImage(named: "placeholder")!)
//                    .resizable()
//                    .frame(width: 50, height: 50)
                    
                TextField("Enter your Passcode", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.vertical, 75)
                    .padding(.horizontal, 40)
                    .foregroundColor(photoPurple)
                    .onSubmit {
                        print(validateFunction(domain: ("https://" + name + ".loca.lt")))
                    }
                    .autocapitalization(.none)

        if(validateFunction(domain: ("https://" + name + ".loca.lt")) == "Domain Online"){
                Button {
                    print("Open Camera")
                    self.showSheet = true
                } label: {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.green)
                        .frame(width: 250, height: 200, alignment: .bottom)
                }
                .padding()
                .actionSheet(isPresented: $showSheet) {
                      ActionSheet(title: Text("Take a Photo or Send Existing Photos"), buttons: [
                          .default(Text("Camera")) {
                              self.showImagePicker = true
                              self.domainOnline = true
                              self.sourceType = .camera
                          },
                        .default(Text("Send Photos")) {
                            sendSavedImages(urlName: ("https://" + name + ".loca.lt/post-test"))
                        },
                        .cancel()
                      ])
              }
            }
            else{
                    Button {
                        print("Open Camera")
                        self.showSheet = true
                    } label: {
                        Image(systemName: "camera")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color.red)
                            .frame(width: 250, height: 200, alignment: .bottom)
                    }
                    .padding()
                    .actionSheet(isPresented: $showSheet) {
                        ActionSheet(title: Text("Take a Photo to Send Later"), buttons: [
                              .default(Text("Camera")) {
                                  self.showImagePicker = true
                                  self.domainOnline = false
                                  self.sourceType = .camera
                              },
                              .cancel()
                          ])
                  }
                }
            }
          
            }//.sheet(isPresented: $showImagePicker) {
            .fullScreenCover(isPresented: $showImagePicker) {
                ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType, iname: self.$name, domainOnline: $domainOnline)
                .edgesIgnoringSafeArea(.all)
            }
    }
    
    func validateFunction(domain: String) -> String {
        //Create variables to specify letters or numbers
        let letters = CharacterSet.letters
        //let digits = CharacterSet.decimalDigits
        
        var correct_format = true
        
        //if last char is a character return true, else return false
        for uni in domain[(domain.count-9)].unicodeScalars {
            if letters.contains(uni){
                correct_format = true
                print("Format is Correct")
            }
            else {
                correct_format = false
                print("Format is not Correct")
            }
        }

        validURL(input: domain)
        if (isvalidURL && correct_format) {
            return "Domain Online"
        }
        else {
            return "Domain Offline"
        }
    }
    func textColor(input: String) -> Color {

        if (isvalidURL) {
            return Color.green
        }
        else {
            return Color.red
        }
    }
    
    func validURL(input: String?) -> Void {
        if let input = input {
            guard let url1 = URL(string: input) else { return }
            url1.isReachable { success in
                if success {
                    isvalidURL = true
                    print("url1 is reachable")  // url1 is reachable
                } else {
                    isvalidURL = false
                    print("url1 is unreachable") // url1 is unreachable
                }
            }
        }
    }
    
    func sendSavedImages(urlName: String) -> Void {
        //@State var curimage: UIImage
        let docsDir = FileManager.default.temporaryDirectory.appendingPathComponent("photobase").path
        let localFileManager = FileManager()
        
        let url = URL(string: urlName)
        print(urlName)
        
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        let session = URLSession.shared
    
        
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "POST"
        
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        let dirEnum = localFileManager.enumerator(atPath: docsDir)


        while let file = dirEnum?.nextObject() as? String {
                var data = Data()
                let path = docsDir + "/" + file
                guard let curimage = UIImage(contentsOfFile: path) else {
                    print("No Photo Found")
                    return
                }
                
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=photodata; filename=photodata".data(using: .utf8)!)
                data.append("Content-Type: image/\(file)\r\n\r\n".data(using: .utf8)!)
                data.append(curimage.jpegData(compressionQuality: 0.1)!)
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
                
                let url_path = URL(fileURLWithPath: path)
                
                do {
                    try FileManager.default.removeItem(at: url_path)
                } catch let error {
                    print("Error deleting image. \(error)")
                }
                print(file + " has been sent!")
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            ContentView()
        }
    }
}

extension URL {
    func isReachable(completion: @escaping (Bool) -> ()) {
        var request = URLRequest(url: self)
        request.httpMethod = "HEAD"
        URLSession.shared.dataTask(with: request) { _, response, _ in
            completion((response as? HTTPURLResponse)?.statusCode == 200)
        }.resume()
    }
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

class ViewController: UIViewController,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
    {
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
}

