//
//  InputViewControllerTests.swift
//  ToDoTests
//
//  Created by Apple on 17/01/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import XCTest
import CoreLocation

@testable import ToDo

class InputViewControllerTests: XCTestCase {
    
    var sut: InputViewController!
    var placemark: MockPlacemark!
    
    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = (storyboard.instantiateViewController(withIdentifier: "InputViewController") as! InputViewController)
        _ = sut.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_HasAllInputFields() {
        XCTAssertNotNil(sut.titleTextField)
        XCTAssertNotNil(sut.descriptionTextField)
        XCTAssertNotNil(sut.dateTextField)
        XCTAssertNotNil(sut.addressTextField)
        XCTAssertNotNil(sut.locationTextField)
    }

    func test_HasSaveAndCancelButton() {
        XCTAssertNotNil(sut.buttonSave)
        XCTAssertNotNil(sut.buttonCancel)
    }
    
    func testSave_UsesGeocoderToGetCoordinateFromAddress() {
        sut.titleTextField.text = "Test Title"
        sut.dateTextField.text = "02/22/2016"
        sut.locationTextField.text = "Office"
        sut.addressTextField.text = "Infinite Loop 1, Cupertino"
        sut.descriptionTextField.text = "Test Description"
        let mockGeocoder = MockGeocoder()
        sut.geocoder = mockGeocoder
        sut.itemManager = ItemManager()
        sut.save()
        placemark = MockPlacemark()
        let coordinate = CLLocationCoordinate2DMake(37.3316851, -122.0300674)
        placemark.mockCoordinate = coordinate
        mockGeocoder.completionHandler?([placemark], nil)
        let item = sut.itemManager?.itemAtIndex(0)
        let testItem = ToDoItem(title: "Test Title", itemDescription: "Test Description", timestamp: Date().timeIntervalSince1970, location: Location(name: "Office", coordinate: coordinate))
        XCTAssertEqual(item, testItem)
    }
    
    func test_SaveButtonHasSaveAction() {
        let saveButton: UIButton = sut.buttonSave
            guard let actions = saveButton.actions(forTarget: sut, forControlEvent: .touchUpInside) else {
                XCTFail()
                return
        }
        XCTAssertTrue(actions.contains("save"))
    }
}


extension InputViewControllerTests {
    class MockGeocoder: CLGeocoder {
        var completionHandler: CLGeocodeCompletionHandler?
        
        override func geocodeAddressString(_ addressString: String, completionHandler: @escaping CLGeocodeCompletionHandler) {
            self.completionHandler = completionHandler
        }
    }
    
    class MockPlacemark : CLPlacemark {
        var mockCoordinate: CLLocationCoordinate2D?
        override var location: CLLocation? {
        guard let coordinate = mockCoordinate else { return CLLocation() }
        return CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        }
    }
}
