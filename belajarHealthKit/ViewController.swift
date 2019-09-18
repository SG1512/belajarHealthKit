//
//  ViewController.swift
//  belajarHealthKit
//
//  Created by Steven Gunawan on 17/09/19.
//  Copyright © 2019 Steven Gunawan. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {
    let healthStore = HKHealthStore()
    let sampleData = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkAvailability()
        getBMIData()
        //        checkAuthorization()
        // Do any additional setup after loading the view.
    }
    
    
    func checkAvailability(){
        if HKHealthStore.isHealthDataAvailable(){
            let allTypes = Set([HKObjectType.workoutType(),
                                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                HKObjectType.quantityType(forIdentifier: .heartRate)!,
                                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                                HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!])
            
            healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
                if !success { print ("error")
                }
            }
        }
    }
    
    
    func getBMIData() {
        let heartRateUnit:HKUnit = HKUnit(from: "count/min")
        let limit = 10
//        let calendar = NSCalendar.current
//        let now = NSDate()
//        let components = calendar.dateComponents([.year, .month, .day], from: now as Date)
        
        let startDate = Date.distantPast
        let sortDescriptors = [
            NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        ]
        
        let endDate = Date()
//        guard let startDate = calendar.date(from: components) else {
//            fatalError("*** Unable to create the start date ***")
//        }
//
//        let endDate = calendar.date(byAdding: components, to: startDate)
        
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .heartRate) else {
            fatalError("*** This method should never fail ***")
        }
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictEndDate)
        
        let sampleQuery = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: limit, sortDescriptors: sortDescriptors) {
            query, results, error in
            
            guard let samples = results as? [HKQuantitySample] else {
                fatalError("An error occured fetching the user's tracked food. In your app, try to handle this error gracefully. The error was: \(error?.localizedDescription)");
            }
            
            DispatchQueue.main.async {
                //                self.sampleData.removeAll()
                //
                //                guard let foodName = sample.metadata?[HKMetadataKeyFoodType] as? String else {
                //                    // if the metadata doesn't record the food type, just skip it.
                //                    break
                //                }
                for sample in samples {
                    let bmi = sample.quantity.doubleValue(for: heartRateUnit)
                    print("\(bmi)")
                    //                self.sampleData.append("\(bmi)")
                    
                }
                
            }
            
        }
        self.healthStore.execute(sampleQuery)
        
    }
    
    
    
    //
    //
    
    
    
    //                    let foodItem = sample.quantity.doubleValueForUnit(HKUnit)
    //
    //                    AAPLFoodItem.foodItemWithName(foodName, joules: joules)
    
    //                    foodItems.append(foodItem)
    //                }
    //
    //                tableView.reloadData()
    //    func checkAuthorization() {
    //        if HKAuthorizationStatus.notDetermined {
    //            HKError.Code.errorAuthorizationNotDetermined
    //        } else if HKAuthorizationStatus.sharingDenied {
    //            HKError.Code.errorRequiredAuthorizationDenied
    //        }
    //
    //    }
    
}

