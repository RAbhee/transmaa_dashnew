import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transmaa_dash/sidebuttons/rejected.dart';
import 'package:transmaa_dash/sidebuttons/verified.dart';

class VerificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verification'),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.green),
            onPressed: () {
              FirebaseFirestore.instance.collection('Driver').get().then((querySnapshot) {
                // Fetch the driverData from the current snapshot
                QueryDocumentSnapshot<Map<String, dynamic>> driverData = querySnapshot.docs[0]; // Assuming you want the first document
                FirebaseFirestore.instance.collection('Driver').doc(driverData.id).update({'status': 'verified'}).then((_) {
                  // Navigate to RejectedScreen and pass driverData
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VerifiedScreen(driverData)),
                  );
                });
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.close, color: Colors.red),
            onPressed: () {
              FirebaseFirestore.instance.collection('Driver').get().then((querySnapshot) {
                // Fetch the driverData from the current snapshot
                QueryDocumentSnapshot<Map<String, dynamic>> driverData = querySnapshot.docs[0]; // Assuming you want the first document
                FirebaseFirestore.instance.collection('Driver').doc(driverData.id).update({'status': 'not verified'}).then((_) {
                  // Navigate to RejectedScreen and pass driverData
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RejectedScreen(driverData)),
                  );
                });
              });
            },
          ),

        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('Driver').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot<Map<String, dynamic>> driverData = snapshot.data!.docs[index];
              Map<String, dynamic> driver = driverData.data();
              String imageUrl = driver['image'];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Driver ${index + 1}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ImageScreen(imageUrl)),
                          );
                        },
                        child: Image.network(
                          imageUrl,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 15),
                      Divider(color: Colors.grey),
                      SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: driver.entries.map((entry) {
                          return Text(
                            '${entry.key}: ${entry.value}',
                            style: TextStyle(fontSize: 16),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.check, size: 30, color: Colors.green),
                            onPressed: () {
                              FirebaseFirestore.instance.collection('Driver').doc(driverData.id).update({'status': 'verified'}).then((_) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => VerifiedScreen(driverData)),
                                );
                              });
                            },
                          ),
                          SizedBox(width: 10),
                          IconButton(
                            icon: Icon(Icons.close, size: 30, color: Colors.red),
                            onPressed: () {
                              FirebaseFirestore.instance.collection('Driver').doc(driverData.id).update({'status': 'rejected'}).then((_) {
                                // Navigate to RejectedScreen and pass driverData
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => RejectedScreen(driverData)),
                                );
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ImageScreen extends StatelessWidget {
  final String imageUrl;

  ImageScreen(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image'),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Text('');
          },
        ),
      ),
    );
  }
}
