import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import { decodeOpus } from 'react-native-opus-decode';

export default function App() {
  const [result, setResult] = React.useState<string | undefined>();

  React.useEffect(() => {
    decodeOpus('https://filesamples.com/samples/audio/opus/sample4.opus').then(
      setResult
    );
  }, []);

  return (
    <View style={styles.container}>
      <Text testID={'DECODE_RESULT'}>{result ? 'SUCCESS' : ''}</Text>
      <Text testID={'DECODE_OUTPUT'}>{result}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
