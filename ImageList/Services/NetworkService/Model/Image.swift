//
//  Image.swift
//  ImageList
//
//  Created by Grigoriy Shilyaev on 30.08.23.
//

import Foundation

struct Image: Decodable {
    let albumId: Int
    let id: Int
    let title: String
    let url: URL
}
