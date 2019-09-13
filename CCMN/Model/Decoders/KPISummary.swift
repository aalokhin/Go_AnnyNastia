//
//  KPISummary.swift
//  CCMN
//
//  Created by ANASTASIA on 8/15/19.
//  Copyright © 2019 Anastasiia ALOKHINA. All rights reserved.
//

import Foundation


class kpiSummaryJSON : Decodable {
    
    let averageDwell : Double?
    let averageDwellByLevels : [String : AveragegDwellByLevels]?
    
    let connectedPercentage : Int?
    let conversionRate : Int?
    let topManufacturers : TopManufacturers?
    
    let totalConnectedCount : Int?
    let totalPasserbyCount : Int?
    let totalVisitorCount : Int?
    let visitorCount : Int?
    let peakSummary : PeakSummary?
    
    enum CodingKeys: String, CodingKey {
        case averageDwell = "averageDwell"
        case averageDwellByLevels = "averageDwellByLevels"
        case connectedPercentage = "connectedPercentage"
        case conversionRate = "conversionRate"
        case totalConnectedCount = "totalConnectedCount"
        case totalPasserbyCount = "totalPasserbyCount"
        case totalVisitorCount = "totalVisitorCount"
        case visitorCount = "visitorCount"
        case topManufacturers = "topManufacturers"
        case peakSummary = "peakSummary"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.averageDwell = (try? values.decode(Double.self, forKey: .averageDwell))
        
        //self.averageDwellByLevels
        self.averageDwellByLevels = (try? values.decode( [String : AveragegDwellByLevels].self, forKey: .averageDwellByLevels))
        self.connectedPercentage = (try? values.decode(Int.self, forKey: .connectedPercentage))
        self.conversionRate = (try? values.decode(Int.self, forKey: .conversionRate))
        self.totalConnectedCount = (try? values.decode(Int.self, forKey: .totalConnectedCount))
        self.totalPasserbyCount = (try? values.decode(Int.self, forKey: .totalPasserbyCount))
        self.totalVisitorCount = (try? values.decode(Int.self, forKey: .totalVisitorCount))
        self.visitorCount = (try? values.decode(Int.self, forKey: .visitorCount))
        self.topManufacturers = (try? values.decode(TopManufacturers.self, forKey: .topManufacturers))
        self.peakSummary = (try? values.decode(PeakSummary.self, forKey: .peakSummary))
    }
    
    
}

extension kpiSummaryJSON {
    func prinAll(){
        print("averageDwell \(averageDwell ?? -1)")
        if let avg = averageDwellByLevels{
            
            
            for one in avg {
                print(one.key)
                print("averageDwellByLevels \(one.value.average ?? -1)")
                print("averageDwellByLevels \(one.value.count ?? -1)")
            }
        }
        
        print("connectedPercentage \(connectedPercentage ?? -1)")
        
        print("conversionRate \(conversionRate ?? -1)")
        print("totalConnectedCount \(totalConnectedCount ?? -1)")
        print("totalPasserbyCount \(totalPasserbyCount ?? -1)")
        print("totalVisitorCount \(totalVisitorCount ?? -1)")
        print("visitorCount \(visitorCount ?? -1)")
        print("top manuf ", topManufacturers?.name)
        print("peakSummary", peakSummary?.peakHour)
        
        
    }
}

class AveragegDwellByLevels : Decodable {
    let average : Double?
    let count : Int?
    
    enum CodingKeys: String, CodingKey {
        case average = "average"
        case count = "count"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.average = (try? values.decode(Double.self, forKey: .average))
        self.count = (try? values.decode(Int.self, forKey: .count))
    }
}

/*
 averageDwellByLevels =     {
 "EIGHT_PLUS_HOURS" =         {
 average = "1233.152943840581";
 count = 957;
 };
 "FIVE_TO_EIGHT_HOURS" =         {
 average = "146.6204710144928";
 count = 209;
 };
 "FIVE_TO_THIRTY_MINUTES" =         {
 average = "2.796491691807478";
 count = 96861;
 };
 "ONE_TO_FIVE_HOURS" =         {
 average = "125.74465077872";
 count = 1523;
 };
 "THIRTY_TO_SIXTY_MINUTES" =         {
 average = "38.1410234932795";
 count = 6114;
 };
 };
 
 
 {
 averageDwell = 13;
 averageDwellByLevels =     {
 "EIGHT_PLUS_HOURS" =         {
 average = 659;
 count = 2;
 };
 "FIVE_TO_EIGHT_HOURS" =         {
 average = 0;
 count = 0;
 };
 "FIVE_TO_THIRTY_MINUTES" =         {
 average = "0.8703703703703703";
 count = 108;
 };
 "ONE_TO_FIVE_HOURS" =         {
 average = 0;
 count = 0;
 };
 "THIRTY_TO_SIXTY_MINUTES" =         {
 average = 31;
 count = 1;
 };
 };
 connectedPercentage = 97;
 conversionRate = 19;
 peakMonthSummary = "<null>";
 peakSummary =     {
 averageHourlyCount = 0;
 hourlyCounts = "<null>";
 interval = "<null>";
 maxDay = 0;
 maxHour = "-1";
 peakDate = "<null>";
 peakDayCount = 0;
 peakHour = 10;
 peakHourCount = 64;
 peakHourDay = "2019-08-15";
 peakWeek = 0;
 };
 peakWeekSummary = "<null>";
 topManufacturers =     {
 avgManufacturerCounts =         {
 Apple = 4;
 "Hon Hai Precision" = 1;
 "Huaqin Telecom Technology Co.,Ltd" = 0;
 Liteon = 0;
 Samsung = 1;
 };
 count = 19;
 manufacturerCounts =         {
 Apple = 19;
 "Hon Hai Precision" = 3;
 "Huaqin Telecom Technology Co.,Ltd" = 2;
 Liteon = 2;
 Samsung = 4;
 };
 name = Apple;
 };
 totalConnectedCount = 108;
 totalPasserbyCount = 489;
 totalVisitorCount = 111;
 visitorCount = 111;
 }
 */


class TopManufacturers : Decodable {
    let name : String?
    enum CodingKeys: String, CodingKey {
        case name = "name"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (try? values.decode(String.self, forKey: .name))
    }
    
    
}


class PeakSummary : Decodable{
    let peakHour : Int?
    enum CodingKeys: String, CodingKey {
        case peakHour = "peakHour"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.peakHour = (try? values.decode(Int.self, forKey: .peakHour))
    }
    
}
