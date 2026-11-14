# 50 fictieve swipe-profielen

De foto's staan centraal in de publieke Supabase-bucket **profiles**.
Iedere student kopieert alleen de profieldocumenten naar de eigen Firestore.
Alle personen en portretten zijn fictief; de foto's zijn met de ingebouwde
imagegen-tool gegenereerd. De prompts staan in `photo-prompts.json`.

Alle 50 foto's zijn geupload en de publieke URLs zijn gecontroleerd.
De volledige set gebruikt **2,98 MB** (2.983.209 bytes); de grootste foto is 83 KB.

## Voor studenten: Firestore vullen

Nodig: Node.js 22 of hoger, een eigen Firebase-project en een aangemaakte
standaard Firestore-database.

1. Installeer de pakketten, vanuit de hoofdmap van de Flutter-app:
   ```powershell
   npm --prefix scripts/seed-profiles ci
   ```
2. Open in de Firebase-console jouw project. Ga naar
   **Project settings → Service accounts → Firebase Admin SDK → Generate new private key**.
   Bewaar het JSON-bestand buiten de repository, bijvoorbeeld in Downloads.
3. Verwijs in PowerShell naar dit bestand en geef jouw eigen project-ID op:
   ```powershell
   $env:GOOGLE_APPLICATION_CREDENTIALS = "C:\Users\jouw-naam\Downloads\service-account.json"
   node scripts/seed-profiles/seed.mjs jouw-firebase-project-id
   ```
   Op macOS/Linux:
   ```sh
   export GOOGLE_APPLICATION_CREDENTIALS="$HOME/Downloads/service-account.json"
   node scripts/seed-profiles/seed.mjs jouw-firebase-project-id
   ```
4. Log in op de Flutter-app en open **Ontdek**.

De seeder controleert eerst of alle 50 foto's publiek bereikbaar zijn. Daarna
schrijft één Firestore-batch de documenten `profiles/demo-001` tot `profiles/demo-050`.
Er worden geen Authentication-accounts aangemaakt.
Nogmaals uitvoeren werkt dezelfde demo-documenten bij en maakt geen duplicaten.
Andere profieldocumenten en persoonlijke swipes worden niet aangepast.

De Admin SDK gebruikt de rechten van jouw serviceaccount, onafhankelijk van
de Firestore-regels voor de app. Aangemelde appgebruikers moeten nog steeds
leesrechten op `profiles` hebben.

Een serviceaccountbestand bevat een private sleutel. Deel het niet met
medestudenten, zet het niet in Git en neem het niet op in de Flutter-app.

Controleer de dataset zonder verbinding of wijzigingen:
```powershell
node scripts/seed-profiles/seed.mjs jouw-firebase-project-id --dry-run
```

Na swipen blijven de keuzes bewaard. Om opnieuw te oefenen, gebruik je een nieuw
appaccount of verwijder je in de Firebase-console alleen de demo-swipes onder
`users/{jouw-uid}/swipes/demo-...`. De seeder wist die bewust niet.

## Voor de docent: foto's uploaden

De openbare URL heeft deze vorm:

```text
https://rtpgcpouycdyacvqjlld.supabase.co/storage/v1/object/public/profiles/demo-profiles/demo-001.jpg
```

De 50 JPEG-bestanden staan in `photos/`. Elk is maximaal 640 × 800 pixels en
200 KB; samen maximaal 10 MB. De uploader telt ook de bestaande bestanden in
de volledige bucket mee en weigert een upload die het totaal boven
**50.000.000 bytes (50 MB)** zou brengen. Andere gelijktijdige uploads naar de
bucket tellen vanzelfsprekend pas mee bij een volgende controle.

Zet in `.env` in de hoofdmap van de Flutter-app:
```dotenv
SUPABASE_SECRET_KEY=jouw-secret-key
```

Voer vanuit die hoofdmap uit:
```powershell
node --env-file=.env scripts/seed-profiles/upload-photos.mjs
```

De bucket moet al bestaan en op **Public** staan. Bestaande bestanden worden
overgeslagen; het script maakt de bucket niet leeg en overschrijft geen foto's.
De sleutel wordt alleen voor uploads gebruikt en staat niet in `profiles.json`.
Publieke foto-URLs verlopen niet zolang de bucket en bestanden beschikbaar blijven.

Controleer lokaal of via de publieke URLs:
```powershell
node scripts/seed-profiles/validate.mjs --photos
node scripts/seed-profiles/validate.mjs --remote
```

Bronnen: [Firebase Admin SDK](https://firebase.google.com/docs/admin/setup),
[publieke Supabase-bestanden](https://supabase.com/docs/guides/storage/serving/downloads).
