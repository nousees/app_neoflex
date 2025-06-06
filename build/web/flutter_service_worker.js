'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js": "b513054899cf26b41dfcf5fbada7b795",
"index.html": "2e57178282fb75e63c968ad53ab4ae1f",
"/": "2e57178282fb75e63c968ad53ab4ae1f",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"assets/NOTICES": "5a73ac440f9f2099e9f7a6a5907f8d08",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/assets/ai.png": "ef8f54c079a62aada53bb3617da7d95f",
"assets/assets/thermo_mug.jpg": "e4e562d09caaec8fcd884cd15f333b6b",
"assets/assets/badges/perfect_tapper.png": "51152afe212b65334410ce44744d0e40",
"assets/assets/badges/week.png": "9c4418bceda20fd8d1022176b426d512",
"assets/assets/badges/pair.png": "f02b18644c5e1f7a0bf0031f829f5ce3",
"assets/assets/badges/history_expert.png": "c6ac57fe80664a7cd1814d8a5a44c302",
"assets/assets/badges/loyal.png": "45b21fb679d0d4e15993ba1e687bd146",
"assets/assets/badges/flawless.png": "62dd0206a77e5d6aa42e023200968688",
"assets/assets/badges/tech.png": "f775ad670a66735d133ae7bb3ab9a416",
"assets/assets/badges/memory_legend.png": "72baf7f712cc285e34e7775d65f374c6",
"assets/assets/badges/achievement_master.png": "2406c86c3b906feb5ca8c559b2aa0eef",
"assets/assets/badges/collector.png": "fa0d6227f41e37aa2b48a73ecf108838",
"assets/assets/badges/memory.png": "cbc92ad5006df54cd158182ec1771ffe",
"assets/assets/badges/speedster.png": "0b93a8763ddf5864f0ad82853cd77f21",
"assets/assets/badges/genius.png": "f8056dde3331210c18c5313ec23f2bad",
"assets/assets/badges/veteran.png": "55af64dff5071d85168c6ffdf491aab0",
"assets/assets/badges/combo_master.png": "6f596a51214f14dd286a383ac6cc8453",
"assets/assets/cloud.png": "9194e3f0a74e64266cb3f5050b49ec66",
"assets/assets/blockchain.png": "4fe4e33c92512684085d19af1f8acb8c",
"assets/assets/water_bottle.jpg": "dab3ed9429d7638291605478a7a333f1",
"assets/assets/portable_speaker.jpg": "076a5a476522c3bf9cb13e7b2a86d5b1",
"assets/assets/notebook_set2.jpg": "4eb1d805aae382f38cfe4860cba8d4fa",
"assets/assets/notebook_set1.jpg": "803fa34bc05fddabebb9505bcc4ffbd8",
"assets/assets/logo.png": "630c0524305885277168232d56fab7ee",
"assets/assets/powerbank.jpg": "3f814ab8cc66e2b78cd7070a156d86fc",
"assets/assets/music_station.jpg": "3ab63ef9f6a38a7c1e5b414b7192865c",
"assets/fonts/MaterialIcons-Regular.otf": "50e30af8957082d9acbebe2492751103",
"assets/AssetManifest.bin.json": "e58fa9c13e378134edcd9657e4fb13af",
"assets/FontManifest.json": "7b2a36307916a9721811788013e65289",
"assets/AssetManifest.json": "61d49d501c6fcaf0f9d12e93ea57251e",
"assets/AssetManifest.bin": "f592119ea086f4074cea25dedc397f6b",
"manifest.json": "753148b216f4ae20a623d842f97bd529",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"version.json": "d20caf3174a26ae63ba4b9fe94bab789",
"flutter_bootstrap.js": "1df377d81f64d4474e9b039002492eb9",
"favicon.png": "5dcef449791fa27946b3d35ad8803796"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
