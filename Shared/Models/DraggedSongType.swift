//
//  DraggedSongType.swift
//  Persephone
//
//  Created by Daniel Barber on 2019/6/21.
//  Copyright © 2019 Dan Barber. All rights reserved.
//

enum DraggedSongType {
  case queueItem(Int)
  case albumSongItem(String)
}

private enum Discriminator: Int, Codable {
  case queueItem
  case albumSongItem
}

extension DraggedSongType: Codable {
  enum CodingKeys: String, CodingKey {
    case type
    case value
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    switch self {
    case let .queueItem(queuePos):
      try container.encode(Discriminator.queueItem, forKey: .type)
      try container.encode(queuePos, forKey: .value)
    case let .albumSongItem(uri):
      try container.encode(Discriminator.albumSongItem, forKey: .type)
      try container.encode(uri, forKey: .value)
    }
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let type = try container.decode(Discriminator.self, forKey: .type)
    switch type {
    case .queueItem:
      let queuePos = try container.decode(Int.self, forKey: .value)
      self = .queueItem(queuePos)
    case .albumSongItem:
      let uri = try container.decode(String.self, forKey: .value)
      self = .albumSongItem(uri)
    }

  }
}
