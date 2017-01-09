//
//  MainLogicManager.swift
//  RelationFamily
//
//  Created by Nikita Gil on 07.01.17.
//  Copyright © 2017 Nikita Gil. All rights reserved.
//

import Foundation

class MainLogicManager {
    
    var possibilities: [String : Int]?
    var inLaw = ""
    
    init() {
       self.loadPossibilities()
    }
    
    private func loadPossibilities() {
         possibilities = ["Father":1, "father":1, "Dad":1, "dad":1, "Mother":2, "mother":2, "mom":2, "Mom":2, "Brother":3, "Sister":4, "Uncle":5, "Son":6, "Daughter":7, "Grandfather":8, "Grandmother":9, "Aunt":10, "First Cousin":11, "Cousin":11, "Nephew":12, "Niece":13, "Grandson":14, "Granddaughter":15, "Me":16]
    }
    
    private func convertPossibilities(x: String, y:String) ->String {
        // x - column row - y
        guard let xCell = possibilities?[x], let yCell = possibilities?[y] else {
            return ""
        }
        
        let array: [[String]]? = XSLDataSourceManger.sharedInstance.simpleChartArray
        
        guard let tmpRowArray = array?[yCell] else {
            return ""
        }
        
        var relation = ""
        if xCell < tmpRowArray.count {
            relation = tmpRowArray[xCell]
        }
        return relation
    }
    
    func convertPossibilitiesBase(x: String, y:String, name1: String, name2: String) ->String {
        // x - column row - y
        guard let xCell = possibilities?[x], let yCell = possibilities?[y] else {
            return ""
        }
        
        let array: [[String]]? = XSLDataSourceManger.sharedInstance.baseChartArray
        
        guard let tmpRowArray = array?[yCell] else {
            return ""
        }
        
        var relation = ""
        if xCell < tmpRowArray.count {
            relation = tmpRowArray[xCell]
        }
        
        let final = name1 + " is " + name2 + "'s " + relation + " " + inLaw
        
        return final
    }

    func parseUser(p1: String) -> String {
        var newP1 = p1
        inLaw = ""
        if p1.contains("in law") {
            newP1 = newP1.replacingOccurrences(of: "in law", with: "")
            inLaw = "In Law"
        } else if newP1.contains("in-law") {
            newP1 = newP1.replacingOccurrences(of: "in-law", with: "")
            inLaw = "In Law"
        } else if newP1.contains("In-Law") {
            newP1 = newP1.replacingOccurrences(of: "In-Law", with: "")
            inLaw = "In Law"
        } else if newP1.contains("in-Law") {
            newP1 = newP1.replacingOccurrences(of: "in-Law", with: "")
            inLaw = "In Law"
        } else if newP1.contains("In law") {
            newP1 = newP1.replacingOccurrences(of: "In law", with: "")
            inLaw = "In Law"
        } else if newP1.contains("In Law") {
            newP1 = newP1.replacingOccurrences(of: "In Law", with: "")
            inLaw = "In Law"
        } else if newP1.contains("in Law") {
            newP1 = newP1.replacingOccurrences(of: "in Law", with: "")
            inLaw = "In Law"
        } else if newP1.contains("In law") {
            newP1 = newP1.replacingOccurrences(of: "In law", with: "")
            inLaw = "In Law"
        } else if newP1.contains("In-law") {
            newP1 = newP1.replacingOccurrences(of: "In-law", with: "")
            inLaw = "In Law"
        }
        
        if newP1.contains("Husband") {
            newP1 = newP1.replacingOccurrences(of: "Husband", with: "Me")
            inLaw = "In Law"
        } else if newP1.contains("husband") {
            newP1 = newP1.replacingOccurrences(of: "husband", with: "Me")
            inLaw = "In Law"
        }
 
        if newP1.contains("Wife") {
            newP1 = p1.replacingOccurrences(of: "Wife", with: "Me")
            inLaw = "In Law"
        } else if newP1.contains("wife") {
            newP1 = newP1.replacingOccurrences(of: "wife", with: "Me")
            inLaw = "In Law"
        }
    
        if newP1.components(separatedBy: "'s ").count == 2 {
            let splitedString = newP1.components(separatedBy: "'s ")
            let relation = convertPossibilities(x: splitedString[0], y: splitedString[1])
            return relation + " " + inLaw
        }

        if newP1.components(separatedBy: "'s ").count == 3 {
            let splitedString = newP1.components(separatedBy: "'s ")
            let relation1 = convertPossibilities(x: splitedString[0], y: splitedString[1])
            let relation2 = convertPossibilities(x: relation1, y: splitedString[2])
            return relation2 + " " + inLaw
        }
        
        if newP1.components(separatedBy: "'s ").count == 4 {
            let splitedString = newP1.components(separatedBy: "'s ")
            let relation1 = convertPossibilities(x: splitedString[0], y: splitedString[1])
            let relation2 = convertPossibilities(x: relation1, y: splitedString[2])
            let relation3 = convertPossibilities(x: relation2, y: splitedString[3])
            return relation3 + " " + inLaw
        }

        if newP1.components(separatedBy: "'s ").count == 5 {
            let splitedString = newP1.components(separatedBy: "'s ")
            let relation1 = convertPossibilities(x: splitedString[0], y: splitedString[1])
            let relation2 = convertPossibilities(x: relation1, y: splitedString[2])
            let relation3 = convertPossibilities(x: relation2, y: splitedString[3])
            let relation4 = convertPossibilities(x: relation3, y: splitedString[4])
            return relation4 + " " + inLaw
        }

        return newP1
    }
}
