//
//  StringLiteralTests.swift
//  SwiftRDF-OSX
//
//  Created by Don Willems on 05/12/15.
//  Copyright © 2015 lapsedpacifist. All rights reserved.
//

import Foundation

import XCTest
@testable import SwiftRDFOSX

class StringLiteralTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testStringLiteral() {
        var lit = Literal(stringValue: "Hello World")
        XCTAssertEqual("Hello World", lit.stringValue)
        XCTAssertEqual("\"Hello World\"", lit.sparql)
        XCTAssertNil(lit.dataType)
        XCTAssertNil(lit.language)
        XCTAssertNil(lit.longValue)
        
        lit = Literal(stringValue: "Hello World", language: "en-US")!
        XCTAssertEqual("Hello World", lit.stringValue)
        XCTAssertEqual("\"Hello World\"@en-US", lit.sparql)
        XCTAssertEqual("en-US", lit.language)
        XCTAssertTrue(XSD.string == lit.dataType!)
        XCTAssertNil(lit.longValue)
        
        var litn = Literal(stringValue: "Hello World", language: "00-US") // non valid language
        XCTAssertNil(litn)
        
        lit = Literal(stringValue: "Hello\n World", language: "en")!
        XCTAssertEqual("Hello\n World", lit.stringValue)
        XCTAssertEqual("\"Hello\n World\"@en", lit.sparql)
        XCTAssertEqual("en", lit.language)
        XCTAssertTrue(XSD.string == lit.dataType!)
        XCTAssertNil(lit.longValue)
        
        lit = Literal(stringValue: "Hello\t World", language: "en")!
        XCTAssertEqual("Hello\t World", lit.stringValue)
        XCTAssertEqual("\"Hello\t World\"@en", lit.sparql)
        XCTAssertEqual("en", lit.language)
        XCTAssertTrue(XSD.string == lit.dataType!)
        XCTAssertNil(lit.longValue)
        
        lit = Literal(stringValue: "Hello\r World", language: "en")!
        XCTAssertEqual("Hello\r World", lit.stringValue)
        XCTAssertEqual("\"Hello\r World\"@en", lit.sparql)
        XCTAssertEqual("en", lit.language)
        XCTAssertTrue(XSD.string == lit.dataType!)
        XCTAssertNil(lit.longValue)
        
        lit = Literal(sparqlString: "\"Hello\r World\"@en")!
        XCTAssertEqual("Hello\r World", lit.stringValue)
        XCTAssertEqual("\"Hello\r World\"@en", lit.sparql)
        XCTAssertEqual("en", lit.language)
        XCTAssertTrue(XSD.string == lit.dataType!)
        XCTAssertNil(lit.longValue)
        
        lit = Literal(sparqlString: "\"Hello\r World\"@en")!
        XCTAssertEqual("Hello\r World", lit.stringValue)
        XCTAssertEqual("\"Hello\r World\"@en", lit.sparql)
        XCTAssertEqual("en", lit.language)
        XCTAssertTrue(XSD.string == lit.dataType!)
        XCTAssertNil(lit.longValue)
        
        litn = Literal(sparqlString: "\"Hello\r World\"@00-US") // non valid language
        XCTAssertNil(litn)
    }
    
    func testNormalisedStringLiteral() {
        var normalisedString = "  A  normalised string. "
        var lit = Literal(normalisedStringValue: normalisedString)
        XCTAssertTrue(lit!.dataType! == XSD.normalizedString)
        XCTAssertEqual(normalisedString, lit!.stringValue)
        XCTAssertEqual(normalisedString, lit!.normalizedStringValue)
        
        normalisedString = "  A  normalised \nstring. "
        lit = Literal(normalisedStringValue: normalisedString)
        XCTAssertNil(lit)
        
        normalisedString = "  A  normalised string. "
        var sparqlString = "\""+normalisedString+"\"^^xsd:normalizedString"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertTrue(lit!.dataType! == XSD.normalizedString)
        XCTAssertEqual(normalisedString, lit!.stringValue)
        XCTAssertEqual(normalisedString, lit!.normalizedStringValue)
        
        normalisedString = "  A  normalised \nstring. "
        sparqlString = "\""+normalisedString+"\"^^xsd:normalizedString"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertNil(lit)
    }
    
    func testTokenisedStringLiteral() {
        var tokenisedString = "A tokenised string."
        var lit = Literal(tokenValue: tokenisedString)
        XCTAssertTrue(lit!.dataType! == XSD.token)
        XCTAssertEqual(tokenisedString, lit!.stringValue)
        XCTAssertEqual(tokenisedString, lit!.tokenValue)
        
        tokenisedString = "A  tokenised string."
        lit = Literal(tokenValue: tokenisedString)
        XCTAssertNil(lit)
        
        tokenisedString = " A tokenised string."
        lit = Literal(tokenValue: tokenisedString)
        XCTAssertNil(lit)
        
        tokenisedString = "A tokenised string. "
        lit = Literal(tokenValue: tokenisedString)
        XCTAssertNil(lit)
        
        tokenisedString = "A\ntokenised string."
        lit = Literal(tokenValue: tokenisedString)
        XCTAssertNil(lit)
        
        tokenisedString = "A tokenised string."
        var sparqlString = "\""+tokenisedString+"\"^^xsd:token"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertTrue(lit!.dataType! == XSD.token)
        XCTAssertEqual(tokenisedString, lit!.stringValue)
        XCTAssertEqual(tokenisedString, lit!.tokenValue)
        
        tokenisedString = "A  tokenised string."
        sparqlString = "\""+tokenisedString+"\"^^xsd:token"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertNil(lit)
    }
    
    func testLanguageStringLiteral() {
        var languageString = "en-US"
        var lit = Literal(languageValue: languageString)
        XCTAssertTrue(lit!.dataType! == XSD.language)
        XCTAssertEqual(languageString, lit!.stringValue)
        XCTAssertEqual(languageString, lit!.languageValue)
        
        languageString = "02-en"
        lit = Literal(languageValue: languageString)
        XCTAssertNil(lit)
        
        languageString = " en"
        lit = Literal(languageValue: languageString)
        XCTAssertNil(lit)
        
        languageString = "en "
        lit = Literal(languageValue: languageString)
        XCTAssertNil(lit)
        
        languageString = "e\nn"
        lit = Literal(languageValue: languageString)
        XCTAssertNil(lit)
        
        languageString = "nl"
        var sparqlString = "\""+languageString+"\"^^xsd:language"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertTrue(lit!.dataType! == XSD.language)
        XCTAssertEqual(languageString, lit!.stringValue)
        XCTAssertEqual(languageString, lit!.languageValue)
        
        languageString = "00-US"
        sparqlString = "\""+languageString+"\"^^xsd:language"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertNil(lit)
    }
    
    func testNameLiteral() {
        var nameString = "én:name"
        var lit = Literal(NameValue: nameString)
        XCTAssertTrue(lit!.dataType! == XSD.Name)
        XCTAssertEqual(nameString, lit!.stringValue)
        XCTAssertEqual(nameString, lit!.NameValue)
        
        nameString = "0en:name"
        lit = Literal(NameValue: nameString)
        XCTAssertNil(lit)
        
        nameString = " en"
        lit = Literal(NameValue: nameString)
        XCTAssertNil(lit)
        
        nameString = "en :pole"
        lit = Literal(NameValue: nameString)
        XCTAssertNil(lit)
        
        nameString = "en:\nnss"
        lit = Literal(NameValue: nameString)
        XCTAssertNil(lit)
        
        nameString = "én:name"
        var sparqlString = "\""+nameString+"\"^^xsd:Name"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertTrue(lit!.dataType! == XSD.Name)
        XCTAssertEqual(nameString, lit!.stringValue)
        XCTAssertEqual(nameString, lit!.NameValue)
        
        nameString = " test"
        sparqlString = "\""+nameString+"\"^^xsd:Name"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertNil(lit)
    }
    
    func testNCNameLiteral() {
        var nameString = "énname"
        var lit = Literal(NCNameValue: nameString)
        XCTAssertTrue(lit!.dataType! == XSD.NCName)
        XCTAssertEqual(nameString, lit!.stringValue)
        XCTAssertEqual(nameString, lit!.NCNameValue)
        
        nameString = "en:name"
        lit = Literal(NCNameValue: nameString)
        XCTAssertNil(lit)
        
        nameString = " en"
        lit = Literal(NCNameValue: nameString)
        XCTAssertNil(lit)
        
        nameString = "en pole"
        lit = Literal(NCNameValue: nameString)
        XCTAssertNil(lit)
        
        nameString = "en\nnss"
        lit = Literal(NCNameValue: nameString)
        XCTAssertNil(lit)
        
        nameString = "_blaname"
        var sparqlString = "\""+nameString+"\"^^xsd:NCName"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertTrue(lit!.dataType! == XSD.NCName)
        XCTAssertEqual(nameString, lit!.stringValue)
        XCTAssertEqual(nameString, lit!.NCNameValue)
        
        nameString = "_:test"
        sparqlString = "\""+nameString+"\"^^xsd:NCName"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertNil(lit)
    }
    
    func testIDLiteral() {
        var nameString = "énname"
        var lit = Literal(IDValue: nameString)
        XCTAssertTrue(lit!.dataType! == XSD.ID)
        XCTAssertEqual(nameString, lit!.stringValue)
        XCTAssertEqual(nameString, lit!.NCNameValue)
        
        nameString = "en:name"
        lit = Literal(IDValue: nameString)
        XCTAssertNil(lit)
        
        nameString = " en"
        lit = Literal(IDValue: nameString)
        XCTAssertNil(lit)
        
        nameString = "en pole"
        lit = Literal(IDValue: nameString)
        XCTAssertNil(lit)
        
        nameString = "en\nnss"
        lit = Literal(IDValue: nameString)
        XCTAssertNil(lit)
        
        nameString = "_blaname"
        var sparqlString = "\""+nameString+"\"^^xsd:ID"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertTrue(lit!.dataType! == XSD.ID)
        XCTAssertEqual(nameString, lit!.stringValue)
        XCTAssertEqual(nameString, lit!.NCNameValue)
        
        nameString = "_:test"
        sparqlString = "\""+nameString+"\"^^xsd:ID"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertNil(lit)
    }
    
    func testIDREFLiteral() {
        var nameString = "énname"
        var lit = Literal(IDREFValue: nameString)
        XCTAssertTrue(lit!.dataType! == XSD.IDREF)
        XCTAssertEqual(nameString, lit!.stringValue)
        XCTAssertEqual(nameString, lit!.NCNameValue)
        
        nameString = "en:name"
        lit = Literal(IDREFValue: nameString)
        XCTAssertNil(lit)
        
        nameString = " en"
        lit = Literal(IDREFValue: nameString)
        XCTAssertNil(lit)
        
        nameString = "en pole"
        lit = Literal(IDREFValue: nameString)
        XCTAssertNil(lit)
        
        nameString = "en\nnss"
        lit = Literal(IDREFValue: nameString)
        XCTAssertNil(lit)
        
        nameString = "_blaname"
        var sparqlString = "\""+nameString+"\"^^xsd:IDREF"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertTrue(lit!.dataType! == XSD.IDREF)
        XCTAssertEqual(nameString, lit!.stringValue)
        XCTAssertEqual(nameString, lit!.NCNameValue)
        
        nameString = "_:test"
        sparqlString = "\""+nameString+"\"^^xsd:IDREF"
        lit = Literal(sparqlString: sparqlString)
        XCTAssertNil(lit)
    }
}
