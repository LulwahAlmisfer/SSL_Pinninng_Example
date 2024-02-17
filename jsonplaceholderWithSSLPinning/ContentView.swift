//
//  ContentView.swift
//  jsonplaceholderWithSSLPinning
//
//  Created by Lulwah Almisfer on 15/02/2024.
//

import SwiftUI

struct ContentView: View {
  @State private var resultText = ""
  var body: some View {
    VStack {
      Button("Perform POST Request") {
        postData()
      }
      .padding()
      Text(resultText)
        .padding()
    }
  }
  func postData() {
    guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else {
      print("Invalid URL")
      return
    }
    let parameters = ["title": "foo", "body": "bar", "userId": "1"]
    guard let postData = try? JSONSerialization.data(withJSONObject: parameters) else {
      print("Failed to serialize JSON")
      return
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = postData
    URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data = data, error == nil else {
        print("Error: \(error?.localizedDescription ?? "Unknown error")")
        return
      }
      if let httpResponse = response as? HTTPURLResponse {
        print("Status Code: \(httpResponse.statusCode)")
      }
      if let decodedData = try? JSONDecoder().decode(PostResponse.self, from: data) {
        DispatchQueue.main.async {
          self.resultText = "Post ID: \(decodedData.id)"
        }
      } else {
        print("Failed to decode response")
      }
    }.resume()
  }
}
struct PostResponse: Decodable {
  let id: Int
}

#Preview {
    ContentView()
}
