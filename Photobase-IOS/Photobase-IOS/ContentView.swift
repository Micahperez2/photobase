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
                    
                Button {
                    print("Open Camera")
                    self.showSheet = true
                } label: {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(textColor(input: ("https://" + name + ".loca.lt")))
                        .frame(width: 250, height: 200, alignment: .bottom)
                }
                .padding()
                .actionSheet(isPresented: $showSheet) {
                      ActionSheet(title: Text("Select Photo"), message: Text("Choose"), buttons: [
                          .default(Text("Photo Library")) {
                              self.showImagePicker = true
                              self.sourceType = .photoLibrary
                          },
                          .default(Text("Camera")) {
                              self.showImagePicker = true
                              self.sourceType = .camera
                          },
                          .cancel()
                      ])
              }
            }
          
                    
            }.sheet(isPresented: $showImagePicker) {
                ImagePicker(image: self.$image, isShown: self.$showImagePicker, sourceType: self.sourceType, iname: self.$name)
            }
    }
    
    func validateFunction(domain: String) -> String {
        validURL(input: domain)
        if (isvalidURL) {
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

