//
//  NavigationBar.swift
//  project
//
//  Created by Alex MAC on 12/4/2023.
//

import SwiftUI

struct NavigationBar: View {

    @Binding var searchText: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 2) {
            HStack {
                Text("M")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("useum")
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer()
                
                
                // MARK: More Button
                    Image(systemName: "ellipsis.circle")
                        .font(.system(size: 28))
                        .frame(width: 44, height: 44, alignment: .trailing)
                }
            .frame(height: 52)
            

            
            // MARK: Search Bar
            HStack(spacing: 2) {
                Image(systemName: "magnifyingglass")
                
                TextField("Search", text: $searchText)
                    .foregroundColor(.yellow)
            }
            .foregroundColor(.secondary)
            .padding(.horizontal, 6)
            .padding(.vertical, 7)
            .frame(height: 36, alignment: .leading)
            .background(Color.bottomSheetBackground, in: RoundedRectangle(cornerRadius: 10))
            .innerShadow(shape: RoundedRectangle(cornerRadius: 10), color: .black.opacity(0.25), lineWidth: 2, offsetX: 0, offsetY: 2, blur: 2)
        }
        .frame(height: 106, alignment: .top)
        .padding(.horizontal, 16)
        .padding(.top, 49)
        .backgroundBlur(radius: 20, opaque: true)
        .background(Color.navBarBackground)
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(searchText: .constant(""))
    }
}

