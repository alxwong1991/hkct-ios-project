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
    
    @State private var commented = ""
    
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
                HStack {
                    Text("Name:\n" + museum.museum_name).font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .topLeading).padding(EdgeInsets(top: 5, leading: 17, bottom: 0, trailing: 0))
                }
                HStack {
                    Text("Address:\n" + museum.museum_addr).font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .topLeading).padding(EdgeInsets(top: 5, leading: 17, bottom: 0, trailing: 0))
                }
                HStack {
                    Text("District:\n" + museum.museum_district).font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .topLeading).padding(EdgeInsets(top: 5, leading: 17, bottom: 0, trailing: 0))
                }
                
                HStack{
                    Button(action: {
                        self.showMapView.toggle()
                    }) {
                        Text("View in Map")
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.capsule)
                    .controlSize(.large)
                    .frame(alignment: .topLeading)
                    .sheet(isPresented: $showMapView) {
                        if let lat = museum.museum_lat, let lon = museum.museum_lon {
//                            print("lat: \(lat), lon: \(lon)")
                            Maps(lat: lat, lon: lon, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                        }
//                        Maps(lat: museum.museum_lat, lon: museum.museum_lon, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: museum.museum_lat, longitude: museum.museum_lon), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
                    }
                }
                
                Button(action: {
                    if !addedInBM {
                        let bm = Bookmark(context: moc)
                        bm.id = Int16(museum.id)
                        bm.museum_name = museum.museum_name
                        bm.museum_addr = museum.museum_addr
                        bm.museum_lat = museum.museum_lat
                        bm.museum_lon = museum.museum_lon
                        bm.museum_district = museum.museum_district
                        try? moc.save()
                        addedInBM = true
                    } else {
                        for i in bookmarkItems{
                            if i.museum_name == museum.museum_name {
                                moc.delete(i)
                                try? moc.save()
                                addedInBM = false
                                return
                            }
                        }
                    }
                })
                {
                    Text((addedInBM ? "Remove from" : "Add to")+" Bookmark")
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .controlSize(.large)
                Text("Comments:")
                    .font(.system(size: 24))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(EdgeInsets(top: 18, leading: 14, bottom: 8, trailing: 0))
                VStack(spacing: 10){
                    ForEach(commentsList.reversed()) { cm in
                        VStack(alignment: .leading, spacing: 8){
                            Text("\(cm.sender):")
                                .font(.headline)
                                .foregroundColor(.blue)
                                .frame(maxWidth: .infinity)
                            Text(cm.message)
                                .font(.body)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                            Text(cm.datetime)
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(20)
                        .background(Color(UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)))
                        .cornerRadius(10)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: 14))
                HStack {
                    TextField("You may leave comment here.", text: $commented)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        .font(.headline)
                    Button(action: {
                        let paras: Dictionary = ["service":"leave_comments", "museumid":String(museum.id), "sender":"User", "message":commented]
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
}

