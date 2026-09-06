# 👋🧩 Morphe Patches template

Template repository for Morphe Patches.

## ❓ About

Patches for apps I like.

<!-- TODO: Update this about section with a brief introduction/summary about this repo and what it offers. -->

### How to use these patches

Click here to add these patches to Morphe: https://morphe.software/add-source?github=JustOptimize/morphe-patches

## 🩹 Patches list

<!-- PATCHES_START EXPANDED -->
> **[v1.0.0](https://github.com/JustOptimize/morphe-patches/releases/tag/v1.0.0)**&nbsp;&nbsp;•&nbsp;&nbsp;`main`&nbsp;&nbsp;•&nbsp;&nbsp;12 patches total
<details open>
<summary>📦 Waze&nbsp;&nbsp;•&nbsp;&nbsp;12 patches</summary>
<br>

**🎯 Supported versions:**

| 5.21.90.800 |
| :---: |

| 💊&nbsp;Patch | 📜&nbsp;Description | ⚙️&nbsp;Options |
|----------|----------------|-----------|
| [Alert Distances](#alert-distances) | Configures radar/camera and hazard alert announcement distances.<br>Writes all key variants (truncated _ + underscore + space) for resilience across versions.<br>Credits: Waze CGE Mod.<br>Official → default values (metres):<br>Accident 600→2000 | Alert 600→1000 | Police 600→1000 |<br>Freeways 2000→1200 | Highways 1000→900 | Streets 500→700 |<br>Hazard 600→500 | Heavy Traffic 600→3000 | Between Alerts 300→200 | • Accident alert (m)<br>• General alert (m)<br>• Police / camera alert (m)<br>• Enforcement — freeways (m)<br>• Enforcement — highways (m)<br>• Enforcement — streets (m)<br>• Hazard alert (m)<br>• Heavy traffic alert (m)<br>• Min between alerts (m) |
| [AutoZoom](#autozoom) | Controls how aggressively the map zooms in/out based on driving speed.<br>Credits: Waze Chuppito Mod (Speed Factor 20, Gradient Speed Threshold 60). | • Speed factor<br>• Scale factor<br>• Max scale<br>• Gradient speed threshold (km/h) |
| [Disable Ads](#disable-ads) | Suppresses all Waze ad systems via bundled preferences file:<br>• AdMob SDK (Ad_.*)<br>• Google Ads (Google_Ads.*)<br>• Ads Inventory Prediction<br>• ExternalPOI pins, coupons, popups (ExternalPO_ + Extern__POI both key variants)<br>• Search autocomplete server ads<br>Credits: Waze CGE Mod (ExternalPOI keys), Waze Chuppito (dual-key coverage). |  |
| [Disable Advil Ad Requests](#disable-advil-ad-requests) | Stubs AdvilRequest.getPageUrl() → "" so the Advil ad server receives no page URL and returns no ad content. Target: Lcom/waze/jni/protos/AdvilRequest;->getPageUrl() in classes6.dex (verified ✓). |  |
| [Enlarged Speedometer](#enlarged-speedometer) | Increases speedometer digit size for better readability.<br>Default: speed < 100 → 28sp (orig 20sp), speed ≥ 100 → 21sp (orig 13sp).<br>Target: Lcom/waze/main_screen/h/b/d;->f() in classes6.dex (verified ✓).<br>Note: the two const/16 values are non-consecutive (goto between them) — scanned independently. | • Text size — speed below 100<br>• Text size — speed 100+ |
| [Map Skin (Vitamin C)](#map-skin-vitamin-c) | Applies Chuppito's 'Vitamin C' map skin. All visual values configurable.<br>• Night: true black AMOLED background (saves battery, prevents burn-in)<br>• Day: warm beige background<br>• Larger font labels across the board<br>• Wider navigation arrow head for better visibility<br>Note: skin changes require a fresh APK install; updating an existing patched install may keep cached skin files.<br>Credits: ALEX02-GTT (skin design), Waze Chuppito Mod (integration). | • Night background color (hex)<br>• Day background color (hex)<br>• Font size — huge labels<br>• Font size — big labels<br>• Font size — medium labels<br>• Font size — small labels<br>• Nav arrow head width factor |
| [Navigation & Map](#navigation-map) | Configures navigation and map behaviour:<br>• Nearing destination distance (Credits: CGE Mod)<br>• Android Auto head-up alert distances<br>• Map turn mode (auto-zoom to upcoming turn)<br>• Traffic bar minimum time threshold<br>• GPS icon visibility<br>• Route notifications (hazard, school zone) — both disabled by default<br>Credits: Waze CGE Mod (nearing destination), Waze Chuppito (remaining keys). | • Nearing destination distance (m)<br>• Android Auto head-up — normal roads (m)<br>• Android Auto head-up — freeways (m)<br>• Traffic bar min time in traffic (seconds)<br>• Show GPS icon on map<br>• Map turn mode (auto-zoom to turn)<br>• Permanent hazard route notification<br>• School zone route notification |
| [Popup Suppression](#popup-suppression) | Prevents promotional and ad popups from appearing while driving.<br>Raises the minimum trigger speed to a near-impossible value so popups never appear.<br>Writes both Popup_ and Popu__ key variants for version resilience.<br>Credits: Waze Chuppito Mod. | • Min speed to show popups (MMSec)<br>• Fully stopped speed (MMSec)<br>• Min distance to show popup (m)<br>• Min reset scroll speed (MMSec)<br>• Delay after user interaction (seconds) |
| [Radar Sound (Any Speed)](#radar-sound-any-speed) | Plays radar/speed camera sound alerts regardless of current speed. Official Waze only alerts when over the speed limit.<br>Patches CONFIG_VALUE_ALERTS_PLAY_SPEED_CAMERA_SOUND_BELOW_SPEED_LIMIT (ordinal 632) via setConfigValueBoolNTV on every server config sync.<br>Target: Lcom/waze/ConfigManager;->onConfigSyncedFromServer() in classes5.dex (verified ✓). |  |
| [Report Speed Limit](#report-speed-limit) | Adds a Report option when tapping the speedometer to report wrong or missing speed limits. Not available in the official version.<br>Key: Map.Speedometer report speed enable_: 1 |  |
| [Speed Limit Sign](#speed-limit-sign) | Sets the speed limit sign style shown on the map.<br>• us (default) — large circular US-style sign, more readable at a glance<br>• metric — smaller local-style sign<br>Key: Map.Speedometer sign style | • Sign style |
| [Uncensored Radar / Camera Display](#uncensored-radar-camera-display) | Shows exact fixed and mobile speed camera locations, including those not yet in the official Waze radar zone. Enables enforcement alerts via preferences keys:<br>Alerts.Enable Enforcement Alert_ / Alert / Polic_ (truncated + full variants).<br>Credits: Waze CGE Mod. |  |

</details>

<!-- PATCHES_END -->

### 🛠️ Building locally

- Run `./gradlew buildAndroid`
- The built patches .mpp file is found in `patches/build/libs/patches-*.mpp`
- Patch the mpp file using [Morphe-Desktop](https://github.com/MorpheApp/morphe-desktop)
  like any other patch bundle.

See the [Morphe documentation](https://github.com/MorpheApp/morphe-documentation) for more information.

## 📜 License

UserXYZ Patches are licensed under the [GNU General Public License v3.0](LICENSE)
