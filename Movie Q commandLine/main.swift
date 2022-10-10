//
//  main.swift
//  Movie Q commandLine
//
//  Created by Joey Rubin on 8/9/22.
//

import Foundation
import CSV

let stream = InputStream(fileAtPath: "/Users/joeyrubin/Downloads/top_movies.csv")!
let csv = try! CSVReader(stream: stream, hasHeaderRow: true)

struct TopMovie {
    
    var title: String
    var distributor: String
    var realeaseDate: String
    var salesUS: Int
    var salesWorld: String
    var runTime: String
    var rating: String
    
    init() {
        title           = csv["Title"] ?? "No Data"
        distributor     = csv["Distributor"] ?? "No Data"
        realeaseDate    = csv["Release Date"] ?? "No Data"
        salesUS         = Int(csv["US Sales"] ?? "No Data") ?? 0
        salesWorld      = csv["World Sales"] ?? "No Data"
        runTime         = csv["Runtime"] ?? "No Data"
        rating          = csv["Rating"] ?? "No Data"
    }
}

///Original Dictionary but moved to init inside STRUCT :
func makeTopMovieDict() -> [String: TopMovie] {
    var topMovieDictionary: [String: TopMovie] = [:]
    while csv.next() != nil {
        topMovieDictionary[csv["Title"] ?? ""] = TopMovie()
    }
    return topMovieDictionary
}

/// Distributor key, TopMovie() value works but slows my machine? Turns out to be a PLAYGROUND issue.
func getTopMovieDataByDistributor2() -> [String: [TopMovie]] {
    var distributorMovieDictionary: [String: [TopMovie]] = [:]
    while csv.next() != nil {
        distributorMovieDictionary[csv["Distributor"] ?? ""] = (distributorMovieDictionary[csv["Distributor"] ?? ""] ?? []) + [TopMovie()]
    }
    return distributorMovieDictionary
}
///TEST
func topMovieCount(forDistributor: String) {
    let dict = getTopMovieDataByDistributor2()
    print(dict[forDistributor]?.count ?? 0)
}

///TEST
func printDict() {
    let dict = getTopMovieDataByDistributor2()
    print("\(dict["Universal Pictures"]![0].title) \(dict["Universal Pictures"]![0].salesUS)")
}

///TEST
func getDomesticSalesUniversal() {
    let dict = getTopMovieDataByDistributor2()
    for movie in dict["Universal Pictures"]! {
        print(movie.salesUS)
    }
}

///Change US Sales int into currency
func numberToMoney(number: Int) -> String {
let bigNumber = number
let numberFormatter = NumberFormatter()
numberFormatter.numberStyle = .currency
guard let formattedNumber = numberFormatter.string(from: NSNumber(value: bigNumber)) else { return "no" }
return formattedNumber
}



//***** Question 2 ******
//What is the highest grossing moving from Universal Pictures, domestically?

///Build dict to have value be highest highest gropssing domestic move.
func TopMovieByDistributorDict() -> [String: TopMovie]  {
    var dict: [String: TopMovie] = [:]
    
    while csv.next() != nil {
        let currentMovie = TopMovie() //grabing all info w/init
        let distributor = csv["Distributor"] ?? "No Data"
        
        if (dict[distributor]?.salesUS ?? 0) < currentMovie.salesUS {
            dict[distributor] = currentMovie
        }
    }
    return dict
}

///func to solve problem
func getTopMovieByDistrubutor(distributor: String) {
    let dict = TopMovieByDistributorDict()
    let currency = numberToMoney(number: dict[distributor]?.salesUS ?? 0)
    print("\(dict[distributor]?.title ?? "No Data Found") \(currency)")
}
getTopMovieByDistrubutor(distributor: "Universal Pictures")

//top movie object to get us sales
//distributor for key
// check if dist and topmovie are in dict
//check is us sale is > us ssales in dict


