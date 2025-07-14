// Give the service worker access to Firebase Messaging.
// Note that you can only use Firebase Messaging here. Other Firebase libraries
// are not available in the service worker.
importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js");

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
// https://firebase.google.com/docs/web/setup#config-object
firebase.initializeApp({
  apiKey: "AIzaSyAgrclF-hKmYYrzaYE1flCbqnRRXW4VSJY",
  authDomain: "foodeat-96046.firebaseapp.com",
  projectId: "foodeat-96046",
  storageBucket: "foodeat-96046.appspot.com",
  messagingSenderId: "520455028754",
  appId: "1:520455028754:web:00c8155db89d4397a798cb",
  measurementId: "G-WN0DZ809X3"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});