//
//  StringMacronTests.swift
//  Kaikorero
//
//  Created by Aidan Cornelius-Bell on 9/2/2026.
//  This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0.
//

import Testing
import Foundation
@testable import Kaikorero

@Suite("String+Macrons Tests")
struct StringMacronTests {

    @Test("Strip macrons")
    func stripMacrons() {
        #expect("kōrero".withoutMacrons == "korero")
        #expect("tēnā koe".withoutMacrons == "tena koe")
        #expect("Āporo".withoutMacrons == "Aporo")
        #expect("hello".withoutMacrons == "hello")
    }

    @Test("Contains macrons")
    func containsMacrons() {
        #expect("kōrero".containsMacrons)
        #expect("tēnā".containsMacrons)
        #expect(!"hello".containsMacrons)
        #expect(!"korero".containsMacrons)
    }

    @Test("Equals ignoring macrons")
    func equalsIgnoringMacrons() {
        #expect("kōrero".equalsIgnoringMacrons("korero"))
        #expect("KŌRERO".equalsIgnoringMacrons("korero"))
        #expect("tēnā koe".equalsIgnoringMacrons("tena koe"))
        #expect(!"kōrero".equalsIgnoringMacrons("kai"))
    }
}
