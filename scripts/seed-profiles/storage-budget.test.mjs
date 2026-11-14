import test from 'node:test';
import assert from 'node:assert/strict';
import { planUpload } from './data.mjs';

test('bestaande bestanden buiten de demomap tellen mee', () => {
  const existing = new Map([['andere-map/foto.jpg', 49_900_000]]);
  assert.throws(() => planUpload(existing, [
    { path: 'demo-profiles/demo-001.jpg', bytes: { length: 200_000 } },
  ]), /50 MB/);
});

test('precies 50 MB is toegestaan', () => {
  const result = planUpload(new Map([['bestaand.jpg', 49_800_000]]), [
    { path: 'demo-profiles/demo-001.jpg', bytes: { length: 200_000 } },
  ]);
  assert.equal(result.currentBytes + result.addedBytes, 50_000_000);
});

test('opnieuw uitvoeren slaat bestaande foto’s over', () => {
  const result = planUpload(new Map([['demo-profiles/demo-001.jpg', 70_000]]), [
    { path: 'demo-profiles/demo-001.jpg', bytes: { length: 70_000 } },
  ]);
  assert.equal(result.newPhotos.length, 0);
  assert.equal(result.addedBytes, 0);
});

test('50 maximale profielfoto’s blijven samen binnen 10 MB', () => {
  const photos = Array.from({ length: 50 }, (_, i) => ({
    path: 'demo-' + i + '.jpg', bytes: { length: 200_000 },
  }));
  const result = planUpload(new Map(), photos);
  assert.equal(result.addedBytes, 10_000_000);
});
