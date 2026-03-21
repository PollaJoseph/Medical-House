import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMapPicker extends StatefulWidget {
  final void Function(String address, double lat, double lng) onLocationPicked;

  const CustomMapPicker({Key? key, required this.onLocationPicked})
    : super(key: key);

  @override
  State<CustomMapPicker> createState() => _CustomMapPickerState();
}

class _CustomMapPickerState extends State<CustomMapPicker> {
  final MapController _mapController = MapController();

  // 1. We manually track the center to prevent null crashes
  LatLng _currentCenter = const LatLng(24.7136, 46.6753);
  bool _isLoading = false;

  Future<void> _confirmLocation() async {
    setState(() => _isLoading = true);

    try {
      // Use the tracked center, NOT _mapController
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentCenter.latitude,
        _currentCenter.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        List<String> addressParts = [];
        if (place.street != null && place.street!.isNotEmpty)
          addressParts.add(place.street!);
        if (place.subLocality != null && place.subLocality!.isNotEmpty)
          addressParts.add(place.subLocality!);
        if (place.locality != null && place.locality!.isNotEmpty)
          addressParts.add(place.locality!);
        if (place.administrativeArea != null &&
            place.administrativeArea!.isNotEmpty)
          addressParts.add(place.administrativeArea!);

        String formattedAddress = addressParts.join(", ");
        if (formattedAddress.isEmpty) formattedAddress = "Selected Location";

        widget.onLocationPicked(
          formattedAddress,
          _currentCenter.latitude,
          _currentCenter.longitude,
        );
      } else {
        widget.onLocationPicked(
          "${_currentCenter.latitude}, ${_currentCenter.longitude}",
          _currentCenter.latitude,
          _currentCenter.longitude,
        );
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
      // Safe Fallback: Even if it fails, send the coordinates so the backend doesn't get 0.0
      widget.onLocationPicked(
        "${_currentCenter.latitude}, ${_currentCenter.longitude}",
        _currentCenter.latitude,
        _currentCenter.longitude,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color midnightNavy = Color(0xFF0D1B34);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _currentCenter,
              zoom: 15.0,
              maxZoom: 18.0,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              // 2. THIS IS THE FIX: Update coordinates instantly when the user drags the map
              onPositionChanged: (MapPosition position, bool hasGesture) {
                if (position.center != null) {
                  _currentCenter = position.center!;
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.medicalhouse.app',
              ),
            ],
          ),

          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 40.h),
              child: Icon(
                Icons.location_on,
                color: midnightNavy,
                size: 50.sp,
                shadows: const [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 30.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              height: 60.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: midnightNavy.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmLocation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: midnightNavy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: 24.h,
                        width: 24.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Confirm Address",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),

          Positioned(
            top: 50.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: midnightNavy,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
