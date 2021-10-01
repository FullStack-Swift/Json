    import XCTest
    @testable import Json
    
    final class JsonTests: XCTestCase {
        
        func testArrayBuilder() {
            let json1 = DictionaryBuilder {
                DictionaryItemBuilder(key: "hi", value: "hello")
            }
            let json2 = ArrayBuilder {
                ArrayItemBuilder(1)
                ArrayItemBuilder(json1)
            }
            
            XCTAssertEqual(json2.json, Json([1,["hi": "hello"]]))
            
        }
        
        func testDictionaryBuilder() {
            let json1 = ArrayBuilder {
                ArrayItemBuilder(1)
                ArrayItemBuilder(1)
            }.json
            let json2 = DictionaryBuilder {
                DictionaryItemBuilder(key: "hi", value: "hello")
                DictionaryItemBuilder(key: "json1", value: json1)
            }.json
            
            XCTAssertEqual(json2, Json(["hi": "hello", "json1": [1, 1]]))
        }
        
        func testEqualArray() {
            let array1: [Any] = [1,[2,2],[3,3,3]]
            let array2: [Any] = [1,[2,2],[3,3,3]]
            
            XCTAssertEqual(Json(array1), Json(array2))
        }
        
        func testEqualDictionary() {
            let dict1:[String: Any] = ["1": 2, "3": "3"]
            let dict2:[String: Any] = ["1": 2, "3": "3"]
            
            XCTAssertEqual(Json(dict1), Json(dict2))
        }
        
        func testJson() {
            let dict1: [String: Any] = ["one": 1, "two": 2]
            let array1: [Any] = [1,2]
            let json1 = Json(dict1).merge(with: Json(array1))
            let json2 = Json(array1).merge(with: Json(dict1))
            
            XCTAssertEqual(json1, Json(array1.append(value: dict1)))
            XCTAssertEqual(json1, Json([1,2, ["one": 1, "two": 2]]))
            XCTAssertEqual(json1, json2)
            
//            let json3 = Json {
//                
//                ArrayBuilder {
//                    ArrayItemBuilder(1)
//                    ArrayItemBuilder(2)
//                }
//                
//                DictionaryBuilder {
//                    DictionaryItemBuilder(key: "one", value: 1)
//                    DictionaryItemBuilder(key: "two", value: 2)
//                }
//            }
            
            
            
        }
    }
