//
//  ViewModel.swift
//  ChallengeKlever
//
//  Created by Douglas Biagi Grana on 20/04/22.
//

import Foundation
import SwiftUI

class Network: ObservableObject {
    @Published var items: [PostsModel] = []
    let baseURL = "https://6260566153a42eaa0703915a.mockapi.io/posts"
    
    //MARK: - FETCHPOST
    func fetchPosts() {
        guard let url = URL(string: baseURL) else {
            print("URL nao encontrada")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Fetch error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedPost = try JSONDecoder().decode([PostsModel].self, from: data)
                        self.items = decodedPost
                    } catch let error {
                        print("Error decoding: \(error)")
                    }
                }
            }
        }.resume()
    }
    
    //MARK: - ADDPOST
    func addPosts(parameters: [String: Any]) {
        guard let url = URL(string: baseURL) else {
            print("URL nao encontrada")
            return
        }
        
        let data = try? JSONSerialization.data(withJSONObject: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fetch error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                print("server error")
                return
            }
        }.resume()
    }
    
    //MARK: - UPDATEPOST
    func updatePosts(parameters: [String: Any]) {
        guard let url = URL(string: "\(baseURL)/\(parameters["id"]!)") else {
            print("URL nao encontrada")
            return
        }
        
        let data = try? JSONSerialization.data(withJSONObject: parameters)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fetch error: \(error.localizedDescription)")
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                print("server error")
                return
            }
        }.resume()
    }
    
    //MARK: - DELETEPOST
    func deletePosts(id: String) {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            print("URL nao encontrada")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                print("server error")
                return
            }
            
        }.resume()
    }
}
