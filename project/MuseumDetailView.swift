//
//  MuseumDetailView.swift
//  project
//
//  Created by Alex MAC on 12/4/2023.
//

import SwiftUI
import MapKit

struct Comment: Identifiable, Codable {
    var id: Int
    var museumid: Int
    var sender: String
    var message: String
    var datetime: String
}

var comments = [[String : Any]]()

struct MuseumDetailView: View {
    
    @State private var showMapView : Bool = false
    
    @State private var sender = ""
    
    @State private var commented = ""
    
    var museum: Museum
    @State var commentsList: [Comment] = comments.map {
        cm in Comment(
            id: cm["id"] as! Int,
            museumid: cm["museumid"] as! Int,
            sender: cm["sender"] as! String,
            message: cm["message"] as! String,
            datetime: cm["datetime"] as! String
        )
    }
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var bookmarkItems: FetchedResults<Bookmark>
    @State private var addedInBM: Bool = false
    
    func checkExists(){
        for i in bookmarkItems{
            if i.museum_name == museum.museum_name {
                addedInBM = true
                return
            }
        }
        addedInBM = false
    }
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach([("Name:", museum.museum_name), ("Address:", museum.museum_addr), ("District:", museum.museum_district)], id: \.self.0) { title, value in
                        Text(title)
                            .font(.system(size: 22, weight: .bold))
                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(value)
                            .font(.system(size: 17))
                            .foregroundColor(.gray)
                            .padding(EdgeInsets(top: 3, leading: 0, bottom: 0, trailing: 0))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 16)
                
//                HStack {
//                    Text("Name:\n" + museum.museum_name)
//                        .font(.system(size: 24, weight: .bold))
//                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                        .padding(EdgeInsets(top: 5, leading: 17, bottom: 0, trailing: 0))
//                }
//                HStack {
//                    Text("Address:\n" + museum.museum_addr)
//                        .font(.system(size: 20))
//                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                        .padding(EdgeInsets(top: 5, leading: 17, bottom: 0, trailing: 0))
//                }
//                HStack {
//                    Text("District:\n" + museum.museum_district)
//                        .font(.system(size: 20))
//                        .frame(maxWidth: .infinity, alignment: .topLeading)
//                        .padding(EdgeInsets(top: 5, leading: 17, bottom: 0, trailing: 0))
//                }
                
//                HStack {
//                    .foregroundColor(Color.white)
//                    .padding(.trailing, 10)
//                    .tint(Color.primary)
//                    .cornerRadius(10)
//
//                    Button(action: {
//                        if !addedInBM {
//                            let bm = Bookmark(context: moc)
//                            bm.id = Int16(museum.id)
//                            bm.museum_name = museum.museum_name
//                            bm.museum_addr = museum.museum_addr
//                            bm.museum_lat = museum.museum_lat
//                            bm.museum_lon = museum.museum_lon
//                            bm.museum_district = museum.museum_district
//                            try? moc.save()
//                            addedInBM = true
//                        } else {
//                            for i in bookmarkItems{
//                                if i.museum_name == museum.museum_name {
//                                    moc.delete(i)
//                                    try? moc.save()
//                                    addedInBM = false
//                                    return
//                                }
//                            }
//                        }
//                    })
//                    {
//                        Text((addedInBM ? "Remove from" : "Add to")+" Bookmark")
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .controlSize(.large)
//                    .buttonBorderShape(.capsule)
//                    .tint(addedInBM ? Color.red : Color.green)
//                    .foregroundColor(.white)
//                    .padding(.trailing, 10)
//                    .cornerRadius(10)
//
//                }
                
                HStack(spacing: 10) {
                    Button(action: {
                        showMapView.toggle()
                    }) {
                        Text("View in Map")
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .controlSize(.large)
                    .sheet(isPresented: $showMapView) {
                        if let lat = museum.museum_lat, let lon = museum.museum_lon {
                            Maps(lat: lat, lon: lon, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                        }
                    }
                    .foregroundColor(.white)
                    .tint(.primary)
                    .cornerRadius(10)
                    
                    Button(action: {
                        if let index = bookmarkItems.firstIndex(where: { $0.museum_name == museum.museum_name }) {
                            moc.delete(bookmarkItems[index])
                            try? moc.save()
                            addedInBM = false
                        } else {
                            let bm = Bookmark(context: moc)
                            bm.id = Int16(museum.id)
                            bm.museum_name = museum.museum_name
                            bm.museum_addr = museum.museum_addr
                            bm.museum_lat = museum.museum_lat
                            bm.museum_lon = museum.museum_lon
                            bm.museum_district = museum.museum_district
                            try? moc.save()
                            addedInBM = true
                        }
                    })
                    {
                        Text((addedInBM ? "Remove from" : "Add to")+" Bookmark")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .buttonBorderShape(.capsule)
                    .tint(addedInBM ? .red : .green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Text("Comments:")
                    .font(.system(size: 24, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(EdgeInsets(top: 18, leading: 14, bottom: 8, trailing: 0))
                VStack(spacing: 10){
                    ForEach(commentsList.reversed()) { comment in
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("\(comment.sender):")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
                                Text(getFormatedDate(dateString: comment.datetime))
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            HStack {
                                Text(comment.message)
                                    .font(.body)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Spacer()
//                                Button(action: {
//                                    let paras: [String: Any] = ["service": "delete_comments", "id": comment.id]
//                                    createAjax(link: "https://pofo.me/museums/hkctapi.php", paras: paras) { response in
//                                        if let data = response as? [String: Any], let success = data["success"] as? Bool, success {
//                                            comments.removeAll { $0.id == comment.id }
//                                            self.commentsList = comments.map {
//                                                Comment(
//                                                    id: $0.id,
//                                                    museumid: $0.museumid,
//                                                    sender: $0.sender,
//                                                    message: $0.message,
//                                                    datetime: $0.datetime
//                                                )
//                                            }
//                                        }
//                                    }
//                                }) {
//                                    Text("Delete")
//                                }
                            }
                        }
                        .padding(10)
                        .background(Color(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)))
                        .cornerRadius(10)
                        .fixedSize(horizontal: false, vertical: true)
                        .alignmentGuide(.leading) {
                            _ in 0
                        }
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 14, bottom: 0, trailing: 14))
                HStack {
                    TextField("Your name (optional)", text: $sender)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }
                HStack {
                    TextField("You may leave comment here.", text: $commented)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }
                Button(action: {
                    let senderName = sender.isEmpty ? "Anonymous User" : sender
                    let paras: Dictionary = ["service":"leave_comments", "museumid":String(museum.id), "sender": senderName, "message":commented]
                    createAjax(link:"https://pofo.me/museums/hkctapi.php", paras: paras) { response in
                        if let data = response as? Dictionary<String, AnyObject> {
                            let newcm = data["msg"]!["comment"]! as! [String : Any]
                            comments.append(newcm)
                            self.commentsList = comments.map {
                                cm in Comment(
                                    id: cm["id"] as! Int,
                                    museumid: cm["museumid"] as! Int,
                                    sender: cm["sender"] as! String,
                                    message: cm["message"] as! String,
                                    datetime: cm["datetime"] as! String
                                )
                            }
                            commented = ""
                            sender = ""
                        }
                    }
                })
                {
                    Text("Send")
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 50, trailing: 10))
        }
        .navigationTitle("Museum Detail")
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .onAppear(){
            checkExists()
            let paras: Dictionary = ["service":"get_comments", "museumid":String(museum.id)]
            createAjax(link:"https://pofo.me/museums/hkctapi.php", paras: paras) { response in
                if let data = response as? Dictionary<String, AnyObject> {
                    comments = data["msg"]!["comments"]! as! [[String : Any]]
                    self.commentsList = comments.map {
                        cm in Comment(
                            id: cm["id"] as! Int,
                            museumid: cm["museumid"] as! Int,
                            sender: cm["sender"] as! String,
                            message: cm["message"] as! String,
                            datetime: cm["datetime"] as! String
                        )
                    }
                }
            }
        }
    }
}

func createAjax(link: String, paras: [String: Any], completion: @escaping(Any) -> ()){
    guard let url = URL(string: link) else { return }
    let urlParams = paras.compactMap({ (key, value) -> String in
        return "\(key)=\(value)"
    }).joined(separator: "&")
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.httpBody = Data(urlParams.utf8)
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        guard let data = data else { return }
        let resData = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        DispatchQueue.main.async {
            completion(resData!)
        }
    }.resume()
}

func getFormatedDate(dateString: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    dateFormatter.locale = Locale(identifier: "Asia/Hong_Kong")
    guard let date = dateFormatter.date(from: dateString) else {
        return ""
    }
    dateFormatter.dateFormat = "yyyy/MM/dd' at 'h:mm a"
    return dateFormatter.string(from: date)
}


