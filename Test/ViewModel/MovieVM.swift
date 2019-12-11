//
//  MovieDetailVM.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 4/22/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import UIKit
import Observable

protocol MovieVMProtocol {
    
    /**
    Movie overview dynamic object
    */
    
    var overview: ImmutableObservable<String> { get }
    
    /**
    Movie title dynamic object
    */
    
    var title:  ImmutableObservable<String> { get }
    
    /**
    Movie id dynamic object
    */
    
    var id: ImmutableObservable<Int> { get }
    
    /**
    Movie genre merged with comma (,)
    */
    
    var genre:  ImmutableObservable<String> { get }
    
    /**
    Movie release date dynamic object
    */
    
    var releaseDate: ImmutableObservable<String> { get }
    
    /**
    Movie bannerURL dynamic object
    */
    
    var bannerURl:  ImmutableObservable<URL?> { get }
    
    /**
    Called with true whenever VM have data updates, listen to this observer if you want immediate updates to UI
    */
    
    var hasDataUpdates: ImmutableObservable<Bool> { get }
    
    /**
    Called with error when ever there is an error loading data
    */
    
    var error: ImmutableObservable<Error?> { get }
    
    /**
    Called Videos list loaded
    */
    
    var videos: ImmutableObservable<[VideoModelProtocol]> { get }
    
    /**
    Called error loading videos
    */
    
    var errorVideos: ImmutableObservable<Error?> { get }
    
    /**
    Updates whenever VM have network request going on
    */
    
    var networkActivity: ImmutableObservable<Bool> { get }
    
    /**
    Load movie details

    */
    
    func load() -> Void
    
    /**
    Get videos list available for movie ID.

    */
    
    func loadVideos() -> Void
}


class MovieVM: MovieVMProtocol {
    
    private let repository: MovieRepositoryProtocol
    
    @Observable private var _videos:[VideoModelProtocol] = []
    lazy private(set) var videos: ImmutableObservable<[VideoModelProtocol]> = __videos
    
    @Observable private var _errorVideos:Error? = nil
    lazy private(set) var errorVideos: ImmutableObservable<Error?> = __errorVideos
    
    private var movie:MovieModelProtocol?
    {
        didSet {
            populateData()
        }
    }
    
    @Observable private var _hasDataUpdates:Bool = false
    lazy private(set) var hasDataUpdates: ImmutableObservable<Bool> = __hasDataUpdates
    
    @Observable private var _error:Error? = nil
    lazy private(set) var error: ImmutableObservable<Error?> = __error
    
    private let dateformatter = DateFormatter(withFormat: "dd.MM.yyyy", locale: "en_US")
    
    @Observable private var _networkActivity: Bool = false
    lazy private(set) var networkActivity: ImmutableObservable<Bool> = __networkActivity
    
    @Observable private var _overview:String = ""
    lazy private(set) var overview: ImmutableObservable<String> = __overview
    
    @Observable private var _title:String = ""
    lazy private(set) var title: ImmutableObservable<String> = __title
    
    @Observable private var _genre:String = ""
    lazy private(set) var genre: ImmutableObservable<String> = __genre
    
    @Observable private var _releaseDate:String = ""
    lazy private(set) var releaseDate: ImmutableObservable<String> = __releaseDate
    
    @Observable private var _id:Int = 0
    lazy private(set) var id: ImmutableObservable<Int> = __id
    
    @Observable private var _bannerURl:URL? = nil
    lazy private(set) var bannerURl: ImmutableObservable<URL?> = __bannerURl
   
    
    init(repository: MovieRepositoryProtocol = RemoteMovieRepository(), movie:MovieModelProtocol? = nil) {
        self.repository = repository
        self.movie = movie
        populateData()
    }
    
    func populateData() -> Void {
        _overview = movie?.overview ?? ""
        _title = movie?.title ?? ""
        _genre = movie?.genres.map { $0.name }.joined(separator: ", ") ?? ""
        _releaseDate = dateformatter.string(from: movie?.release_date ?? Date())
        _id = movie?.id ?? 0
        if let url = movie?.backdrop_path {
            _bannerURl = URL(string: AppConstants.shared.IMAGE_REPO_BASE_URL + url)
        }
        else {
            _bannerURl = nil
        }
        self._hasDataUpdates = true
    }
    
    func load() -> Void {
        self._error = nil
        if _networkActivity == false {
            self._networkActivity = true
            repository.getMovie(id:_id) {[weak self] (result:Movie?, error) in
                if let result = result {
                    self?.movie = result
                }
                else if let error = error {
                    self?._error = error
                }
                self?._networkActivity = false
            }
        }
    }
    
    
    func loadVideos() -> Void {
        let _ = repository.getVideos(id:_id) {[weak self] (result, error) in
            if let result = result {
                self?._videos = result.results
            }
            else if let error = error {
                self?._errorVideos = error
            }
        }
    }
    
}
