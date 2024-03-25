import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transmaa_dash/sidebuttons/verification.dart'; // Assuming ImageScreen is defined here

class InterestedInsurance extends StatelessWidget {
  Future<void> moveToCompletedCollection(String documentId) async {
    // Get the document reference from the original collection
    DocumentReference<Map<String, dynamic>> originalDocRef =
    FirebaseFirestore.instance.collection('Insurance').doc(documentId);

    // Get the document snapshot
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
    await originalDocRef.get();

    // Check if the document exists
    if (docSnapshot.exists) {
      // Get the data from the original document
      Map<String, dynamic> data = docSnapshot.data()!;

      // Add the document to the 'Completed' collection
      await FirebaseFirestore.instance
          .collection('CompletedInsurance')
          .doc(documentId)
          .set(data);

      // Delete the document from the original collection
      await originalDocRef.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backimage.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Insurance')
              .where('status', isEqualTo: 'Interested')
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            }
            return Column(
              children: [
                Text(
                  "Interested Detail's",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 25),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length ~/ 2,
                    itemBuilder: (context, index) {
                      int firstIndex = index * 2;
                      int secondIndex = index * 2 + 1;
                      return Row(
                        children: [
                          Expanded(
                            child: _buildCard(
                                snapshot.data!.docs[firstIndex],
                                onPressed: () {
                                  // Call the method to move document to 'Completed' collection
                                  moveToCompletedCollection(
                                      snapshot.data!.docs[firstIndex].id);
                                }),
                          ),
                          SizedBox(
                              width:
                              10), // Adjust the spacing between cards
                          Expanded(
                            child: secondIndex < snapshot.data!.docs.length
                                ? _buildCard(
                              snapshot.data!.docs[secondIndex],
                              onPressed: () {
                                // Call the method to move document to 'Completed' collection
                                moveToCompletedCollection(
                                    snapshot.data!.docs[secondIndex].id);
                              },
                            )
                                : Container(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard(QueryDocumentSnapshot<Map<String, dynamic>> document,
      {required VoidCallback onPressed}) {
    Map<String, dynamic> driver = document.data();
    String name = driver['name'];
    String status = driver['status'];
    String phoneNumber = driver['phoneNumber'] ?? ''; // Use empty string if null
    String rcNumber = driver['rcNumber'] ?? ''; // Use empty string if null
    String vehicleType = driver['vehicleType'] ?? ''; // Use empty string if null

    return Card(
      color: Colors.black.withOpacity(0.5),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $name',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellowAccent)),
            Text('Status: $status',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
            Text('Phone: $phoneNumber',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            Text('RC Number: $rcNumber',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            Text('Vehicle Type: $vehicleType',
                style: TextStyle(fontSize: 16, color: Colors.white)),
            SizedBox(height: 8),
            Divider(color: Colors.blue),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle button press
                  },
                  child: Text('Attended',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                      Colors.lightBlueAccent.withOpacity(0.4)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _updateStatus(String documentId, String status) {
    FirebaseFirestore.instance.collection('Insurance').doc(documentId).update({
      'status': status,
    }).then((value) {
      // Successfully updated
    }).catchError((error) {
      // Handle error
    });
  }
}
