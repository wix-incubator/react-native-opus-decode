import { NativeModules, Platform } from 'react-native';
import RNFS from 'react-native-fs';

const LINKING_ERROR =
  `The package 'react-native-opus-decode' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const OpusDecode = NativeModules.OpusDecode
  ? NativeModules.OpusDecode
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function generateGuid() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    // eslint-disable-next-line no-bitwise
    let r = (Math.random() * 16) | 0,
      // eslint-disable-next-line no-bitwise
      v = c === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

export async function decodeOpus(
  sourceUri: string
): Promise<string | undefined> {
  const guid = generateGuid();
  const sourcePath = `${RNFS.CachesDirectoryPath}/tmp-${guid}.opus`;
  const destPath = `${RNFS.CachesDirectoryPath}/tmp-${guid}.wav`;
  const downloadResult = RNFS.downloadFile({
    fromUrl: sourceUri,
    toFile: sourcePath,
  });
  await downloadResult.promise;
  return OpusDecode.decodeFromUri(sourcePath, destPath);
}
