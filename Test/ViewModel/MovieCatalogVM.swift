
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
    Updates on network activity to show loader
    */
    
    var networkActivity: ImmutableObservable<Bool> { get }
    
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
        return movies.elements.count
    }
    
    private var source:[Movie] = [] {
        didSet {
            movies.clean(andAppend: source) {[weak self] in
                DispatchQueue.main.async {
                    self?._moviesUpdated = true
                }
            }
        }
    }
    
    private var movies:ThreadSafeCollection<Movie> = ThreadSafeCollection<Movie>()
    
    @Observable private var _moviesUpdated:Bool = false
    lazy private(set) var moviesUpdated: ImmutableObservable<Bool> = __moviesUpdated
    
    @Observable private var _error:Error? = nil
    lazy private(set) var error: ImmutableObservable<Error?> = __error
    
    
    @Observable private var _networkActivity: Bool = false
    lazy private(set) var networkActivity: ImmutableObservable<Bool> = __networkActivity
    
    init(repository: MovieRepositoryProtocol = RemoteMovieRepository()) {
        self.repository = repository
    }
    
    func loadNextPage() -> Void {
        if isSearching { return }
        load(page: page+1)
    }
    
    func movie(at index: Int) -> MovieVMProtocol  {
        return MovieVM(movie: movies.elements[index])
    }
    
    func load(page:Int) -> Void {
        
        self._error = nil
        if _networkActivity == false {
            self._networkActivity = true
            repository.getPopular(page: page) {[weak self] (result:Pageable<Movie>?, error) in
                if let result = result {
                    self?.throttleImages(movies: result.results)
                    self?.source.append(contentsOf: result.results)
                    self?.total_results = result.total_results
                    self?.total_pages = result.total_pages
                    self?.page = result.page
                }
                else if let error = error {
                    self?._error = error
                }
                self?._networkActivity = false
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
            self.movies.clean(andAppend: self.source.filter { $0.title.localizedCaseInsensitiveContains(filter) }) {[weak self] in
                DispatchQueue.main.async {
                    self?._moviesUpdated = true
                }
            }
        }
        else {
            self.movies.clean(andAppend: self.source) { [weak self] in
                DispatchQueue.main.async {
                    self?._moviesUpdated = true
                }
            }
        }
    }
    
    
}

