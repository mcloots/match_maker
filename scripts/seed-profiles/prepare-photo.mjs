import sharp from 'sharp';
import { mkdir, writeFile } from 'node:fs/promises';

const [id, source] = process.argv.slice(2);
if (!/^demo-\d{3}$/.test(id ?? '') || !source) {
  throw new Error('Gebruik: node prepare-photo.mjs demo-001 pad/naar/bron.png');
}
const destination = new URL('./photos/', import.meta.url);
await mkdir(destination, { recursive: true });
let output;
for (const quality of [76, 65, 50, 35]) {
  output = await sharp(source)
    .rotate()
    .resize({ width: 640, height: 800, fit: 'cover', withoutEnlargement: true })
    .jpeg({ quality, mozjpeg: true })
    .toBuffer();
  if (output.length <= 200_000) break;
}
if (output.length > 200_000) throw new Error('Foto blijft groter dan 200 KB.');
await writeFile(new URL(id + '.jpg', destination), output);
console.log(id + ': ' + Math.ceil(output.length / 1000) + ' KB');
