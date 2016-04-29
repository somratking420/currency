# Currency for iOS

![View of the Currency app for iOS running on an iPhone](http://f.cl.ly/items/1V1t3V1T140z2N0M1415/currency.jpg)

This project is to-be a fun currency converter app, built by a designer learning iOS development in Swift. It will be hitting the App Store as soon as possible.

## Swift

This project is written in the Apple Swift version 2.1.1, I hope you're cool with that.

## Motivation

This project is a learning exercise in Swift programming. I seek primarily to get feedback and critique on the code written for this project, but feedback on the overall design and idea is also welcome.

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

## Initial Currency Data

For this project an initial database is created with the currency data from this [Google Spreadsheet](https://docs.google.com/spreadsheets/d/1218JsxdKNp3ytpAtIq8D1Wtl9t4blLpC2amTweWDhek/edit?usp=sharing). Please add a comment if some of the data is incorrect. Exchange rates are updated using the Yahoo API above while the app is being used as rates fluctuate daily.

## Tests

There are no tests written for this application so far.

## Tasks

There is a plain text file included in the repository with the current list of tasks to do.

## Contributors

At the moment the best contribution is in the form of feedback on the code and the product. All feedback is valid: design decisions, code style, recommended re-writes based on your experience, architecture, naming, etc. You can open an issue, comment directly on the code or add inline comments to the code.
I will address and reply to feedback as quickly as possible. The goal is for me to learn, so learning from your suggestions is more important than the app itself.
If don't have my contact details, I'm [@nunosans](http://twitter.com/nunosans) on Twitter, you can add and message me on Facebook: [fb.com/nunosans](http://fb.com/nunosans/) or email me at [nuno@nunocoelhosantos.com](mailto:nuno@nunocoelhosantos.com).
This project repository will be made public after the app is launched on the App Store.
