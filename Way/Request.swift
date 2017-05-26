import Foundation
import Alamofire
import SwiftyJSON

protocol RequestDelegate {
    func loadedBuildings()
    func loadedCampus()
}

enum RequestType {
    case buildings, postUser, userLeft, rooms, campus
}


class Request {
    
    let headers = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]
    
    var delegate: RequestDelegate?
    
    func loadBuildings() {
        request(method: .get, parameters: nil, urlExt: "buildings", requestType: .buildings)
    }
    
    func loadRooms() {
        request(method: .get, parameters: nil, urlExt: "rooms", requestType: .rooms)
    }
    
    func campusRefresh() {
        request(method: .get, parameters: nil, urlExt: "buildings", requestType: .campus)
    }
    
    
    func userEnter(buildingId: Int) {

        let parameters = [
            "building_id": buildingId,
            "active": true
            ] as [String : Any]
        
        request(method: .post, parameters: parameters, urlExt: "users", requestType: .postUser)
    }

    
    func userLeft(buildingId: Int) {
        let parameters = [
            "active": false
            ] as [String : Any]
        
        request(method: .put, parameters: parameters, urlExt: "users/\(UserManager.sharedManager.id!)", requestType: .userLeft)
    }
    

    private func request(method: HTTPMethod, parameters: [String : Any]?, urlExt: String, requestType: RequestType) {
        
        let baseUrl = "http://178.62.44.213/api/"
        let url = baseUrl + urlExt
        
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .response { response in
                guard let data = response.data else {
                    //got no json
                    return
                }
                
                let json = JSON(data: data)
            
                if requestType == .buildings {
                    self.handleBuildings(json: json)
                }
                
                if requestType == .campus {
                    self.handleCampus(json: json)
                }
                
                if requestType == .postUser {
                    self.postedUser(json: json)
                }
                
                if requestType == .rooms {
                    self.handleRooms(json: json)
                }
                
        }
    }
    
    
    private func handleBuildings(json: JSON) {
        //loop through buildings and set them up
        for buildingData in json["data"].arrayValue {
            let building = Building(json: buildingData)
            BuildingManager.shared.buildings.append(building)
        }
        
        delegate?.loadedBuildings()
        
    }
    
    private func handleCampus(json: JSON) {
        //loop through buildings and set them up
        for buildingData in json["data"].arrayValue {
            let building = Building(json: buildingData)
            BuildingManager.shared.buildings.append(building)
        }
        
        delegate?.loadedCampus()
        
    }
    
    private func handleRooms(json: JSON) {
        for roomData in json["data"].arrayValue {
            let room = Room(json: roomData)
            RoomManager.shared.rooms.append(room)
        }
    }
    
    
    private func postedUser(json: JSON) {
        UserManager.sharedManager.id = json["data"]["id"].int!
    }
    

    
}


