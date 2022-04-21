//
//  DetailView.swift
//  ChallengeKlever
//
//  Created by Douglas Biagi Grana on 21/04/22.
//

import SwiftUI

struct DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var network: Network
    @State var title: String = ""
    @State var description: String = ""
    @State var isAlert = false
    let item: PostsModel
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6).edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack(alignment: .leading) {
                    Text("Titulo")
                        .font(.callout)
                    .foregroundColor(.gray)
                    TextField("Digite seu titulo...", text: $title)
                        .padding(.horizontal)
                        .frame(height: 55)
                        .background(Color(uiColor: .white))
                    .cornerRadius(10)
                }
                
                VStack(alignment: .leading) {
                    Text("Descricao")
                        .font(.callout)
                        .foregroundColor(.gray)
                    TextField("Digite sua descricao...", text: $description)
                        .padding(.horizontal)
                        .frame(height: 55)
                        .background(Color(uiColor: .white))
                    .cornerRadius(10)
                }
                Spacer()
            }
            .padding()
            .onAppear {
                self.title = item.title
                self.description = item.description
            }
            .alert(isPresented: $isAlert) {
                let title = Text("Ops...")
                let message = Text("Parece que voce nao preencheu todos os campos.")
                return Alert(title: title, message: message)
            }
        }
        .navigationBarTitle("Editar nota", displayMode: .inline)
        .navigationBarItems(trailing: saveButton)
    }
}

extension DetailView {
    var saveButton: some View {
        Button {
            if title.isEmpty || description.isEmpty {
                isAlert.toggle()
            } else {
                let parameters: [String: String] = ["id": item.id, "title": title, "description": description]
                network.updatePosts(parameters: parameters)
                network.fetchPosts()
                presentationMode.wrappedValue.dismiss()
            }
        } label: {
            Text("Salvar")
        }
    }
}

//struct DetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetailView()
//    }
//}
