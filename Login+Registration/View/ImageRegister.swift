//
//  ImageRegister.swift
//  Dating App
//
//  Created by Michele on 26/12/20.
//

import SwiftUI

struct ImageRegister: View {
    @EnvironmentObject var accountCreation : AccountCreationViewModel
    @State var currentImage = 0
    var body: some View {
        VStack{
            HStack{
                Text("Show Yourself")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                Spacer()
                if ceck(){
                    Button(action: {
                        accountCreation.signUP()
                    }, label: {
                        Text("Create")
                            .fontWeight(.heavy)
                            .foregroundColor(.red)
                    })
                }
            }
            .padding(.top,30)
            GeometryReader { reader in
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing:15), count: 2),spacing : 20, content: {
                    ForEach(accountCreation.images.indices, id: \.self){ index in
                        ZStack{
                            if accountCreation.images[index].count == 0{
                                Image(systemName: "person.badge.plus")
                                    .font(.system(size: 45))
                                    .foregroundColor(.red)
                            }else{
                                Image(uiImage: UIImage(data: accountCreation.images[index])!)
                                    .resizable()
                            }
                        }
                        .frame(width: (reader.frame(in: .global).width-15)/2,
                               height: (reader.frame(in: .global).height - 20) / 2)
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(color: Color.black.opacity(0.05),radius: 5,x:5,y:5)
                        .shadow(color: Color.black.opacity(0.05),radius: 5,x:-5 ,y:-5)
                        .onTapGesture {
//                            image picker
                            currentImage = index
                            accountCreation.picker.toggle()
                        }
                    }
                })
                
            }.padding(.top)
            .padding(.bottom,30)
        }
        .padding(.horizontal)
        .sheet(isPresented: $accountCreation.picker, content: {
            ImagePicker(show: $accountCreation.picker, ImageData: $accountCreation.images[currentImage])
        })
    }
    func ceck()-> Bool{
        for data in accountCreation.images{
            if data.count == 0{
                return false
            }
        }
        return true
    }
}

struct ImageRegister_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
