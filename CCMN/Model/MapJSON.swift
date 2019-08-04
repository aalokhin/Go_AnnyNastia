//
//  MapJSON.swift
//  CCMN
//
//  Created by Anastasiia ALOKHINA on 8/4/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation

/*
 {
    campusCounts =(
            {
                buildingCounts = "<null>";
                campusName = "UNIT.Factory";
                totalBuildings = 0;
                },
            {
                buildingCounts =             (
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
class mapJSON : Decodable {
    //let campusCounts : CampusCounts
    
    let totalAps : Int?
    let totalBuildings : Int?
    let totalCampuses : Int?
    let totalFloors : Int?
    
    enum CodingKeys: String, CodingKey {
        case totalAps = "totalAps"
        case totalBuildings = "totalBuildings"
        case totalCampuses = "totalCampuses"
        case totalFloors = "totalFloors"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.totalAps = (try? values.decode(Int.self, forKey: .totalAps))
        self.totalBuildings = (try? values.decode(Int.self, forKey: .totalAps))
        self.totalCampuses = (try? values.decode(Int.self, forKey: .totalAps))
        self.totalFloors = (try? values.decode(Int.self, forKey: .totalAps))
    }
}


class CampusCounts : Decodable {
}
