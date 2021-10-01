import Foundation

internal extension Array {
  subscript(safe index: Index) -> Element? {
    get { return self.indices ~= index ? self[index] : nil }
    set {
      if self.indices ~= index {
        self[index] = newValue!
      } else {
        while !(self.indices ~= index) {
          self.append(newValue!)
        }
      }
    }
  }
  
  func append(value: Element) -> Self {
    var copy = self
    copy.append(value)
    return copy
  }
  
}

private let trueNumber = NSNumber(value: true)
private let falseNumber = NSNumber(value: false)
private let trueObjCType = String(cString: trueNumber.objCType)
private let falseObjCType = String(cString: falseNumber.objCType)

extension NSNumber {
  var isBool: Bool {
    let objCType = String(cString: self.objCType)
    if (self.compare(trueNumber) == .orderedSame && objCType == trueObjCType) || (self.compare(falseNumber) == .orderedSame && objCType == falseObjCType) {
      return true
    } else {
      return false
    }
  }
}

internal extension String {
  
  static var defaultValue: String {
    ""
  }
}

internal extension Int {
  
  static var defaultValue: Int {
    0
  }
}

internal extension Double {
  
  static var defaultValue: Double {
    0.0
  }
}

internal extension Float {
  
  static var defaultValue: Float {
    0.0
  }
}

internal extension Bool {
  
  static var defaultValue: Bool {
    false
  }
}

internal extension Array {
  
  static var defaultValue: Array {
    []
  }
}

internal extension Dictionary {
  static var defaultValue: Dictionary {
    [:]
  }
}

internal extension NSNumber {
  
  static var defaultValue: NSNumber {
    0
  }
  
}

internal extension NSNull {
  
  static var defaultValue: NSNull {
    NSNull()
  }
  
}

internal extension String {
  
  func toData(using:String.Encoding = .utf8) -> Data? {
    return self.data(using: using)
  }
  
  func toModel<D>(_ type: D.Type, using decoder: JSONDecoder?) -> D? where D : Decodable {
    return self.toData()?.toModel(type,using: decoder)
  }
  
  func toDictionary() -> [String: Any]? {
    guard let data = self.toData() else {return nil}
    do {
      return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    } catch {
      return nil
    }
  }
  
}

internal extension Data {
  
  func toString(encoding: String.Encoding = .utf8) -> String? {
    String(data: self, encoding: encoding)
  }
  
  func toModel<D>(_ type: D.Type, using decoder: JSONDecoder? = nil) -> D? where D: Decodable {
    let decoder = decoder ?? JSONDecoder()
    return try? decoder.decode(type, from: self)
  }
  
  func toDictionary() -> [String: Any]? {
    do {
      let json = try JSONSerialization.jsonObject(with: self)
      return json as? [String: Any]
    } catch {
      return nil
    }
  }
  
  func toData(keyPath: String? = nil) -> Self? {
    guard  let keyPath = keyPath else {return self}
    do {
      let json = try JSONSerialization.jsonObject(with: self, options: [])
      if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
        guard JSONSerialization.isValidJSONObject(nestedJson) else {
          return nil
        }
        let data = try JSONSerialization.data(withJSONObject: nestedJson)
        return data
      }
    } catch {
      return nil
    }
    return nil
  }
  
  func toDataPrettyPrinted() -> Self {
    do {
      let dataAsJSON = try JSONSerialization.jsonObject(with: self)
      let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
      return prettyData
    } catch {
      return self // fallback to original data if it can't be serialized.
    }
  }
  
  subscript(_ keyPath: String? = nil) -> Self? {
    toData(keyPath: keyPath)
  }
  
}

internal extension Dictionary {
  
  func toData() -> Data? {
    do {
      return try JSONSerialization.data(withJSONObject: self, options: [])
    } catch {
      return nil
    }
  }
  
  func toModel<D>(_ type: D.Type, using decoder: JSONDecoder? = nil) -> D? where D : Decodable {
    toData()?.toModel(type, using: decoder)
  }
  
  
  func toString(using: String.Encoding = .utf8) -> String? {
    guard let data = self.toData() else {return nil}
    return String(data: data, encoding: using)
  }
  
}

internal extension Encodable {
  
  func toData() -> Data? {
    try? JSONEncoder().encode(self)
  }
  
  func toDictionary() -> [String: Any]? {
    toData()?.toDictionary()
  }
  
  func toModel<D>(_ type: D.Type, using decoder: JSONDecoder?) -> D? where D: Decodable {
    toData()?.toModel(type)
  }
  
}

internal func ==(lhs: [String: Any], rhs: [String: Any] ) -> Bool {
  return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}
