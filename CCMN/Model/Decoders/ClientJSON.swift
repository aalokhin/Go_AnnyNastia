//
//  ClientJSON.swift
//  CCMN
//
//  Created by ANASTASIA on 8/27/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation

class ClientJSON : Decodable {
    let apMacAddress : String?
    let macAddress : String?
    let manufacturer : String?
    let mapCoordinate : MapCoordinate?
    let userName : String?
    let mapInfo : MapInfo
    
    enum CodingKeys: String, CodingKey {
        case apMacAddress = "apMacAddress"
        case macAddress = "macAddress"
        case manufacturer = "manufacturer"
        case mapCoordinate = "mapCoordinate"
        case userName = "userName"
        case mapInfo = "mapInfo"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.apMacAddress = (try? values.decode(String.self, forKey: .apMacAddress))
        self.macAddress = (try? values.decode(String.self, forKey: .macAddress))
        self.manufacturer = (try? values.decode(String.self, forKey: .manufacturer))
        self.userName = (try? values.decode(String.self, forKey: .userName))
        self.mapCoordinate = (try? values.decode(MapCoordinate.self, forKey: .mapCoordinate))
        self.mapInfo = (try! values.decode(MapInfo.self, forKey: .mapInfo))

    }
}
class ImageJSON : Decodable{
    let colorDepth : Int?
    let height : Int?
    let imageName : String?
    let maxResolution : Int?
    let size : Int?
    let width : Int?
    let zoomLevel : Int?
    
    enum CodingKeys: String, CodingKey {
        case colorDepth = "colorDepth"
        case height = "height"
        case imageName = "imageName"
        case maxResolution = "maxResolution"
        case size = "size"
        case width = "width"
        case zoomLevel = "zoomLevel"
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.imageName = (try? values.decode(String.self, forKey: .imageName))
        self.colorDepth = (try? values.decode(Int.self, forKey: .colorDepth))
        self.height = (try? values.decode(Int.self, forKey: .height))
        self.size = (try? values.decode(Int.self, forKey: .size))
        self.width = (try? values.decode(Int.self, forKey: .width))
        self.zoomLevel = (try? values.decode(Int.self, forKey: .zoomLevel))
        self.maxResolution = (try? values.decode(Int.self, forKey: .maxResolution))
        
    }
    
}
/*
image =             {
    colorDepth = 8;
    height = 897;
    imageName = "domain_4_1511041548007.png";
    maxResolution = 8;
    size = 1765;
    width = 1765;
    zoomLevel = 4;
};
*/
class MapInfo : Decodable {
    //let floorDimension
    let floorRefId : String?
    let image : ImageJSON
    let mapHierarchyString : String?
    
    enum CodingKeys: String, CodingKey {
        case floorRefId = "floorRefId"
        case mapHierarchyString = "mapHierarchyString"
        case image = "image"

    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.floorRefId = (try? values.decode(String.self, forKey: .floorRefId))
        self.mapHierarchyString = (try? values.decode(String.self, forKey: .mapHierarchyString))
        self.image =  (try! values.decode(ImageJSON.self, forKey: .image))

        
    }
}


/*
mapInfo =         {
    floorDimension = {
        height = 10;
        length = 771;
        offsetX = 0;
        offsetY = 0;
        unit = FEET;
        width = 1551;
    };
    floorRefId = 735495909441273979;
    image =             {
        colorDepth = 8;
        height = 1126;
        imageName = "domain_4_1513769867616.png";
        maxResolution = 16;
        size = 2216;
        width = 2216;
        zoomLevel = 5;
    };
    mapHierarchyString = "System Campus>UNIT.Factory>2nd_Floor>Coverage Area_2nd_Floor";
};

*/



class  MapCoordinate : Decodable {
    
    let unit : String?
    let x : Double?
    let y : Double?
    let z : Double?
    
    enum CodingKeys: String, CodingKey {
        case unit = "unit"
        case x = "x"
        case y = "y"
        case z = "z"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.unit = (try? values.decode(String.self, forKey: .unit))
        self.x = (try? values.decode(Double.self, forKey: .x))
        self.y = (try? values.decode(Double.self, forKey: .y))
        self.z = (try? values.decode(Double.self, forKey: .z))
    }
    
}

extension ClientJSON {
    func printAll(){
        print("ClientJSON ----------------------------------------------")
        print(apMacAddress ?? "ap mac address couldnt' be decoded", macAddress ?? "macAddress couldnt' be decoded", manufacturer ?? "manufacturer couldnt' be decoded", userName ?? "userName couldnt' be decoded")
        print(mapCoordinate?.unit ?? "mapCoordinate.unit couldn't be decoded", mapCoordinate?.x ?? -1, mapCoordinate?.y ?? -1, mapCoordinate?.z ?? -1)
        print("----------------------------------------------")
    }
}

/* {
        apMacAddress = "a0:23:9f:1b:d9:20";
        areaGlobalIdList =         (
            11,
            3,
            2,
            1,
            23,
            24,
            6,
            7
        );
        band = "IEEE_802_11_B";
        bytesReceived = 0;
        bytesSent = 0;
        changedOn = 1566906851413;
        confidenceFactor = 64;
        currentlyTracked = 1;
        detectingControllers = "10.51.1.240";
        dot11Status = ASSOCIATED;
        geoCoordinate = "<null>";
        guestUser = 0;
        historyLogReason = "DISTANCE_CHANGE";
        ipAddress = "<null>";
        locComputeType = RSSI;
        macAddress = "fc:53:9e:a6:5e:b4";
        manufacturer = "Shanghai Wind Technologies Co.,Ltd";
        mapCoordinate =         {
            unit = FEET;
            x = "628.96";
            y = "476.45877";
            z = 0;
        };
        mapInfo =         {
            floorDimension =             {
                height = 10;
                length = 771;
                offsetX = 0;
                offsetY = 0;
                unit = FEET;
                width = 1551;
            };
            floorRefId = 735495909441273878;
            image =             {
                colorDepth = 8;
                height = 897;
                imageName = "domain_4_1511041548007.png";
                maxResolution = 8;
                size = 1765;
                width = 1765;
                zoomLevel = 4;
            };
            mapHierarchyString = "System Campus>UNIT.Factory>1st_Floor>Coverage_Area-First_Floor";
        };
        networkStatus = ACTIVE;
        rawLocation =         {
            rawX = "-999";
            rawY = "-999";
            unit = FEET;
        };
        sourceTimestamp = "<null>";
        ssId = "UNIT Factory (student) Legacy";
        statistics =         {
            currentServerTime = "2019-08-27T14:54:21.264+0300";
            firstLocatedTime = "2019-08-27T14:54:05.379+0300";
            lastLocatedTime = "2019-08-27T14:54:11.413+0300";
            maxDetectedRssi =             {
                antennaIndex = 0;
                apMacAddress = "a0:23:9f:1b:d9:20";
                band = "IEEE_802_11_B";
                lastHeardInSeconds = 4;
                rssi = "-73";
                slot = 0;
            };
        };
        userName = "";
    }
 */
