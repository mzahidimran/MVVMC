
//
//  MovieCatalogVM.swift
//  Test
//
//  Created by Muhammad Zahid Imran on 4/21/19.
//  Copyright © 2019 24. All rights reserved.
//

import Foundation
import Observable
import AlamofireImage


protocol MovieCatalogVMProtocol {
    
    /**
        VM is searching for string in MovieDB
    */
    
    var isSearching: Bool { get }
    
    /**
    Movie list next page available
    */
    
    var isNextPageAvailable:Bool { get }
    
    /**
    Filter movie list
    */
    
    var filter: String { get set }
    
    /**
        Movie data count
    */
    
    var moviesCount: Int { get }
    
    /**
        Movie VM at index
    */
    
    func movie(at index:Int) -> MovieVMProtocol
    
    /**
    Have data list updates dynamic, listen to this for updates
    */
    
    var moviesUpdated: ImmutableObservable<Bool> { get }
    
    /**
    Updates on error loading
    */
    
    var error: ImmutableObservable<Error?> { get }
    
    /**
    Updates on every new network request
    */
    
    var currentRequest: ImmutableObservable<NetworkRequest?> { get }
    
    /**
    Get videos list for page

    - Parameter page: Movie ID to fetch videos

    */
    
    func load(page:Int) -> Void
    
    /**
    Load next page 

    */
    
    func loadNextPage() -> Void
}


class MovieCatalogVM: MovieCatalogVMProtocol {
    
    private let repository: MovieRepositoryProtocol
    private var page: Int = 0
    private var total_results: Int = 0
    private var total_pages: Int = 0
    
    var filter: String = ""
    {
        didSet {
            applyFilter()
        }
    }
    
    var isSearching: Bool {
        get {
            return filter.count > 0
        }
    }
    
    var isNextPageAvailable:Bool {
        get {
            return page < total_pages
        }
    }
    
    var moviesCount: Int {
        return movies.count
    }
    
    private var source:[Movie] = [] {
        didSet {
            if filter.count == 0 {
                movies = source
            }
        }
    }
    
    private var movies:[Movie] = [] {
        didSet {
            _moviesUpdated.value = true
        }
    }
    
    private var _moviesUpdated:Observable<Bool> = Observable<Bool>(false)
    lazy var moviesUpdated: ImmutableObservable<Bool> = _moviesUpdated
    
    private var _error:Observable<Error?> = Observable<Error?>(nil)
    lazy var error: ImmutableObservable<Error?> = _error
    
    
    private var _currentRequest: Observable<NetworkRequest?> = Observable<NetworkRequest?>(nil)
    lazy var currentRequest: ImmutableObservable<NetworkRequest?> = _currentRequest
    
    init(repository: MovieRepositoryProtocol = RemoteMovieRepository()) {
        self.repository = repository
    }
    
    func loadNextPage() -> Void {
        if isSearching { return }
        load(page: page+1)
    }
    
    func movie(at index: Int) -> MovieVMProtocol  {
        return MovieVM(movie: movies[index])
    }
    
    func load(page:Int) -> Void {
        
        self._error.value = nil
        if _currentRequest.value == nil {
            self._currentRequest.value = repository.getPopular(page: page) {[weak self] (result:Pageable<Movie>?, error) in
                if let result = result {
                    self?.throttleImages(movies: result.results)
                    self?.source.append(contentsOf: result.results)
                    self?.total_results = result.total_results
                    self?.total_pages = result.total_pages
                    self?.page = result.page
                }
                else if let error = error {
                    self?._error.value = error
                }
                self?._currentRequest.value = nil
            }
        }
    }
    
    
    private func throttleImages(movies:[Movie]) {
        for movie in movies {
            if let url = URL(string: AppConstants.shared.IMAGE_REPO_BASE_URL + movie.backdrop_path)
            {
                ImageDownloader.default.download(URLRequest(url: url), completion: nil)
            }
        }
    }
    
    private func applyFilter(){
        if isSearching
        {
            self.movies = self.source.filter { $0.title.localizedCaseInsensitiveContains(filter) }
        }
        else {
            self.movies = self.source
        }
    }
    
    
}

