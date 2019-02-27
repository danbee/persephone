//
//  AlbumArtService.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/2/23.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

import Cocoa
import SwiftyJSON

class AlbumArtService: NSObject {
  static var shared = AlbumArtService()
  var session = URLSession(configuration: .default)

  func fetchAlbumArt(for album: AlbumItem, callBack: @escaping (_ image: NSImage) -> Void) {
    let artist = album.artist
    let title = album.title

    getArtworkFromMusicBrainz(artist: artist, title: title, callBack: callBack)
  }

  func getArtworkFromMusicBrainz(artist: String, title: String, callBack: @escaping (_ image: NSImage) -> Void) {
    if var urlComponents = URLComponents(string: "https://musicbrainz.org/ws/2/release/") {
      urlComponents.query = "query=artist:\(artist) AND release:\(title) AND country:US&limit=1&fmt=json"

      guard let searchURL = urlComponents.url
        else { return }

      print(searchURL)

      let releaseTask = session.dataTask(with: searchURL) { data, response, error in
        if let _ = error {
          return
        }

        guard let httpResponse = response as? HTTPURLResponse,
          (200...299).contains(httpResponse.statusCode) else {
            return
        }

        if let mimeType = httpResponse.mimeType, mimeType == "application/json",
          let data = data,
          let json = try? JSON(data: data) {

          let releaseId = json["releases"][0]["id"]
          let coverURL = URLComponents(string: "https://coverartarchive.org/release/\(releaseId)/front")
          print(coverURL)
          let coverArtTask = self.session.dataTask(with: coverURL!.url!) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                return
            }
            print(httpResponse.mimeType)
            if let mimeType = httpResponse.mimeType, mimeType == "image/jpeg",
              let data = data,
              let coverImage = NSImage(data: data) {

              callBack(coverImage)
            }
          }

          coverArtTask.resume()
        }
      }
      releaseTask.resume()
    }
  }
}
