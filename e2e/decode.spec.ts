import { expect, device, element, by, init, cleanup } from 'detox';
import fs from 'fs';
import jestExpect from 'expect';

const EXPECTED_DECODED_FILE_SIZE = 46936064;

describe('React Native Opus Decode', () => {
  beforeAll(async () => {
    await init();
    await device.launchApp();
  });

  afterAll(async () => {
    await cleanup();
  });

  it('should decode', async () => {
    await expect(element(by.id('DECODE_RESULT'))).toBeVisible();
    await jestExpect(await getDecodedFileSize()).toEqual(
      EXPECTED_DECODED_FILE_SIZE
    );
  });

  const getDecodedFileSize = async () =>
    fs.statSync(await getDecodedFilePath()).size;

  const getDecodedFilePath = async () => {
    const attr = (await element(
      by.id('DECODE_OUTPUT')
    ).getAttributes()) as Detox.IosElementAttributes;
    return attr.text!;
  };
});
