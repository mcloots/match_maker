import { loadProfiles, checkPhotoUrls } from './data.mjs';

async function main() {
  const [projectId, option] = process.argv.slice(2);
  if (!/^[a-z][a-z0-9-]{4,28}[a-z0-9]$/.test(projectId ?? '') ||
      (option !== undefined && option !== '--dry-run')) {
    throw new Error('Gebruik: node seed.mjs jouw-firebase-project-id [--dry-run]');
  }
  const profiles = await loadProfiles();
  console.log('Doelproject: ' + projectId + '; collectie: profiles; 50 demo-profielen.');
  if (option === '--dry-run') {
    console.log('Dataset geldig. Dry-run: geen netwerkverkeer en geen wijzigingen.');
    return;
  }
  await checkPhotoUrls(profiles);
  const { applicationDefault, initializeApp, deleteApp } = await import('firebase-admin/app');
  const { getFirestore } = await import('firebase-admin/firestore');
  const app = initializeApp({ credential: applicationDefault(), projectId });
  const db = getFirestore(app);
  try {
    const batch = db.batch();
    for (const { id, ...profile } of profiles) {
      batch.set(db.collection('profiles').doc(id), profile);
    }
    await batch.commit();
    console.log('50 profielen opgeslagen. Open Ontdek in de Flutter-app.');
    console.log('Opnieuw uitvoeren werkt dezelfde demo-documenten bij, zonder duplicaten.');
  } finally {
    await db.terminate();
    await deleteApp(app);
  }
}
main().catch(error => {
  console.error('Seeden mislukt: ' + error.message);
  process.exitCode = 1;
});
