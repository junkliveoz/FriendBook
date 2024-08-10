//
//  UserData.swift
//  FriendBook
//
//  Created by Adam Sayer on 11/8/2024.
//

import SwiftUI

struct Response: Codable {
    var users: [User]
}

struct User: Codable, Hashable, Identifiable {
    var id: UUID
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: Date
    var tags: [String]
    var friends: [String]
    
    static let example = User(id: UUID(), isActive: true, name: "Adam Sayer", age: 42, company: "XAM", email: "adasay@xam.com.au", address: "105 Edwin Ward Place, Mona Vale, NSW, 2103", about: "Doing his best to learn SwiftUI", registered: Date.now, tags: ["SwiftUI", "MTB", "Music"], friends: [])
}

struct UserData: View {
    
    @State private var users = [User]()
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                } else if users.isEmpty {
                    Text("No users found.")
                } else {
                    List(users) { user in
                        VStack(alignment: .leading) {
                            Text(user.name)
                                .font(.headline)
                            Text(user.email)
                        }
                    }
                }
            }
            .navigationTitle("Users")
        }
        .task {
            await loadData()
        }
    }
    
    func loadData() async {
        
        isLoading = true
        errorMessage = nil
        
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else { print("invalid URL")
            errorMessage = "Invalid URL"
            isLoading = false
            return
            }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedUsers = try? JSONDecoder().decode(Response.self, from: data)
                {
                users = decodedUsers.users
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    UserData()
}

