import { expect, device, element, by, init, cleanup } from 'detox';

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
  });
});
