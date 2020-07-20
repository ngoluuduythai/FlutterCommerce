import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommerce/src/bloc/base_states/result_state/result_state.dart';
import 'package:fluttercommerce/src/di/app_injector.dart';
import 'package:fluttercommerce/src/models/order_model.dart';
import 'package:fluttercommerce/src/repository/firestore_repository.dart';

class MyOrdersCubit extends Cubit<ResultState<List<OrderModel>>> {
  var firebaseRepo = AppInjector.get<FirestoreRepository>();

  MyOrdersCubit() : super(ResultState.idle());
  List<DocumentSnapshot> _documents;
  List<OrderModel> _orderList;

  fetchOrders() async {
    emit(ResultState.loading());
    try {
      _documents = await firebaseRepo.getAllOrders();

      _orderList = List<OrderModel>.generate(_documents.length, (index) {
        print(_documents[index].data);
        return OrderModel.fromJson(_documents[index]);
      });
      emit(ResultState.data(data: _orderList.toSet().toList()));
    } catch (e) {
      emit(ResultState.error(error: e.toString()));
    }
  }

  fetchNextList() async {
    try {
      List<DocumentSnapshot> docs =
          await firebaseRepo.getAllOrders(_documents[_documents.length - 1]);
      _documents.addAll(docs);
      _orderList = List<OrderModel>.generate(
          _documents.length, (index) => OrderModel.fromJson(_documents[index]));
      emit(ResultState.data(data: _orderList.toSet().toList()));
    } catch (e) {
      print(e);
      emit(ResultState.unNotifiedError(error: e.toString(), data: _orderList));
    }
  }
}
