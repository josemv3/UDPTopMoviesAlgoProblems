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
    var rating: Rating
    
    enum Rating: String {
        case G      = "G"
        case PG     = "PG"
        case PG13   = "PG-13"
        case R      = "R"
        case NA     = "NA"
    }
    
    
    init() {
        title           = csv["Title"] ?? "No Data"
        distributor     = csv["Distributor"] ?? "No Data"
        realeaseDate    = csv["Release Date"] ?? "No Data"
        salesUS         = Int(csv["US Sales"] ?? "No Data") ?? 0
        salesWorld      = csv["World Sales"] ?? "No Data"
        runTime         = csv["Runtime"] ?? "No Data"
        rating          = TopMovie.Rating(rawValue: csv["Rating"] ?? "No Data")!
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



//*************** Question 1 ****************
//What movies on this list were distributed by DreamWorks?

func getDreamworksMovies() {
    let topMovieDictionary = makeTopMovieDict()
    for (_, value) in topMovieDictionary {
        if value.distributor.contains("DreamWorks") {
            let currency = numberToMoney(number: value.salesUS)
            print("\(value.title) \(currency)")
        }
    }
}
//Uncomment line 96 for question 1 solve:
//getDreamworksMovies()



//*************** Question 2 ****************
//What is the highest grossing moving from Universal Pictures, domestically?

//Ideas for solving:
//top movie object to get us sales
//distributor for key
// check if dist and topmovie are in dict
//check is us sale is > us ssales in dict

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
//Uncomment line 128 for question 2 solve:
//getTopMovieByDistrubutor(distributor: "Universal Pictures")



//***** Question 3 ******
//What distributor has the most films on this list?

func distributorWithMostFilmsOnList() {
    var topMovieDictionary =  makeTopMovieDict()
    var distributorDict: [String: Int] = [:]
    
    for (_, value) in topMovieDictionary {
        if distributorDict.isEmpty {
            distributorDict[value.distributor] = 1
            continue
        }
        if distributorDict[value.distributor] == nil {
            distributorDict[value.distributor] = 1
        } else {
            distributorDict[value.distributor]! += 1
        }
    }
    var mostFilms = 0
    var distributor = ""
    
    for (key, value) in distributorDict {
        if mostFilms == 0 {
            mostFilms = value
            distributor = key
            continue
        }
        if value > mostFilms {
            mostFilms = value
            distributor = key
        }
    }
    print("\(distributor) \(mostFilms)")
}
//Uncomment line 170 for question 3 solve:
//distributorWithMostFilmsOnList()



//***** Question 4 ******
//What is the earliest year on this list, and what were the films from that year?

func getFirstYearTopMovies() {
    var topMovieDictionary =  makeTopMovieDict()
    var year = 0
    
    for (_, value) in topMovieDictionary {
        if year == 0 {
            year = Int(value.realeaseDate)!
            continue
        }
        if year > Int(value.realeaseDate)! {
            year = Int(value.realeaseDate)!
        }
    }
    for (_, value) in topMovieDictionary {
        if value.realeaseDate == String(year) {
            print(value.title)
        }
    }
    print((year))
}
//Uncomment line 197 for question 4 solve:
//getFirstYearTopMovies()



//***** Question 5 ******
//What is the distribution of ratings? (How many are PG, PG-13, R, etc.?)

func getRatingsDistribution() {
    var topMovieDictionary =  makeTopMovieDict()
    var ratingDict: [String: Int] = ["G": 0, "PG": 0, "PG-13": 0, "R": 0, "NA": 0]
    for (_, value) in topMovieDictionary {
        
        switch(value.rating.self) {
        case .G:
            ratingDict["G"]! += 1
        case .PG:
            ratingDict["PG"]! += 1
        case .PG13:
            ratingDict["PG-13"]! += 1
        case .R:
            ratingDict["R"]! += 1
        case .NA:
            ratingDict["NA"]! += 1
        }
    }
    print(ratingDict)
}
//Uncomment line 235 for question 4 solve:
//getRatingsDistribution()
