import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class NewsItem {
  final String title;
  final String body;

  NewsItem({required this.title, required this.body});

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] ?? 'No Title',
      body: json['body'] ?? 'No Content',
    );
  }
}

class NewsService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<NewsItem>> fetchNews() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        return data.take(5).map((json) => NewsItem.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      debugPrint('Error fetching news: $e');

      return [];
    }
  }
}
