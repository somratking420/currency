# Currency for iOS

![View of the Currency app for iOS running on an iPhone](http://i.imgur.com/yiOFZzV.jpg)

This project is a simple currency converter app for iOS, built by a designer while learning iOS development in Swift. It is available on the App Store for free to download [here](http://appstore.com/currencysimplecurrencycalculator).

## Motivation

This project is a learning exercise in Swift programming. I seek primarily to get feedback and critique on the code written for this project, but feedback on the overall design and idea is also welcome.

## Swift

This project is written in Swift 3.

## Installation

This project uses [CocoaPods](https://cocoapods.org). Below is the setup to configure Cocoa Pods in your machine.

To install Cocoa Pods, run:
```
$ sudo gem install cocoapods
```

To install the required pods for this project, change to the project directory and run:
```
$ pod install
```

## API Reference

This project makes use of the [Yahoo Query Language (YQL) API](https://developer.yahoo.com/yql/) to get currency exchange rates. You can test query statements on the [YQL Console](https://developer.yahoo.com/yql/console/).

An example YQL statement to fetch the USD to JPY exchange rate looks like:
```
select * from yahoo.finance.xchange where pair in ("USDJPY")
```

And the resulting XML REST query looks like:
```
https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20in%20(%22USDJPY%22)&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys
```

## Initial Data

For this project an initial database is created with the currency data from this [Google Spreadsheet](https://docs.google.com/spreadsheets/d/1218JsxdKNp3ytpAtIq8D1Wtl9t4blLpC2amTweWDhek/edit?usp=sharing). Please add a comment if some of the data is incorrect. Exchange rates are updated using the Yahoo API above while the app is being used as rates fluctuate daily.

## Tests

There are no tests written for this application so far.

## Translations

I am looking for help translating the application. Please [email me](mailto:nuno@nunocoelhosantos.com?subject=Help%20translate%20Currency%20for%20iOS) if you're willing to help. Here is the list of current translations:

- [x] English
- [x] English (British)
- [ ] English (Australian)
- [ ] English (Canadian)
- [ ] English (Indian)
- [ ] French
- [ ] French (Canadian)
- [x] Spanish, thanks to [Alex Abian](https://www.instagram.com/alex_abn/)
- [ ] Spanish (Mexico)
- [x] Portuguese, thanks to [Jack Veiga](https://twitter.com/jackveiga)
- [ ] Portuguese (Brazil)
- [ ] Italian
- [ ] German
- [x] Chinese, thanks to [Xin Nie](https://www.instagram.com/star_nie/)
- [x] Chinese (Simplified), thanks to [Xin Nie](https://www.instagram.com/star_nie/)
- [x] Chinese (Traditional), thanks to [Xin Nie](https://www.instagram.com/star_nie/)
- [x] Chinese (Hong Kong), thanks to [Xin Nie](https://www.instagram.com/star_nie/)
- [ ] Dutch
- [x] Japanese, thanks to [Asuka Yamashita](https://www.facebook.com/asuka.yamashita.944)
- [ ] Korean
- [ ] Vietnamese
- [ ] Russian
- [ ] Swedish
- [ ] Danish
- [ ] Finnish
- [ ] Norwegian (Bokmal)
- [ ] Turkish
- [ ] Greek
- [ ] Indonesian
- [ ] Malay
- [ ] Thai
- [ ] Hindi
- [ ] Hungarian
- [ ] Polish
- [ ] Czech
- [ ] Slovak
- [ ] Ukrainian
- [ ] Croatian
- [ ] Catalan
- [ ] Romanian
- [ ] Hebrew
- [ ] Arabic

## Contribute

This is a project by [Nuno Coelho Santos](https://twitter.com/nunosans/). All contributions in the form of pull requests or comments are welcome. If you experience problems with the project, please open an issue and give as much detailed information as you can.
