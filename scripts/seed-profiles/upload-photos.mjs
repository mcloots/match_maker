import { createClient } from '@supabase/supabase-js';
import { readFile } from 'node:fs/promises';
import {
  SUPABASE_URL, BUCKET, PHOTO_PREFIX, MAX_PHOTO_BYTES,
  loadProfiles, checkPhotoUrls, planUpload,
} from './data.mjs';

async function main() {
  if (!process.env.SUPABASE_SECRET_KEY) {
    throw new Error('SUPABASE_SECRET_KEY ontbreekt. Start met node --env-file=.env scripts/seed-profiles/upload-photos.mjs');
  }
  const profiles = await loadProfiles();
  const photos = [];
  // Controleer alle bestanden voordat de eerste upload begint.
  for (const profile of profiles) {
    const bytes = await readFile(new URL('./photos/' + profile.id + '.jpg', import.meta.url));
    if (bytes.length > MAX_PHOTO_BYTES || bytes[0] !== 0xff || bytes[1] !== 0xd8) {
      throw new Error('Foto is geen JPEG of groter dan 200 KB: ' + profile.id);
    }
    photos.push({ profile, bytes, path: PHOTO_PREFIX + '/' + profile.id + '.jpg' });
  }

  const supabase = createClient(SUPABASE_URL, process.env.SUPABASE_SECRET_KEY, {
    auth: { persistSession: false, autoRefreshToken: false },
  });
  const { data: bucket, error: bucketError } = await supabase.storage.getBucket(BUCKET);
  if (bucketError) throw bucketError;
  if (!bucket.public) throw new Error('Zet bucket profiles eerst op Public in Supabase Storage.');
  const storage = supabase.storage.from(BUCKET);

  // Tel alle huidige bestanden mee, ook buiten demo-profiles.
  const existingFiles = new Map();
  async function listFolder(folder) {
    for (let offset = 0; ; offset += 100) {
      const { data, error } = await storage.list(folder, { limit: 100, offset });
      if (error) throw error;
      for (const item of data) {
        const path = folder ? folder + '/' + item.name : item.name;
        if (item.id == null) {
          await listFolder(path);
        } else {
          const size = item.metadata?.size;
          if (typeof size !== 'number' || !Number.isFinite(size) || size < 0) {
            throw new Error('Bestandsgrootte kon niet bepaald worden: ' + path);
          }
          existingFiles.set(path, size);
        }
      }
      if (data.length < 100) break;
    }
  }
  await listFolder('');
  const { currentBytes, newPhotos, addedBytes } = planUpload(existingFiles, photos);
  console.log('Bucket nu: ' + (currentBytes / 1_000_000).toFixed(2) + ' MB; na upload: ' +
    ((currentBytes + addedBytes) / 1_000_000).toFixed(2) + ' MB (limiet 50 MB).');
  for (const photo of newPhotos) {
    const { error } = await storage.upload(photo.path, photo.bytes, {
      contentType: 'image/jpeg', cacheControl: '31536000', upsert: false,
    });
    if (error) throw error;
    console.log('Geupload: ' + photo.profile.id);
  }
  await checkPhotoUrls(profiles);
  console.log('Klaar. 50 foto’s zijn publiek bereikbaar; bestaande bestanden zijn behouden.');
}
main().catch(error => {
  console.error('Upload mislukt: ' + error.message);
  process.exitCode = 1;
});
