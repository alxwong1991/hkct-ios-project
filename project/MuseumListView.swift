//
//  MuseumListView.swift
//  project
//
//  Created by Alex MAC on 12/4/2023.
//

import SwiftUI
import CoreData

struct Museum: Identifiable, Codable {
    var id: Int
    var museum_name: String
    var museum_addr: String
    var museum_district: String
    var museum_isgov: Bool
    var museum_lat: Double
    var museum_lon: Double
}

var museums = [[String: Any]]()

class MuseumList: ObservableObject {
    @Published var museumList: [Museum] = []
}

class DataManager: NSObject, ObservableObject {
    @Published var bookmarkItems: [Museum] = [Museum]()
    
    lazy var container: NSPersistentContainer = NSPersistentContainer(name: "Model")
    
    override init() {
        super.init()
        container.loadPersistentStores {
            _, _ in
        }
    }
}

struct MuseumListView: View {
    
    @State public var path = NavigationPath()
    
    @State public var isBookmarksView: Bool = false
    
    @State public var museumList: [Museum] = []
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(sortDescriptors: []) var bookmarkItems: FetchedResults<Bookmark>
    
    var body: some View {
        NavigationStack(path: $path) {
            HStack {
                Toggle(isOn: $isBookmarksView) {
                    Text("Show bookmarks view")
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .toggleStyle(SwitchToggleStyle(tint: Color.blue))
            }
            if !isBookmarksView {
                List(museumList) { museum in
                    NavigationLink(destination: MuseumDetailView(museum: museum)) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(museum.museum_name)
                                .font(.system(size: 22))
                                .fontWeight(.bold)
                            Text(museum.museum_addr)
                                .font(.system(size: 17))
                                .foregroundColor(.gray)
                            Text("Is it gov owned: \(museum.museum_isgov ? "Yes" : "No")")
                                .font(.system(size: 17))
                                .foregroundColor(.gray)
                        }
                    }
                    .listRowBackground(Color.eventCardBackground)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle("Museum List", displayMode: .inline)
                .font(.system(size: 32, weight: .bold))
                .background(Color.background)
            } else {
                List(bookmarkItems) { bm in
                    NavigationLink(destination: MuseumDetailView(museum: Museum(
                        id: Int(bm.id),
                        museum_name: bm.museum_name ?? "Fail to fetch data from server",
                        museum_addr: bm.museum_addr ?? "Fail to fetch data from server",
                        museum_district: bm.museum_district ?? "Fail to fetch data from server",
                        museum_isgov: false,
                        museum_lat: bm.museum_lat,
                        museum_lon: bm.museum_lon
                    ))) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(bm.museum_name ?? "")
                                .font(.system(size: 18))
                                .fontWeight(.bold)
                            Text("Is it gov owned: \(bm.museum_isgov ? "Yes" : "No")")
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(Color.eventCardBackground)
                }
                .navigationTitle("Bookmark List")
            }
        }
        
        .onAppear() {
            let paras: Dictionary = ["service":"get_museums"]
            createAjax(link:"https://pofo.me/museums/hkctapi.php", paras: paras) { response in
                if let data = response as? Dictionary<String, AnyObject> {
                    museums = data["msg"]!["museums"]! as! [[String : Any]]
                    self.museumList = museums.map {
                        museum in Museum(
                            id: museum["raw_id"] as! Int,
                            museum_name: museum["museum_name_en"] as! String,
                            museum_addr: museum["museum_addr_en"] as! String,
                            museum_district: museum["museum_district_en"] as! String,
                            museum_isgov: museum["museum_isgov"] as! Bool,
                            museum_lat: museum["museum_lat"] as! Double,
                            museum_lon: museum["museum_lon"] as! Double
                        )
                    }
                }
            }
        }
    }
    public struct MyStruct: Decodable {
        public var unknown: Double?
        public var meta: [String: String]?
        
        public init(from decoder: Decoder) {
            
            guard let container = try? decoder.container(keyedBy: CodingKeys.self) else {
                fatalError()
            }
            for key in container.allKeys {
                unknown = try? container.decode(Double.self, forKey: key)
                if key.stringValue == "Meta" {
                    meta = try? container.decode([String: String].self, forKey: key)
                }
                
            }
            print(container.allKeys)
        }
        
        struct CodingKeys: CodingKey {
            var stringValue: String
            init?(stringValue: String) {
                self.stringValue = stringValue
            }
            var intValue: Int?
            init?(intValue: Int) {
                return nil
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
