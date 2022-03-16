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
    let offBlack = Color(red: 0.11, green: 0.11, blue: 0.12)
    let photoPurple = Color(red: 0.729, green: 0.333, blue: 0.827)
    
    var body: some View {
            ZStack{
                offBlack
                .ignoresSafeArea(.all)
                
                VStack(alignment: .center) {
                Text("Photobase")
                    .font(.custom("Chalkduster", size: 60))
                    .foregroundColor(photoPurple)
                    .frame(width: 350, height: 250, alignment: .top)
                TextField("Enter your Passcode", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.vertical, 75)
                    .padding(.horizontal, 40)
                    .foregroundColor(photoPurple)
                    .onSubmit {
                        print(validateFunction(domain: ("https://" + name + ".loca.lt")))
                    }
                //Text(validateFunction(domain: ("https://" + name + ".loca.lt")))
                //   .padding()
                //  .foregroundColor(textColor(input: ("https://" + name + ".loca.lt")))
                Button {
                    print("Open Camera")
                } label: {
                    Image(systemName: "camera")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(textColor(input: ("https://" + name + ".loca.lt")))
                        .frame(width: 250, height: 200, alignment: .bottom)
                }
                .padding()
            }
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
