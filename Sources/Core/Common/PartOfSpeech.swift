//
//  PartOfSpeech.swift
//  
//
//  Created by Alexander Cyon on 2019-10-23.
//

import Foundation

// MARK: POS Tags

///
/// View the full legend of Part of Speech (POS) tags [here][1], or a more comprehensive one with examples [here][2].
///
///     CODE    | SWE🇸🇪 CATEGORY                | EXAMPLE   | ENG🇬🇧 TRANSLATION
///     ===============================================================
///     AB      | Adverb                        | 'inte'    | Adverb
///     DT      | Determinerare                 | 'denna'   | Determiner
///     HA      | Frågande/relativt adverb      | 'när'     | Interrogative/Relative Adverb
///     HD      | Frågande/relativt determin.   | 'vilken'  | Interrogative/Relative Determiner
///     HP      | Frågande/relativt prononen    | 'som'     | Interrogative/Relative Pronoun
///     HS      | Frågande/relativt pos.pron    | 'vars'    | Interrogative/Relative Possessive Pronoun
///     IE      | Infinitivmärke                | 'att'     | Infinitive Marker
///     IN      | Interjektion                  | 'ja'      | Interjection
///     JJ      | Adjektiv                      | 'glad'    | Adjective
///     KN      | Konjunktion                   | 'och'     | Conjunction
///     NN      | Substantiv                    | 'pudding' | Noun
///     PC      | Particip                      | 'utsänd'  | Participle
///     PL      | Partikel                      | 'ut'      | Particle
///     PM      | Egennamn                      | 'Mats'    | Proper Noun
///     PN      | Pronomen                      | 'hon'     | Pronoun
///     PP      | Preposition                   | 'av'      | Preposition
///     PS      | Possessivt pronomen           | 'hennes'  | Possessive
///     RG      | Grundtal                      | 'tre'     | Cardinal number
///     RO      | Ordningstal                   | 'tredje'  | Ordinal number
///     SN      | Subjunktion                   | 'att'     | Subjunction
///     UO      | Utländskt ord                 | 'the'     | Foreign Word
///     VB      | Verb                          | 'kasta'   | Verb
///     MAD     | Meningsskiljande Interpunktion| '.'       | Major Delimiter
///     MID     | Interpunktion                 | '-'       | Minor Delimiter
///     PAD     | Interpunktion                 | '"'       | Pairwise Delimiter
///
/// [1]: https://spraakbanken.gu.se/korp/markup/msdtags.html
/// [2]:  https://www.ling.su.se/polopoly_fs/1.89313.1337935966!/menu/standard/file/parole_format_suc_tagset.pdf
///
enum PartOfSpeech: String, CaseIterable, Hashable, CustomStringConvertible, Codable {

    /// 🇸🇪: `Adverb`, e.g. "inte" (🇬🇧: "not")
    case adverb = "AB"

    /// 🇸🇪: `Determinerare`, e.g. "denna" (🇬🇧: "this")
    case determiner = "DT"

    /// 🇸🇪: `Frågande/relativt adverb`, e.g. "när" (🇬🇧: "when")
    case relativeInterogativeAdverb = "HA"

    /// 🇸🇪: `Frågande/relativt determinerare`, e.g. "vilken" (🇬🇧: "which")
    case relativeInterogativeDeterminer = "HD"

    /// 🇸🇪: `Frågande/relativt pronomen`, e.g. "som" (🇬🇧: "which")
    case relativeInterogativePronoun = "HP"

    /// 🇸🇪: `Frågande/relative possesivt pronomen`, e.g. "vars" (🇬🇧: "which")
    case relativeInterogativePossesivePronoun = "HS"

    /// 🇸🇪: `Infinitivmärke`, .e.g. "att", (🇬🇧: "to <VERB>")
    case infinitiveMarker = "IE"

    /// 🇸🇪: `Interjektion`, e.g. "ja" (🇬🇧: "yes")
    case interjection = "IN"

    /// 🇸🇪: `Adjektiv`, e.g. "glad"
    case adjective = "JJ"

    /// 🇸🇪: `Konjunktion`, e.g. "och" (🇬🇧: "and")
    case conjunction = "KN"

    /// 🇸🇪: ``Substantiv`, e.g. "pudding" (🇬🇧: "pudding")
    case noun = "NN"

    /// 🇸🇪: `Particip`, e.g. "utsänd" (🇬🇧: "")
    case participle = "PC"

    /// 🇸🇪: `Partikel`, e.g. "ut" (🇬🇧: "")
    case particle       = "PL"

    /// 🇸🇪: `Egennamn`, e.g. "Mats" (🇬🇧: "John")
    case properNoun     = "PM"

    /// 🇸🇪: `Pronomen`, e.g. "hon" (🇬🇧: "she")
    case pronoun        = "PN"

    /// 🇸🇪: `Preposition`, e.g. "av" (🇬🇧: "by")
    case preposition    = "PP"

    /// 🇸🇪: `Possessivt pronomen`, e.g. "hennes" (🇬🇧: "her")
    case possessive     = "PS"

    /// 🇸🇪: `Grundtal`, e.g. "tre" (🇬🇧: "three")
    case cardinalNumber = "RG"

    /// 🇸🇪: `Ordningstal`, e.g. "tredje" (🇬🇧: "third")
    case ordinalNumber  = "RO"

    /// 🇸🇪: `Subjunktion`, e.g. "att" (🇬🇧: ?)
    case subjunction    = "SN"

    /// 🇸🇪: `Utländskt ord`, e.g. 🇬🇧: "the" (🇸🇪: "den"/"det")
    case foreignWord    = "UO"

    /// 🇸🇪: `Verb`, e.g. "kasta" (🇬🇧: "throw")
    case verb           = "VB"

}

// MARK: Init+String
extension PartOfSpeech {

    init?(string anyCase: String) {
        guard let pos = PartOfSpeech(rawValue: anyCase) ?? PartOfSpeech(rawValue: anyCase.uppercased()) else {
            return nil
        }
        self = pos
    }

    /// String is on unparsed format: `PN.UTR.SIN.DEF.SUB`
    /// We only deal with the first part of the tag, i.e. `PN` from the line above
    init(linePart string: String) throws {

        let parts = string.parts(separatedBy: Self.delimiter)

        guard let posString = parts.first else { throw Error.stringContainedNoPos }

        guard let pos = PartOfSpeech(string: posString) else {
            throw Error.unknownPartOfSpeechTag(fromString: string)
        }
        self = pos
    }
}

extension PartOfSpeech {
    var description: String {
        return rawValue
    }
}

extension PartOfSpeech {
    static let delimiter: Character = "."
}

extension PartOfSpeech {
    enum Error: Swift.Error {
        case stringContainedNoPos
        case unknownPartOfSpeechTag(fromString: String)
    }
}
