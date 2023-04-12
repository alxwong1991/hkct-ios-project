//
//  DetailView.swift
//  project
//
//  Created by Alex MAC on 12/4/2023.
//

import SwiftUI

struct DetailView: View {

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
            ZStack {
                Color("Bg")
                ScrollView  {
                    
                    // Product Image
                    
                        Image("red")
                            .resizable()
                            .aspectRatio(1,contentMode: .fit)
                            .edgesIgnoringSafeArea(.top)
                    
                    DescriptionView()
                    
                }
                .edgesIgnoringSafeArea(.top)
                
                
                NavigationLink {
                    MuseumListView()
                } label: {
                    HStack {
                        Text("$320")
                            .font(.title)
                            .foregroundColor(.white)
                        Spacer()
                        
                        Text("Museum List")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("Primary"))
                            .padding()
                            .padding(.horizontal, 8)
                            .background(Color.white)
                            .cornerRadius(10.0)
                        
                    }
                }
                .padding()
                .padding(.horizontal)
                .background(Color("Primary"))
                .cornerRadius(60.0, corners: .topLeft)
                .frame(maxHeight: .infinity, alignment: .bottom)
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }



struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView()
        }
    }
}


struct ColorDotView: View {
    let color: Color
    var body: some View {
        color
            .frame(width: 24, height: 24)
            .clipShape(Circle())
    }
}

struct DescriptionView: View {
    var body: some View {
        VStack (alignment: .leading) {
            //                Title
            Text("The Age Of Love \n...")
                .font(.title)
                .fontWeight(.bold)
            //                Rating
            HStack (spacing: 4) {
                ForEach(0 ..< 5) { item in
                    Image("star")
                }
                Text("(4.9)")
                    .opacity(0.5)
                    .padding(.leading, 8)
                Spacer()
            }
            
            Text("Description")
                .fontWeight(.medium)
                .padding(.vertical, 8)
            Text("Love has always been a source of inspiration for artists. Romance, family ties, teacher-student bonds, friendship, patriotism... \nAll these forms of love provide artists with an endless wellspring of creative energy.")
                .lineSpacing(8.0)
                .opacity(0.6)
            
            .padding(.vertical)
            
        }
        .padding()
        .padding(.top)
        .background(Color("Bg"))
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .offset(x: 0, y: -30.0)
    }
}

