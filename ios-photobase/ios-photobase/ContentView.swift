//
//  ContentView.swift
//  ios-photobase
//
//  Created by Micah Perez on 2/26/22.
//

import SwiftUI

struct ContentView: View {
    @State private var name: String = "Tim"

    var body: some View {
        VStack(alignment: .center) {
            TextField("Enter your name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    print(validateFunction(domain: name))
                }
            Text(validateFunction(domain: name))
                .padding()
            Button(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/) {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
            }
            .padding()
        }
    }
    func validateFunction(domain: String) -> String {

        if (domain == "Hello") {
            return "Good"
        }
        else if (domain == "World") {
            return "Caution"
        }
        else {
            return "Bad"
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
