<div align="center">

<img src="assets/images/circular_app_icon.png" width="100" alt="Bela Blok Icon" />

# Bela Blok

Moderan digitalni blok za praćenje rezultata u kartaškoj igri Bela.

[![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://android.com)
[![SQLite](https://img.shields.io/badge/SQLite-%2307405e.svg?style=for-the-badge&logo=sqlite&logoColor=white)](https://sqlite.org)

</div>

---

## 📸 Prikaz sučelja

### Demo

<p align="center">
  <img src="assets/images/demo.gif" width="45%" alt="Demo prikaza rada aplikacije" />
</p>

### Svijetla / Tamna Tema

<p align="center">
  <img src="assets/images/games_screen_light.png" width="45%" alt="Ekran partija - Svijetli način" />
  &nbsp;
  <img src="assets/images/games_screen_dark.png" width="45%" alt="Ekran partija - Tamni način" />
</p>

<p align="center">
  <img src="assets/images/game_screen_light.png" width="45%" alt="Ekran igre - Svijetli način" />
  &nbsp;
  <img src="assets/images/game_screen_dark.png" width="45%" alt="Ekran igre - Tamni način" />
</p>

<p align="center">
  <img src="assets/images/players_screen_light.png" width="45%" alt="Ekran igrača - Svijetli način" />
  &nbsp;
  <img src="assets/images/players_screen_dark.png" width="45%" alt="Ekran igrača - Tamni način" />
</p>

---

## ✨ Značajke

- **Brzo i precizno upisivanje bodova**: Automatsko izračunavanje bodova za drugi par uz ugrađeni kalkulator i provjeru zvanja.
- **Podrška za varijante igre**: Biranje broja bodova do kuda se igra, smjera igranja i tko prvi miješa.
- **Pohrana i povijest**: Ugrađena SQLite baza podataka čuva sve vaše odigrane runde, aktivne i završene partije izravno na uređaju bez potrebe za internetom.
- **Moderan Material 3 dizajn**: Suvremeno korisničko sučelje s prirodnim animacijama, podrškom za dinamičke teme te svijetlim i tamnim načinom rada.

---

## 🏗️ Arhitektura projekta

Ovaj projekt je strukturiran za skalabilnost i čist kod:

- **Modeli (`/lib/models`)**: Povezuju UI s bazom podataka s pomoću modela podataka za partiju, rundu, zvanje i igrača.
- **Baza podataka (`/lib/database`)**: Koristi `sqflite` za lokalno i sigurno spremanje partija, igrača i povijesti rundi.
- **Ekrani (`/lib/screens`) i Widgeti (`/lib/widgets`)**: Ekrani su razbijeni na modularne i ponovno iskoristive komponente (dijalozi za unos i brisanje, kartice za prikaz igrača, partija i rundi) čime su ostali čisti i pregledni.
- **Preference (`/lib/services/app_preferences.dart`)**: Preference korisnika se spremaju lokalno (odabir svijetle/tamne teme, smjer igranja, tko prvi miješa) kako bi aplikacija pamtila postavke pri svakom pokretanju.

---

## 📥 Preuzimanje i instalacija

### Izravno preuzimanje (APK)

Preuzmite najnoviju verziju aplikacije izravno za vaš Android uređaj:

[![Download APK](https://img.shields.io/github/v/release/vujnovicmarko/bela_blok?label=Preuzmi%20APK&style=for-the-badge&color=2K8555)](https://github.com/vujnovicmarko/bela_blok/releases/latest)

- 📱 **[Izravno preuzimanje APK datoteke](https://github.com/vujnovicmarko/bela_blok/releases/latest/download/app-release.apk)**

### Provjera integriteta

Kako biste bili sigurni da preuzeta datoteka nije oštećena, možete usporediti SHA-1 otisak vaše datoteke s objavljenom `.sha1` datotekom iz izdanja:

```bash
# macOS / Linux
shasum -a 1 -c app-release.apk.sha1

# Windows PowerShell
(Get-FileHash app-release.apk -Algorithm SHA1).Hash
```

---

### Kompajliranje iz izvornog koda

```bash
# Klonirajte repozitorij
git clone [https://github.com/vujnovicmarko/bela_blok.git](https://github.com/vujnovicmarko/bela_blok.git)

# Uđite u direktorij
cd bela_blok

# Preuzmite ovisnosti
flutter pub get

# Izradite Android APK
flutter build apk --release
```
