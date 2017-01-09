//
//  XSLDataSourceManger.swift
//  RelationFamily
//
//  Created by Nikita Gil on 07.01.17.
//  Copyright © 2017 Nikita Gil. All rights reserved.
//

import Foundation
import CSV

private enum CsvFiles: String {
    case Relationship_Chart = "Relationship_Chart"
    case Relationship_Chart_Simplification = "Relationship_Chart_Simplification"
}

class XSLDataSourceManger {
    static let sharedInstance = XSLDataSourceManger()
    
    var baseChartArray = [[String]]()
    var simpleChartArray = [[String]]()
    
    init() {
        guard let csvPathBase = readDataFromFile(file: CsvFiles.Relationship_Chart.rawValue),
              let csvPathSimple = readDataFromFile(file: CsvFiles.Relationship_Chart_Simplification.rawValue)
        else { return }
        
        guard let baseChartArrayTmp = loadArray(filePath: csvPathBase) ,
            let simpleChartArrayTmp = loadArray(filePath: csvPathSimple)
            else { return }
        
        self.baseChartArray = baseChartArrayTmp
        self.simpleChartArray = simpleChartArrayTmp
    }
    
    func readDataFromFile(file:String)-> String? {
        guard let filepath = Bundle.main.path(forResource: file, ofType: "csv")
            else {
                return nil
        }
        return filepath
    }
    
    private func loadArray(filePath: String) -> [[String]]? {
        
        var twoDArray = [[String]]()
        let stream = InputStream(fileAtPath: filePath)
        
        for row in try! CSV(stream: stream!) {
            var fullRowString = ""
            for item in row {
                fullRowString += item
            }
            
            let tmpArray: [String] = fullRowString.components(separatedBy: ";")
            twoDArray.append(tmpArray)
//            print("\(row)")
        }
        return twoDArray
    }
}

