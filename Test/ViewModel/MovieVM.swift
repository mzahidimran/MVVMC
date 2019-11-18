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
    
    private var _videos:Observable<[VideoModelProtocol]> = Observable<[VideoModelProtocol]>([])
    lazy var videos: ImmutableObservable<[VideoModelProtocol]> = _videos
    
    private var _errorVideos:Observable<Error?> = Observable<Error?>(nil)
    lazy var errorVideos: ImmutableObservable<Error?> = _errorVideos
    
    private var movie:MovieModelProtocol?
    {
        didSet {
            populateData()
        }
    }
    
    private var _hasDataUpdates:Observable<Bool> = Observable<Bool>(false)
    lazy var hasDataUpdates: ImmutableObservable<Bool> = _hasDataUpdates
    
    private var _error:Observable<Error?> = Observable<Error?>(nil)
    lazy var error: ImmutableObservable<Error?> = _error
    
    private let dateformatter = DateFormatter(withFormat: "dd.MM.yyyy", locale: "en_US")
    
    private var _networkActivity: Observable<Bool> = Observable<Bool>(false)
    lazy var networkActivity: ImmutableObservable<Bool> = _networkActivity
    
    private var _overview:Observable<String> = Observable<String>("")
    lazy var overview: ImmutableObservable<String> = _overview
    
    private var _title:Observable<String> = Observable<String>("")
    lazy var title: ImmutableObservable<String> = _title
    
    private var _genre:Observable<String> = Observable<String>("")
    lazy var genre: ImmutableObservable<String> = _genre
    
    private var _releaseDate:Observable<String> = Observable<String>("")
    lazy var releaseDate: ImmutableObservable<String> = _releaseDate
    
    private var _id:Observable<Int> = Observable<Int>(0)
    lazy var id: ImmutableObservable<Int> = _id
    
    private var _bannerURl:Observable<URL?> = Observable<URL?>(nil)
    lazy var bannerURl: ImmutableObservable<URL?> = _bannerURl
   
    
    init(repository: MovieRepositoryProtocol = RemoteMovieRepository(), movie:MovieModelProtocol? = nil) {
        self.repository = repository
        self.movie = movie
        populateData()
    }
    
    func populateData() -> Void {
        _overview.value = movie?.overview ?? ""
        _title.value = movie?.title ?? ""
        _genre.value = movie?.genres.map { $0.name }.joined(separator: ", ") ?? ""
        _releaseDate.value = dateformatter.string(from: movie?.release_date ?? Date())
        _id.value = movie?.id ?? 0
        if let url = movie?.backdrop_path {
            _bannerURl.value = URL(string: AppConstants.shared.IMAGE_REPO_BASE_URL + url)
        }
        else {
            _bannerURl.value = nil
        }
        self._hasDataUpdates.value = true
    }
    
    func load() -> Void {
        self._error.value = nil
        if _networkActivity.value == false {
            self._networkActivity.value = true
            repository.getMovie(id:id.value) {[weak self] (result:Movie?, error) in
                if let result = result {
                    self?.movie = result
                }
                else if let error = error {
                    self?._error.value = error
                }
                self?._networkActivity.value = false
            }
        }
    }
    
    
    func loadVideos() -> Void {
        let _ = repository.getVideos(id:id.value) {[weak self] (result, error) in
            if let result = result {
                self?._videos.value = result.results
            }
            else if let error = error {
                self?._errorVideos.value = error
            }
        }
    }
    
}
