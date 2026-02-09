# Kaikōrero

A small iOS app for learning te reo Māori vocabulary, built by someone who is learning the language themselves.

## What it does

Kaikōrero helps you learn and practise te reo Māori words through flashcards and quizzes, with spaced repetition to help things stick. It covers everyday topics like greetings (mihimihi), family (whānau), the body (tinana), nature (taiao), food (kai), and more.

The main features are:

- **Kupu (words)** browse words by topic, see translations, example sentences, and listen to pronunciation audio
- **Whakamātautau (quizzes)** test yourself with multiple choice, reverse translation, and true/false questions
- **Kauneke (progress)** track how you're going, with spaced repetition scheduling your reviews so you revisit words at the right time

The app uses te reo Māori for its interface labels alongside English translations, so you're picking up a bit of the language just by using it.

## Why this exists

I'm learning te reo Māori and wanted a simple vocab tool that worked the way I wanted it to. There are great resources out there already — Te Aka dictionary, Rongo, a range of Anki resources, Kōreroreo, TATAU, Ako Tahi, all brilliant — but I wanted something with spaced repetition baked in and a word set I could curate myself.

## A note on expectations

This is a personal learning project and a proof of concept. It is not a polished, production-ready app, and its probably not yet on the App Store. There will be rough edges, missing features, and things that could be done better. If you find it useful, that's great, but please keep that context in mind.

The word list is modest and the app is opinionated about how it works. It's one learner's tool, not a comprehensive language course.

## Installing via AltStore

While this app isn't on the App Store yet, you can sideload it using [AltStore](https://altstore.io). Download the latest `Kaikorero.ipa` from the [Releases](https://github.com/aidancornelius/Kaikorero/releases) page, then open it in AltStore to install it on your device.

## Building

Kaikōrero requires iOS 26+ and is built with Swift 6.2 and SwiftUI. The project uses Swift Package Manager.

Open the Xcode project and build, or from the `Kaikorero/` directory:

```
swift build
swift test
```

## Acknowledgements

- **Te Aka Māori Dictionary** by John C. Moorfield — an invaluable resource for all learners of te reo
- **A Dictionary of the Maori Language** by Herbert W. Williams
- **swift-fsrs** by 4rays — the FSRS v5 spaced repetition algorithm implementation that powers the review scheduling
- **Māori TTS** by KingsleyEng on HuggingFace — used to generate the pronunciation audio

He taonga te reo Māori.

## License

Kaikōrero is open source software, available under the [Mozilla Public License 2.0](LICENSE).
