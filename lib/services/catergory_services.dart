import 'package:dio/dio.dart';
import 'package:ssd_app/consts/constant.dart';
import 'package:ssd_app/models/category.dart';

class CategoryService {
  final Dio _dio = Dio();

  Future<List<Category>> fetchCategories(String authToken) async {
    try {
      final response = await _dio.get(
        '${BASE_URL}customer/get-categories',
        options: Options(
          headers: {
            'Authorization': 'Bearer $authToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoryList = response.data['data'];
        final mappedCategories = categoryList.map((categoryData) {
          return Category.fromJson(categoryData);
        }).toList();
        return mappedCategories;
      } else {
        throw 'Failed to fetch categories: ${response.statusCode}';
      }
    } on DioException catch (e) {
      throw e.response!.data['message'].toString();
    } catch (error) {
      throw 'Error fetching categories: $error';
    }
  }
}
