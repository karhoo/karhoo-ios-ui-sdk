//
//  KarhooAsyncImage.swift
//  KarhooUISDK
//
//  Created by Diana Petrea on 24.11.2022.
//  Copyright © 2022 Flit Technologies Ltd. All rights reserved.
//

import Foundation
import SwiftUI

struct KarhooAsyncImage: View {
    var urlString: String
    var frame: CGRect = CGRect(
        x: CGFloat.zero,
        y: CGFloat.zero,
        width: UIConstants.Dimension.Icon.standard,
        height: UIConstants.Dimension.Icon.standard
    )
    
    @ObservedObject var imageLoader = ImageLoaderService()
    @State var image: UIImage = UIImage()
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: frame.width, height: frame.height)
            .onReceive(imageLoader.$image) { image in
                self.image = image
            }
            .onAppear {
                imageLoader.loadImage(for: urlString)
            }
    }
}

class ImageLoaderService: ObservableObject {
    @Published var image: UIImage = UIImage()
    
    func loadImage(for urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.image = UIImage(data: data) ?? UIImage()
            }
        }
        task.resume()
    }
}
