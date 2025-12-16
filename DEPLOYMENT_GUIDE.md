# Quick Start Guide - MVP Deployment

## Pre-Deployment Checklist

### 1. Prerequisites Installed
- [ ] Node.js 20+ installed
- [ ] Flutter SDK 3.6.0+ installed
- [ ] Firebase CLI installed (`npm install -g firebase-tools`)
- [ ] Git installed

### 2. Accounts Created
- [ ] Firebase project created
- [ ] Twilio account created
- [ ] Google Cloud project created (same as Firebase)

### 3. APIs Enabled in Google Cloud Console
- [ ] Cloud Speech-to-Text API
- [ ] Cloud Text-to-Speech API
- [ ] Cloud Firestore API
- [ ] Firebase Hosting API

---

## Step-by-Step Deployment

### Step 1: Clone and Setup
```bash
# Clone repository
git clone https://github.com/bitvic/starter_architecture_flutter_firebase.git
cd starter_architecture_flutter_firebase

# Checkout MVP branch
git checkout copilot/add-mvp-ticket-chat

# Install Flutter dependencies
flutter pub get
```

### Step 2: Configure Firebase
```bash
# Login to Firebase
firebase login

# Initialize Firebase (if needed)
firebase init

# Configure FlutterFire
flutterfire configure
```

### Step 3: Setup Cloud Functions
```bash
cd functions

# Install dependencies
npm install

# Set environment variables
firebase functions:config:set \
  twilio.account_sid="YOUR_TWILIO_ACCOUNT_SID" \
  twilio.auth_token="YOUR_TWILIO_AUTH_TOKEN" \
  twilio.from_number="YOUR_TWILIO_PHONE_NUMBER"

# For local development
firebase functions:config:get > .runtimeconfig.json

# Build TypeScript
npm run build

cd ..
```

### Step 4: Deploy Firestore Rules and Indexes
```bash
# Deploy security rules and indexes
firebase deploy --only firestore
```

**Wait 2-3 minutes** for indexes to build. Check status:
```bash
firebase firestore:indexes
```

### Step 5: Deploy Cloud Functions
```bash
# Deploy functions
firebase deploy --only functions

# Note the deployed URLs - you'll need them for Twilio
```

Example output:
```
✔  functions[smsWebhook(us-central1)]: Successful create operation.
Function URL: https://us-central1-PROJECT_ID.cloudfunctions.net/smsWebhook

✔  functions[voiceMessageWebhook(us-central1)]: Successful create operation.
Function URL: https://us-central1-PROJECT_ID.cloudfunctions.net/voiceMessageWebhook
```

### Step 6: Configure Twilio Webhooks

1. Go to [Twilio Console](https://console.twilio.com/)
2. Navigate to Phone Numbers → Manage → Active Numbers
3. Click on your phone number
4. Configure webhooks:

**For SMS:**
- Messaging → A MESSAGE COMES IN
- Webhook URL: `https://REGION-PROJECT_ID.cloudfunctions.net/smsWebhook`
- HTTP Method: POST
- Save

**For MMS/Voice Messages:**
- Messaging → A MESSAGE COMES IN (same webhook handles MMS)
- Use the same URL as SMS

### Step 7: Build and Deploy Flutter Web
```bash
# Generate Riverpod code (if not already done)
flutter pub run build_runner build --delete-conflicting-outputs

# Build for web
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

### Step 8: Test the Deployment

#### Test SMS Booking Flow
1. Send SMS to your Twilio number:
   ```
   Chcę jechać z Warszawy do Krakowa jutro
   ```

2. You should receive a response with connection options

3. Reply with a number (e.g., "1")

4. Confirm with "tak"

5. You should receive booking confirmation

#### Test Web App
1. Open the deployed URL (from `firebase deploy --only hosting` output)
2. Login with phone number (use Firebase Phone Auth)
3. Navigate to "Moje Podróże" tab
4. You should see test bookings (if any were created via SMS)

---

## Troubleshooting

### Cloud Functions not deploying
```bash
# Check Firebase project
firebase projects:list

# Check you're on the right project
firebase use PROJECT_ID

# Re-deploy with verbose logging
firebase deploy --only functions --debug
```

### Twilio webhook not receiving messages
1. Check webhook URL is correct in Twilio console
2. Check Cloud Functions logs:
   ```bash
   firebase functions:log
   ```
3. Test webhook directly:
   ```bash
   curl -X POST https://REGION-PROJECT_ID.cloudfunctions.net/smsWebhook \
     -d "MessageSid=test123" \
     -d "From=+1234567890" \
     -d "Body=test message"
   ```

### Firestore permission denied
1. Check you deployed firestore rules:
   ```bash
   firebase deploy --only firestore:rules
   ```
2. Verify indexes are built (can take 5-10 minutes)
3. Check user is authenticated in the app

### Flutter build errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build web --release
```

---

## Environment-Specific URLs

### Development
- Web App: http://localhost:5000 (Firebase Hosting emulator)
- Functions: http://localhost:5001 (Functions emulator)

### Staging/Production
- Web App: https://PROJECT_ID.web.app or https://PROJECT_ID.firebaseapp.com
- Functions: https://REGION-PROJECT_ID.cloudfunctions.net

---

## Monitoring and Logs

### View Cloud Functions Logs
```bash
# All logs
firebase functions:log

# Follow logs in real-time
firebase functions:log --only smsWebhook

# Last 100 lines
firebase functions:log --lines 100
```

### View Firestore Usage
```bash
# Open Firebase Console
firebase open
# Navigate to Firestore → Usage
```

### Monitor Costs
- [Firebase Console → Usage and Billing](https://console.firebase.google.com/)
- Set up budget alerts in Google Cloud Console

---

## Next Steps After Deployment

1. ✅ Test SMS booking flow thoroughly
2. ✅ Test voice message (send audio via WhatsApp/Messenger)
3. ✅ Test web app login and chat
4. ⏳ Monitor logs for errors
5. ⏳ Set up error alerting (Sentry/Slack)
6. ⏳ Implement production checklist from SECURITY_SUMMARY.md
7. ⏳ Replace mock RailSearchProvider with real API
8. ⏳ Integrate payment gateway
9. ⏳ Add proper user management (phone → userId mapping)
10. ⏳ Implement rate limiting

---

## Support

For deployment issues:
1. Check logs: `firebase functions:log`
2. Review documentation: MVP_README.md, SECURITY_SUMMARY.md
3. Check Firebase Console for errors
4. Review Twilio Console for webhook delivery status

---

## Success Criteria

✅ MVP is successfully deployed when:
- [ ] SMS to Twilio number receives automated response
- [ ] User can complete booking flow via SMS
- [ ] Web app loads and allows phone login
- [ ] User can see bookings in "Moje Podróże"
- [ ] Chat screen opens and allows messaging
- [ ] No errors in Firebase Functions logs (during normal operation)

**Congratulations! Your MVP is live! 🎉**
