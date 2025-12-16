# MVP: Ticket-by-Call/SMS + In-Train Chat

## Przegląd projektu

Aplikacja webowa (Flutter Web) umożliwiająca:
1. **Rezerwację biletów kolejowych** przez SMS/głosówkę (WhatsApp/Messenger/MMS)
2. **Logowanie przez SMS OTP** (Firebase Phone Authentication)
3. **Czat grupowy pasażerów** w pociągu

## Architektura systemu

### Backend (Cloud Functions)
- **Webhooks**: Obsługa SMS i wiadomości głosowych z Twilio
- **Orchestrator**: Zarządzanie konwersacją (NLU, sloty, intencje)
- **Providers**: Abstrakcje dla Twilio, Google Cloud Speech-to-Text, Text-to-Speech
- **Services**: ChatService, RailSearchProvider (mock), TicketingProvider

### Frontend (Flutter Web)
- **Autentykacja**: Firebase Phone Auth (OTP)
- **My Trips Screen**: Lista rezerwacji użytkownika
- **Chat Screen**: Czat grupowy dla pasażerów tego samego pociągu
- **Routing**: GoRouter z nawigacją zagnieżdżoną (StatefulShellRoute)
- **State Management**: Riverpod

### Baza danych (Firestore)
```
- users/{uid}
- conversationSessions/{sessionId}
- bookings/{bookingId}
- chats/{connectionInstanceId}
  - messages/{messageId}
- processedMessages/{messageId}
- auditLogs/{id}
```

## Instalacja i konfiguracja

### Wymagania
- Node.js 20+
- Flutter SDK 3.6.0+
- Firebase CLI
- Konto Twilio
- Konto Google Cloud (dla Speech-to-Text i Text-to-Speech API)

### 1. Klonowanie repozytorium

```bash
git clone <repo-url>
cd starter_architecture_flutter_firebase
```

### 2. Konfiguracja Firebase

```bash
# Zaloguj się do Firebase
firebase login

# Inicjalizuj projekt (jeśli jeszcze nie)
flutterfire configure
```

### 3. Konfiguracja Cloud Functions

```bash
cd functions
npm install

# Ustaw zmienne środowiskowe Twilio
firebase functions:config:set twilio.account_sid="YOUR_ACCOUNT_SID"
firebase functions:config:set twilio.auth_token="YOUR_AUTH_TOKEN"
firebase functions:config:set twilio.from_number="YOUR_PHONE_NUMBER"

# Dla developmentu lokalnego
firebase functions:config:get > .runtimeconfig.json
```

### 4. Włączenie Google Cloud APIs

W Google Cloud Console, włącz:
- Cloud Speech-to-Text API
- Cloud Text-to-Speech API
- Cloud Firestore API

### 5. Instalacja zależności Flutter

```bash
flutter pub get
```

### 6. Generowanie kodu Riverpod

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 7. Wdrożenie

#### Wdrożenie Cloud Functions
```bash
firebase deploy --only functions
```

#### Wdrożenie Firestore Rules i Indexes
```bash
firebase deploy --only firestore
```

#### Build i wdrożenie Flutter Web
```bash
flutter build web
firebase deploy --only hosting
```

## Konfiguracja Twilio

Po wdrożeniu Cloud Functions, skonfiguruj webhooki w panelu Twilio:

### SMS Webhook
- URL: `https://REGION-PROJECT_ID.cloudfunctions.net/smsWebhook`
- HTTP Method: POST

### Voice Message Webhook (MMS)
- URL: `https://REGION-PROJECT_ID.cloudfunctions.net/voiceMessageWebhook`
- HTTP Method: POST

## Użycie aplikacji

### Dla użytkownika końcowego

1. **Wyszukiwanie połączenia przez SMS**
   ```
   Wyślij SMS: "Chcę jechać z Warszawy do Krakowa jutro"
   ```

2. **Wybór połączenia**
   ```
   System odpowie listą połączeń. Odpowiedz: "1" (numer wybranego połączenia)
   ```

3. **Potwierdzenie rezerwacji**
   ```
   System poprosi o potwierdzenie. Odpowiedz: "Tak"
   ```

4. **Logowanie do aplikacji webowej**
   - Otwórz aplikację w przeglądarce
   - Zaloguj się przez Phone OTP
   - Przejdź do zakładki "Moje Podróże"
   - Kliknij na rezerwację, aby otworzyć czat

### Dla developera

#### Testowanie lokalnie
```bash
# Uruchom Firebase Emulators
firebase emulators:start

# Uruchom Flutter web
flutter run -d chrome
```

#### Logi Cloud Functions
```bash
firebase functions:log
```

## Struktura projektu

```
starter_architecture_flutter_firebase/
├── functions/              # Cloud Functions (TypeScript)
│   ├── src/
│   │   ├── providers/      # Twilio, ASR, TTS, Rail Search
│   │   ├── services/       # Chat, Orchestrator
│   │   ├── webhooks/       # SMS, Voice Message endpoints
│   │   └── types/          # TypeScript types
│   └── package.json
├── lib/                    # Flutter app
│   └── src/
│       ├── features/
│       │   ├── authentication/
│       │   ├── bookings/   # Rezerwacje (domain, data, presentation)
│       │   ├── chat/       # Czat (domain, data, presentation)
│       │   ├── entries/    # Stare (do usunięcia w przyszłości)
│       │   └── jobs/       # Stare (do usunięcia w przyszłości)
│       ├── routing/        # GoRouter configuration
│       └── common_widgets/
├── firestore.rules         # Reguły bezpieczeństwa Firestore
├── firestore.indexes.json  # Indeksy Firestore
└── firebase.json           # Konfiguracja Firebase
```

## MVP - Ograniczenia i TODO

### Zaimplementowane w MVP
- ✅ Backend webhooks dla SMS i głosówek
- ✅ Orchestrator z prostym NLU (regex-based)
- ✅ Mock RailSearchProvider (dane testowe)
- ✅ TicketingProvider (auto-potwierdzanie rezerwacji)
- ✅ ChatService (real-time Firestore)
- ✅ Flutter screens: My Trips, Chat
- ✅ Firestore security rules
- ✅ Routing z bottom navigation

### TODO (poza MVP)
- ⏳ Prawdziwa integracja z API PKP/PolRegio
- ⏳ System płatności (Stripe/PayU)
- ⏳ Zaawansowane NLU (DialogFlow/LUIS)
- ⏳ Obsługa połączeń głosowych w czasie rzeczywistym (Voice Call)
- ⏳ Wysyłanie SMS potwierdzających z QR code biletu
- ⏳ Powiadomienia push o zmianach w rozkładzie
- ⏳ Panel administracyjny
- ⏳ Usunięcie starych features (jobs, entries)
- ⏳ Tłumaczenie całego UI na polski
- ⏳ Aplikacje mobilne (Android/iOS)

## Bezpieczeństwo

### Firestore Rules
- Użytkownicy widzą tylko swoje rezerwacje
- Dostęp do czatu tylko dla uczestników (posiadaczy biletów)
- Sesje konwersacji dostępne tylko dla backend
- Wiadomości można tylko dodawać, nie edytować/usuwać

### Deduplication
- Każda wiadomość SMS/głosówka jest sprawdzana przed przetworzeniem
- Używamy `MessageSid` jako unikalnego identyfikatora

### Rate Limiting
TODO: Dodać rate limiting dla webhooków

## Koszty szacunkowe (MVP - małe użycie)

- **Twilio**: ~0.20 PLN/SMS, ~0.15 PLN/min głos
- **Google Cloud Speech-to-Text**: ~$0.006/15s audio
- **Google Cloud Text-to-Speech**: ~$4/1M znaków
- **Firebase Firestore**: Darmowe do 50K odczytów/dzień
- **Firebase Cloud Functions**: Darmowe do 2M wywołań/miesiąc

## Wsparcie

Dla pytań technicznych, otwórz issue na GitHub lub skontaktuj się z zespołem.

## Licencja

MIT License - szczegóły w pliku LICENSE.md
