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

    var body: some View {
        VStack(alignment: .center) {
            TextField("Enter your domain", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    print(validateFunction(domain: ("https://" + name + ".loca.lt")))
                }
            Text(validateFunction(domain: ("https://" + name + ".loca.lt")))
                .padding()
                .foregroundColor(textColor(input: ("https://" + name + ".loca.lt")))
            Button("Open Camera") {
            }
            .padding()
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
    
    func validURL(input: String) -> Void {
        if input != "" {
            let url1 = URL(string: input)!
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
        ContentView()
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
