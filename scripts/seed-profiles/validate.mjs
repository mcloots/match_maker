import { readFile } from 'node:fs/promises';
import { loadProfiles, MAX_PHOTO_BYTES, checkPhotoUrls } from './data.mjs';

const profiles = await loadProfiles();
if (process.argv.includes('--remote')) {
  await checkPhotoUrls(profiles);
  console.log('Alle 50 publieke foto-URLs zijn bereikbaar.');
} else if (process.argv.includes('--photos')) {
  let total = 0;
  for (const { id } of profiles) {
    const data = await readFile(new URL('./photos/' + id + '.jpg', import.meta.url));
    if (data.length > MAX_PHOTO_BYTES || data[0] !== 0xff || data[1] !== 0xd8) {
      throw new Error('Ongeldige of te grote JPEG: ' + id);
    }
    total += data.length;
  }
  console.log('50 JPEG-foto’s gecontroleerd, samen ' + (total / 1_000_000).toFixed(2) + ' MB.');
} else {
  console.log('50 unieke volwassen profielen met geldige Supabase-URLs gecontroleerd.');
}
