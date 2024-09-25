import 'package:flutter/material.dart';

class LocationSelection extends StatelessWidget {
  const LocationSelection({
    super.key,
    required this.startAddress,
    required this.destinationAddress,
    required this.searchLocation,
  });
  final String startAddress;
  final String destinationAddress;
  final void Function(BuildContext, String, bool) searchLocation;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.circle, color: Colors.black, size: 15.0),
                hintText: 'Santa Clara University',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (value) {
                value = startAddress;
                searchLocation(context, value, true);
              },
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.circle, color: Colors.grey, size: 15.0),
                hintText: 'Where to?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
              onSubmitted: (value) {
                // setState(() {
                //   destinationAddress = value;
                // });
                value = destinationAddress;
                searchLocation(context, value, false);
              },
            ),
            // ListTile(
            //   style: ListTileStyle(

            //   ),
            //   leading: Icon(Icons.bookmark, color: Colors.black),
            //   title: Text('Saved Places'),
            //   trailing: Icon(Icons.arrow_forward_ios),
            //   onTap: () {
            //     // Navigate to saved places
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
