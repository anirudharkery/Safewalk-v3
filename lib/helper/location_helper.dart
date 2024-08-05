// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// class LocationHelper{
//   void onLocationChanged(UserLocation userLocation) async {
//     if (disableMapControlUserTracking.value && trackingNotifier.value) {
//       await controller.moveTo(userLocation);
//       if (userLocationNotifier.value == null) {
//         await controller.addMarker(
//           userLocation,
//           markerIcon: MarkerIcon(
//             icon: Icon(Icons.location_on),
//           ),
//           angle: userLocation.angle,
//         );
//       } else {
//         await controller.changeLocationMarker(
//           oldLocation: userLocationNotifier.value!,
//           newLocation: userLocation,
//           angle: userLocation.angle,
//         );
//       }
//       userLocationNotifier.value = userLocation;
//     } else {
//       if (userLocationNotifier.value != null && !trackingNotifier.value) {
//         await controller.removeMarker(userLocationNotifier.value!);
//         userLocationNotifier.value = null;
//       }
//     }
//   }
// }