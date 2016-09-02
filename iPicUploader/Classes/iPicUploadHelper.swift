//
//  iPicUploadHelper.swift
//  iPicUploadImageDemo
//
//  Created by Jason Zheng on 8/31/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Cocoa

public class iPicUploadHelper {
  
  // MARK: Static Method
  
  static func isiPicRunning() -> Bool {
    // TODO
    return false
  }
  
  static func launchiPic() -> Bool {
    // TODO
    guard !isiPicRunning() else {
      return true
    }
    
    return true
  }
  
  static func generateiPicImage(imageFilePath: String) -> (iPicImage?, NSError?) {
    guard let data = NSData(contentsOfFile: imageFilePath) else {
      return (nil, iPicUploadError.FileInaccessable)
    }
    
    guard let _ = NSImage(data: data) else {
      return (nil, iPicUploadError.NotImageFile)
    }
    
    let image = iPicImage(imageFilePath: imageFilePath)
    image.imageData = data
    
    return (image, nil)
  }
  
  static func generateiPicImage(image: NSImage) -> (iPicImage?, NSError?) {
    guard let imageData = imageDataOf(image, type: .NSJPEGFileType) else {
      return (nil, iPicUploadError.CanNotGetImageData) // Should not happen
    }
    
    let image = iPicImage(imageData: imageData)
    
    return (image, nil)
  }
  
  static public func generateImagesFromPasteboard(pasteboard: NSPasteboard) -> [NSImage] {
    var images = [NSImage]()
    
    if let pasteboardItems = pasteboard.pasteboardItems {
      for pasteboardItem in pasteboardItems {
        if let image = generateImageFromPasteboardItem(pasteboardItem) {
          images.append(image)
        }
      }
    }
    
    return images
  }
  
  static private func generateImageFromPasteboardItem(pasteboardItem: NSPasteboardItem) -> NSImage? {
    for type in pasteboardItem.types {
      if let data = pasteboardItem.dataForType(type) {
        if type == String(kUTTypeFileURL) {
          let url = NSURL(dataRepresentation: data, relativeToURL: nil)
          return NSImage(byReferencingURL: url)
          
        } else if let image = NSImage(data: data) {
          return image
        }
      }
    }
    
    return nil
  }
  
  static func imageDataOf(image: NSImage, type: NSBitmapImageFileType) -> NSData? {
    guard let imageData = image.TIFFRepresentation else {
      return nil
    }
    
    if type == NSBitmapImageFileType.NSTIFFFileType {
      return imageData
    }
    
    guard let imageRep = NSBitmapImageRep(data: imageData) else {
      return nil
    }
    
    return imageRep.representationUsingType(type, properties: [:])
  }
  
  static func delay(delay:Double, closure:()->()) {
    dispatch_after(
      dispatch_time(
        DISPATCH_TIME_NOW,
        Int64(delay * Double(NSEC_PER_SEC))
      ),
      dispatch_get_main_queue(), closure)
  }
}