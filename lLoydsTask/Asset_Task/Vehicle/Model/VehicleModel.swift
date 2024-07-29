//
//  VehicleModel.swift
//  Asset_Task
//
//  Created by Anasurya on 7/25/24.
//

import Foundation

struct VehicleModel: Decodable{
    let status: Int?
    let vehicle_type,vehicle_capacity, vehicle_make, manufacture_year,fuel_type : [Vehicle]?
}
struct Vehicle: Decodable{
    let text: String?
    let value: Int?
}

struct SendParameters: Encodable{
    var clientid:Int
    var enterprise_code:Int
    var mno: String
    var passcode: Int
}
