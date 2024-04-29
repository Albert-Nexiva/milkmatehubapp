import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:milkmatehub/local_storage/key_value_storage_service.dart';
import 'package:milkmatehub/models/feed_model.dart';
import 'package:milkmatehub/models/feedback_model.dart';
import 'package:milkmatehub/models/insurance_model.dart';
import 'package:milkmatehub/models/order_model.dart';
import 'package:milkmatehub/models/production_record_model.dart';
import 'package:milkmatehub/models/supplier_model.dart';
import 'package:milkmatehub/models/user_model.dart';

class FirestoreDB {
  final db = FirebaseFirestore.instance;

  Future<void> addFeed(FeedModel feed) async {
    try {
      final data = await db
          .collection('feedCollection')
          .doc(feed.feedId)
          .set(feed.toJson());
      return data;
    } catch (e) {
      throw Exception('Error adding feed: $e');
    }
  }

  Future<void> addFeedback(FeedbackModel feedback) async {
    try {
      final data = await db
          .collection('feedbackCollection')
          .doc(feedback.feedbackId)
          .set(feedback.toJson());
      return data;
    } catch (e) {
      throw Exception('Error adding feedback: $e');
    }
  }

  Future<void> addInsuranceApplication(InsuranceModel record) async {
    try {
      final data = await db
          .collection('insuranceCollection')
          .doc(record.uid)
          .set(record.toJson());
      return data;
    } catch (e) {
      throw Exception('Error adding insurance record: $e');
    }
  }

  Future<void> addProductionRecord(ProductionRecordModel record) async {
    try {
      final data = await db
          .collection('productionRecordCollection')
          .doc(record.id)
          .set(record.toJson());
      return data;
    } catch (e) {
      throw Exception('Error adding production record: $e');
    }
  }

  Future<void> addSupplier(SupplierModel doc) async {
    try {
      final data = await db
          .collection('supplierCollection')
          .doc(doc.uid)
          .set(doc.toJson());
      return data;
    } catch (e) {
      throw Exception('Error adding supplier: $e');
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      final data = await db
          .collection('userCollection')
          .doc(user.uid)
          .set(user.toJson());
      return data;
    } catch (e) {
      throw Exception('Error adding user: $e');
    }
  }

  Future<void> approveInsuranceClaim(String claimId) async {
    try {
      await db.collection('insuranceCollection').doc(claimId).update({
        'status': 'approved',
      });
      return;
    } catch (e) {
      throw Exception('Error approving insurance claim: $e');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    try {
      await db.collection('orderCollection').doc(orderId).delete();
    } catch (e) {
      throw Exception('Error cancelling order: $e');
    }
  }

  Future<void> deleteFeed(String feedId) async {
    try {
      await db.collection('feedCollection').doc(feedId).delete();
    } catch (e) {
      throw Exception('Error deleting feed: $e');
    }
  }

  Future<void> deleteSupplier(String supplierId) async {
    try {
      await db.collection('supplierCollection').doc(supplierId).delete();
    } catch (e) {
      throw Exception('Error deleting supplier: $e');
    }
  }

  Future<void> editFeed(FeedModel updatedFeed) async {
    try {
      final data = await db
          .collection('feedCollection')
          .doc(updatedFeed.feedId)
          .update(updatedFeed.toJson());
      return data;
    } catch (e) {
      throw Exception('Error editing feed: $e');
    }
  }

  Future<void> editSupplier(SupplierModel updatedSupplier) async {
    try {
      final data = await db
          .collection('supplierCollection')
          .doc(updatedSupplier.uid)
          .update(updatedSupplier.toJson());
      return data;
    } catch (e) {
      throw Exception('Error editing supplier: $e');
    }
  }

  Future<List<ProductionRecordModel>> getAllProductionRecords() async {
    try {
      final snapshot = await db.collection('productionRecordCollection').get();
      return snapshot.docs
          .map((doc) => ProductionRecordModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting production records: $e');
    }
  }

  Future<List<SupplierModel>> getAllSuppliers() async {
    try {
      final snapshot = await db.collection('supplierCollection').get();
      return snapshot.docs
          .map((doc) => SupplierModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting supplier records: $e');
    }
  }

  Future<List<FeedModel>> getFeedList() async {
    try {
      final snapshot = await db.collection('feedCollection').get();
      return snapshot.docs
          .map((doc) => FeedModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting supplier: $e');
    }
  }

  Future<List<InsuranceModel>> getInsuanceClaimList() async {
    try {
      CacheStorageService cacheStorageService = CacheStorageService();
      final user = await cacheStorageService.getAuthUser();
      final snapshot = await db
          .collection('insuranceCollection')
          .where('supplierId', isEqualTo: user!.uid)
          .get();
      return snapshot.docs
          .map((doc) => InsuranceModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting insurance claims: $e');
    }
  }

  Future<List<InsuranceModel>> getInsuranceClaims() async {
    try {
      final snapshot = await db.collection('insuranceCollection').get();
      return snapshot.docs
          .map((doc) => InsuranceModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting insurance claims: $e');
    }
  }

  Future<List<OrderModel>> getMyOrders() async {
    try {
      CacheStorageService cacheStorageService = CacheStorageService();
      final user = await cacheStorageService.getAuthUser();
      final snapshot = await db
          .collection('orderCollection')
          .where('supplierId', isEqualTo: user!.uid)
          .get();
      return snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting orders: $e');
    }
  }

  Future<List<ProductionRecordModel>> getProductionRecords() async {
    try {
      CacheStorageService cacheStorageService = CacheStorageService();
      final user = await cacheStorageService.getAuthUser();
      final snapshot = await db
          .collection('productionRecordCollection')
          .where('supplierId', isEqualTo: user!.uid)
          .get();
      return snapshot.docs
          .map((doc) => ProductionRecordModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting production records: $e');
    }
  }

  Future<Map<String, dynamic>?> getSupplier(String uid) async {
    try {
      final snapshot = await db.collection('supplierCollection').doc(uid).get();
      return snapshot.data();
    } catch (e) {
      throw Exception('Error getting supplier: $e');
    }
  }

  Future<List<UserModel>> getSubscriptions() async {
    try {
      final snapshot = await db.collection('userCollection').get();
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Error getting supplier: $e');
    }
  }

  Future<Map<String, dynamic>?> getUser(String uid, bool isSupplier) async {
    try {
      final snapshot = await db
          .collection(isSupplier ? 'supplierCollection' : 'userCollection')
          .doc(uid)
          .get();
      return snapshot.data();
    } catch (e) {
      throw Exception('Error getting user: $e');
    }
  }

  Future<void> placeOrder(OrderModel order) async {
    try {
      final data = await db
          .collection('orderCollection')
          .doc(order.orderId)
          .set(order.toJson());
      return data;
    } catch (e) {
      throw Exception('Error placing order: $e');
    }
  }

  Future<void> rejectInsuranceClaim(String claimId) async {
    try {
      await db.collection('insuranceCollection').doc(claimId).delete();
    } catch (e) {
      throw Exception('Error rejecting insurance claim: $e');
    }
  }

  Future<void> updateUserSubscription(UserModel user) async {
    try {
      final data = await db
          .collection('userCollection')
          .doc(user.uid)
          .update(user.toJson());
      return data;
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }
}
