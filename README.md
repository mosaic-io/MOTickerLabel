# MOTickerLabel

Ticker Label that animates changes in monetary value. To learn more about how `MOTickerLabel` works, checkout this [Mosaic Enginnering blog post](https://blog.getmosaic.io/The-Ticker).

> The label currently only supports US dollar.

## Sample Code

```swift
let label = TickerLabel(frame: CGRect(x: 0, y: 0, width: 300, height: 50), value: Dollar(float: 12.03))
view.addSubview(label)
label.value = Dollar(float: 10.19)

// Animate change after two seconds!
DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    self.label.value = Dollar(float: 940.39)
}
```

## Demo

![](https://blog.getmosaic.io/aa65c8e28bce049e831b31d185ff3dd8/final.gif)

# LICENSE

MIT License

Copyright (c) [2020] [MOTickerLabel by Mosaic Engineering]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
