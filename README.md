# react-native-opus-decode

Opus decoder for react-native (only iOS is currently supported).

[![Build status](https://badge.buildkite.com/e5b628b7d27b2d42354812f524ddcb7786816f8805d383a86e.svg)](https://buildkite.com/wix-mobile-oss/react-native-opus-decode)

## Installation

```sh
npm install react-native-opus-decode
```

## Usage

```js
import { decodeOpus } from 'react-native-opus-decode';

// ...

const localWavPath = await decodeOpus('https://filesamples.com/samples/audio/opus/sample4.opus');
```

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT
