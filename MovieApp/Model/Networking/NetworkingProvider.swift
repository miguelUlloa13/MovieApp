//
//  NetworkingProvider.swift
//  MovieApp
//
//  Created by Miguel Angel Bric Ulloa on 03/04/23.
//

import Foundation
import UIKit


    // Clase con patron de diseño Singleton
final class NetworkingProvider {
    
    // MARK: Properties
    
    public static let shared = NetworkingProvider()
    private let urlSession = URLSession.shared
    
    private let baseUrl = "https://api.themoviedb.org/3/trending/all/day?api_key="
    private let apiKey = "8aac87bc8d3173aeaac20e0e7d15f84c"
    // private let baseUrl = URL(string: "https://api.themoviedb.org/3/trending/all/day?api_key=8aac87bc8d3173aeaac20e0e7d15f84c")
    private let urlToImages = "https://image.tmdb.org/t/p/original/"
    
    private init() {}
    
    
    func getMovies(completion: @escaping (MovieResponseDataModel) -> Void) {
    
        let urlWithApiKey = URL(string: "https://api.themoviedb.org/3/trending/all/day?api_key=\(apiKey)")
        guard let url = urlWithApiKey else {
            print("Invalid URL")
            return
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ocurrio un error: \(error.localizedDescription)")
            }
            if let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                
                do {
                    let jsonRes = try JSONDecoder().decode(MovieResponseDataModel.self, from: data)
                    completion(jsonRes) // se llama al completion Handler (closure) cuando se finalizo la ejecucion getMovies
                }catch {
                    print("Error parsing")
                }
                
            }
        }.resume()
        
    }
    
    
}


extension UIImageView {
    // Metodo para desplegar imagenes a partir de una url
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
