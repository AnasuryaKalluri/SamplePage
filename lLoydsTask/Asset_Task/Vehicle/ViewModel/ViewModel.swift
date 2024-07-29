//
//  ViewModel.swift
//  Asset_Task
//
//  Created by Anasurya on 7/25/24.
//

import Foundation

class VehicleViewModel: NSObject{
    func getVehicleDetails(completion: @escaping(_ vehicle: VehicleModel?, _ error: String?)->Void){
        let user = SendParameters(clientid: 11, enterprise_code: 1007, mno: "9889897789", passcode: 3476)
        API_HANDLER.getParse(urlString: APP_URL.URL, parameters: user) { (result: Result<VehicleModel, APIError>) in
            switch result {
            case .success(let success):
                completion(success, nil)
            case .failure(let failure):
                completion(nil, failure.description)
            }
        }
    }
}

struct APP_URL{
    static let URL = "http://103.123.173.50:8080/jhsmobileapi/mobile/configure/v1/task"
}
