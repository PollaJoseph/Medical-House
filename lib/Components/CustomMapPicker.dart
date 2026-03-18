import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomMapPicker extends StatefulWidget {
  final Function(String address) onLocationPicked;

  const CustomMapPicker({Key? key, required this.onLocationPicked})
    : super(key: key);

  @override
  State<CustomMapPicker> createState() => _CustomMapPickerState();
}

class _CustomMapPickerState extends State<CustomMapPicker> {
  final MapController _mapController = MapController();
  final LatLng _initialCenter = LatLng(
    24.7136,
    46.6753,
  ); // Centered on Riyadh, KSA // Centered on Cairo
  bool _isLoading = false;

  Future<void> _confirmLocation() async {
    setState(() => _isLoading = true);

    try {
      // Get the exact coordinates from the center of the map
      final center = _mapController.center;

      // Convert coordinates to a readable address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        center.latitude,
        center.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String formattedAddress =
            "${place.street}, ${place.subLocality}, ${place.administrativeArea}";
        // Remove empty segments if any
        formattedAddress = formattedAddress
            .replaceAll(RegExp(r'^, |, $'), '')
            .replaceAll(', ,', ',');

        widget.onLocationPicked(formattedAddress);
      } else {
        widget.onLocationPicked("${center.latitude}, ${center.longitude}");
      }
    } catch (e) {
      debugPrint("Geocoding Error: $e");
      widget.onLocationPicked(
        "${_mapController.center.latitude}, ${_mapController.center.longitude}",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color midnightNavy = Color(0xFF0D1B34);
    const Color surgicalTeal = Color(0xFF0CACBB);

    return Scaffold(
      body: Stack(
        children: [
          // 1. The Raw OSM Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _initialCenter,
              zoom: 15.0,
              maxZoom: 18.0,
              interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.medicalhouse.app',
              ),
            ],
          ),

          // 2. The Fixed Center Pin
          Center(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 40.h,
              ), // Offset to align pin tip with center
              child: Icon(
                Icons.location_on,
                color: midnightNavy,
                size: 50.sp,
                shadows: [
                  Shadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
          ),

          // 3. Floating Action UI
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

          // Custom Back Button
          Positioned(
            top: 50.h,
            left: 20.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
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
