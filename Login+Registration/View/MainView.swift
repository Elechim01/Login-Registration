//
//  MainView.swift
//  Dating App
//
//  Created by Michele on 26/12/20.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var accountCreation : AccountCreationViewModel
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        VStack{
            Image("dating")
                .resizable()
                .frame(height: UIScreen.main.bounds.height/2.4)
                .padding(.vertical)
            ZStack{
//              Login view...
                if accountCreation.pageNumber == 0{
                    Login()
                }else if accountCreation.pageNumber == 1 {
                    Register()
                        .transition(.move(edge: .trailing))
                }
                else{
                    ImageRegister()
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.clipShape(CustomCorner(corners: [.topLeft,.topRight])).ignoresSafeArea(.all,edges: .bottom))
        }.background(Color.red).ignoresSafeArea(.all,edges: .all)
        .alert(isPresented: $accountCreation.alert, content: {
            Alert(title: Text("Error"), message: Text(accountCreation.alertMsg), dismissButton: .default(Text("OK")))
        })
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
