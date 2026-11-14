import { readFile } from 'node:fs/promises';

export const SUPABASE_URL = 'https://rtpgcpouycdyacvqjlld.supabase.co';
export const BUCKET = 'profiles';
export const PHOTO_PREFIX = 'demo-profiles';
export const MAX_BUCKET_BYTES = 50_000_000;
export const MAX_PHOTO_BYTES = 200_000;

export function planUpload(existingFiles, photos) {
  const currentBytes = [...existingFiles.values()].reduce((sum, bytes) => sum + bytes, 0);
  const newPhotos = photos.filter(photo => !existingFiles.has(photo.path));
  const addedBytes = newPhotos.reduce((sum, photo) => sum + photo.bytes.length, 0);
  if (currentBytes + addedBytes > MAX_BUCKET_BYTES) {
    throw new Error('Upload gestopt: de bucket zou groter dan 50 MB worden.');
  }
  return { currentBytes, addedBytes, newPhotos };
}

export async function loadProfiles() {
  const profiles = JSON.parse(await readFile(new URL('./profiles.json', import.meta.url), 'utf8'));
  if (profiles.length !== 50 || new Set(profiles.map(p => p.id)).size !== 50) {
    throw new Error('De dataset moet precies 50 unieke profielen bevatten.');
  }
  for (const profile of profiles) {
    const expectedUrl = SUPABASE_URL + '/storage/v1/object/public/' + BUCKET + '/' + PHOTO_PREFIX + '/' + profile.id + '.jpg';
    if (!/^demo-\d{3}$/.test(profile.id) ||
        typeof profile.name !== 'string' || !profile.name.trim() ||
        !Number.isInteger(profile.age) || profile.age < 18 || profile.age > 120 ||
        typeof profile.location !== 'string' || !profile.location.trim() ||
        !Array.isArray(profile.interests) || !profile.interests.every(i => typeof i === 'string') ||
        profile.imageUrl !== expectedUrl) {
      throw new Error('Ongeldig profiel: ' + profile.id);
    }
  }
  return profiles;
}

export async function checkPhotoUrls(profiles) {
  // Geen Firebase-aanpassing zolang niet alle foto's bereikbaar zijn.
  for (const profile of profiles) {
    const response = await fetch(profile.imageUrl, { method: 'HEAD', signal: AbortSignal.timeout(15_000) });
    const size = Number(response.headers.get('content-length'));
    if (!response.ok || !response.headers.get('content-type')?.startsWith('image/') ||
        !Number.isFinite(size) || size <= 0 || size > MAX_PHOTO_BYTES) {
      throw new Error('Foto ontbreekt, is niet publiek of is te groot: ' + profile.id);
    }
  }
}
