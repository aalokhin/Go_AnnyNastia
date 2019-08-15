//
//  MapJSON.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/4/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation

class mapJSON : Decodable {
    //let campusCounts : CampusCounts
    
    let totalAps : Int?
    let totalBuildings : Int?
    let totalCampuses : Int?
    let totalFloors : Int?
    let campusCounts : [CampusCounts]?
    
    enum CodingKeys: String, CodingKey {
        case totalAps = "totalAps"
        case totalBuildings = "totalBuildings"
        case totalCampuses = "totalCampuses"
        case totalFloors = "totalFloors"
        case campusCounts = "campusCounts"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.totalAps = (try? values.decode(Int.self, forKey: .totalAps))
        self.totalBuildings = (try? values.decode(Int.self, forKey: .totalBuildings))
        self.totalCampuses = (try? values.decode(Int.self, forKey: .totalCampuses))
        self.totalFloors = (try? values.decode(Int.self, forKey: .totalFloors))
        self.campusCounts = (try? values.decode([CampusCounts].self, forKey: .campusCounts))
    }
}


class CampusCounts : Decodable {
    let campusName : String?
    let totalBuildings : Int?
    let buildingCounts : [BuildingCounts]?
    
    enum CodingKeys: String, CodingKey {
        case campusName = "campusName"
        case totalBuildings = "totalBuildings"
        case buildingCounts = "buildingCounts"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.campusName = (try? values.decode(String.self, forKey: .campusName))
        self.totalBuildings = (try? values.decode(Int.self, forKey: .totalBuildings))
        self.buildingCounts = (try? values.decode([BuildingCounts].self, forKey: .buildingCounts))
    }
}

class BuildingCounts : Decodable {
    let buildingName : String?
    let floorCounts : [FloorCounts]?
    let totalFloors : Int?
    enum CodingKeys: String, CodingKey {
        case buildingName = "buildingName"
        case floorCounts = "floorCounts"
        case totalFloors = "totalFloors"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.buildingName = (try? values.decode(String.self, forKey: .buildingName))
        self.floorCounts = (try? values.decode([FloorCounts].self, forKey: .floorCounts))
        self.totalFloors = (try? values.decode(Int.self, forKey: .totalFloors))
    }
    
}

class FloorCounts : Decodable{
    let apCount : Int?
    let floorName : String?
    enum CodingKeys: String, CodingKey {
        case apCount = "apCount"
        case floorName = "floorName"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.apCount = (try? values.decode(Int.self, forKey: .apCount))
        self.floorName = (try? values.decode(String.self, forKey: .floorName))
    }
}


extension mapJSON {
    func printAllMapInfo(){
        print("totalAps : \(totalAps ?? -1) ")
        print("totalBuildings : \(totalBuildings ?? -1) ")
        print("totalCampuses : \(totalCampuses ?? -1) ")
        print("totalFloors : \(totalFloors ?? -1) ")
        print("we have this many campuses \(campusCounts?.count ?? 0)")
        
        if let campuses = campusCounts{
            for campus in campuses {
                print(" ->campusName \(campus.campusName ?? "no campus name")")
                print(" ->totalBuildings \(campus.totalBuildings ?? -1)")
                print(" ->buildingCounts \(campus.buildingCounts?.count ?? -1)")
                if let buildings = campus.buildingCounts {
                    
                    for b in buildings {
                        print("   building name \(b.buildingName ?? "no building name")")
                        print("   totalFloors \(b.totalFloors ?? -1)")
                        print("   floorCounts nbr \(b.floorCounts?.count ?? -1)")
                        
                        if let floors = b.floorCounts {
                            for f in floors{
                                print("    * apCount \(f.apCount ?? -1)")
                                print("    * floorName \(f.floorName ?? "no floor name")")
                                print(" ")
                            }
                        }
                    }

                }
                print("==============================================")
                
            }
        }

    }
}


/*

{
    campusCounts = (
        {
            buildingCounts = "<null>";
            campusName = "UNIT.Factory";
            totalBuildings = 0;
        },
        {
            buildingCounts = (
                {
                    buildingName = "UNIT.Factory";
                    floorCounts =                     (
                        {
                            apCount = 5;
                            floorName = "1st_Floor";
                    },
                        {
                            apCount = 3;
                            floorName = "3rd_Floor";
                    },
                        {
                            apCount = 4;
                            floorName = "2nd_Floor";
                    }
                    );
                    totalFloors = 3;
                }
            );
            campusName = "System Campus";
            totalBuildings = 1;
        }
    );
    
    
    
    
    totalAps = 12;
    totalBuildings = 1;
    totalCampuses = 2;
    totalFloors = 3;
}
*/
