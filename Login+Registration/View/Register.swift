//
//  Register.swift
//  Dating App
//
//  Created by Michele on 26/12/20.
//

import SwiftUI
import CoreLocation

struct Register: View {
    @EnvironmentObject var account : AccountCreationViewModel
    @State var manager = CLLocationManager()
    var body: some View {
        VStack {
            Text("Create Account")
                .foregroundColor(.black)
                .font(.title)
                .foregroundColor(.black)
                .fontWeight(.heavy)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top,35)
            
            HStack(spacing : 15){
                Image(systemName: "person.fill")
                    .foregroundColor(Color.red)
                TextField("Name", text: $account.name)
                    .foregroundColor(.black)
            }
            .padding(.vertical,12)
            .padding(.horizontal)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            .padding(.vertical)
            
            HStack(spacing : 15){
                
                HStack(spacing : 15){
                    TextField("Location", text: $account.location)
                        .foregroundColor(.black)
                    Button(action: {
                        manager.requestWhenInUseAuthorization()
                    }, label: {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                    })
                }
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                
                TextField("Age", text: $account.age)
                    .foregroundColor(.black)
                .padding(.vertical,12)
                .padding(.horizontal)
                .frame(width:80)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
            }
                TextEditor(text: $account.bio)
                    .foregroundColor(.black)
                    .padding(.vertical,12)
                    .padding(.horizontal)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: -5, y: -5)
                    .padding(.vertical)
            Button(action: {
                account.pageNumber = 2
            }, label: {
                HStack{
                    Spacer(minLength: 0)
                    Text("Register")
                    Spacer(minLength: 0)
                    Image(systemName: "arrow.right")
                }
//                .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                .foregroundColor(.white)
                .padding(.vertical,12)
                .padding(.horizontal)
                .background(Color.red)
                .cornerRadius(8)
            })
            .opacity((account.name != "" && account.age != "" && account.bio != "" && account.location != "") ? 1 : 0.6)
            .disabled((account.name != "" && account.age != "" && account.bio != "" && account.location != "") ? false  : true)
            
            Spacer()
            Spacer()
            Spacer()
        }.padding(.horizontal)
        .onAppear{
            manager.delegate = account
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
