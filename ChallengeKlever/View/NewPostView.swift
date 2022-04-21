//
//  NewPostView.swift
//  ChallengeKlever
//
//  Created by Douglas Biagi Grana on 21/04/22.
//

import SwiftUI

struct NewPostView: View {
    @EnvironmentObject var network: Network
    @Binding var isPresented: Bool
    @Binding var title: String
    @Binding var description: String
    @State var isAlert = false
    
    var body: some View {
        NavigationView {
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
                .alert(isPresented: $isAlert) {
                    let title = Text("Ops...")
                    let message = Text("Parece que voce nao preencheu todos os campos.")
                    return Alert(title: title, message: message)
                }
            }
            .navigationBarTitle("Adicionar nova nota", displayMode: .inline)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }
}

extension NewPostView {
    var cancelButton: some View {
        Button {
            isPresented.toggle()
        } label: {
            Text("Cancelar")
        }
    }
    
    var saveButton: some View {
        Button {
            if title.isEmpty || description.isEmpty {
                isAlert.toggle()
            } else {
                let parameters: [String: String] = ["title": title, "description": description]
                network.addPosts(parameters: parameters)
                network.fetchPosts()
                isPresented.toggle()
            }
        } label: {
            Text("Salvar")
        }
    }
}
