//
//  ContentView.swift
//  ChallengeKlever
//
//  Created by Douglas Biagi Grana on 19/04/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var network: Network
    @State var isPresentedNewPost = false
    @State var title: String = ""
    @State var description: String = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(network.items, id: \.id) { item in
                    NavigationLink {
                        DetailView(item: item)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(item.title)
                            Text(item.description)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .onDelete(perform: deleteButton)
            }
            .navigationTitle("Minhas Notas")
            .navigationBarItems(trailing: addButton)
        }
        .onAppear {
            network.fetchPosts()
        }
        .sheet(isPresented: $isPresentedNewPost) {
            NewPostView(isPresented: $isPresentedNewPost, title: $title, description: $description)
        }
    }
}

extension ContentView {
    var addButton: some View {
        Button {
            isPresentedNewPost.toggle()
        } label: {
            Image(systemName: "plus")
        }
    }
    
    func deleteButton(indexSet: IndexSet) {
        let id = indexSet.map { network.items[$0].id }
        DispatchQueue.main.async {
            let postID: String = id[0]
            network.deletePosts(id: postID)
            network.fetchPosts()
        }
    }
}
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
