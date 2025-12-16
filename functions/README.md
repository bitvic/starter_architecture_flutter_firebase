# Cloud Functions - Konfiguracja

## Instalacja zależności

```bash
cd functions
npm install
```

## Konfiguracja zmiennych środowiskowych

Należy skonfigurować następujące zmienne środowiskowe dla Cloud Functions:

```bash
firebase functions:config:set twilio.account_sid="YOUR_TWILIO_ACCOUNT_SID"
firebase functions:config:set twilio.auth_token="YOUR_TWILIO_AUTH_TOKEN"
firebase functions:config:set twilio.from_number="YOUR_TWILIO_PHONE_NUMBER"
```

Dla lokalnego developmentu, pobierz konfigurację:

```bash
firebase functions:config:get > .runtimeconfig.json
```

## Konfiguracja Twilio Webhooks

Po wdrożeniu funkcji, skonfiguruj webhooki w panelu Twilio:

### SMS Webhook
- **URL**: `https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/smsWebhook`
- **HTTP Method**: POST

### Voice Message Webhook (MMS)
- **URL**: `https://YOUR_REGION-YOUR_PROJECT_ID.cloudfunctions.net/voiceMessageWebhook`
- **HTTP Method**: POST

## Kompilacja

```bash
npm run build
```

## Uruchomienie lokalnie (emulator)

```bash
npm run serve
```

## Wdrożenie

```bash
npm run deploy
```

lub z głównego katalogu projektu:

```bash
firebase deploy --only functions
```

## Konfiguracja Google Cloud Speech-to-Text i Text-to-Speech

1. W Google Cloud Console, włącz API:
   - Cloud Speech-to-Text API
   - Cloud Text-to-Speech API

2. Upewnij się, że konto serwisowe Firebase ma odpowiednie uprawnienia

## Struktura

- `src/providers/` - Providery dla zewnętrznych serwisów (Twilio, Google Cloud)
- `src/services/` - Logika biznesowa (Orchestrator, Chat)
- `src/webhooks/` - Endpointy HTTP dla webhooków
- `src/types/` - Definicje typów TypeScript

## Testowanie

Możesz testować webhooki lokalnie używając narzędzi takich jak ngrok lub używając Firebase Emulators.

## Uwagi MVP

W wersji MVP:
- RailSearchProvider używa mock danych - w produkcji należy zintegrować z API PKP/PolRegio
- TicketingProvider automatycznie potwierdza rezerwacje - w produkcji należy dodać integrację płatności
- NLU jest uproszczone (regex) - w produkcji należy użyć DialogFlow, LUIS lub własnego modelu
