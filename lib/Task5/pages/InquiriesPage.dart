import 'package:flutter/material.dart';

class InquiriesPage extends StatelessWidget {
  const InquiriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inquiries'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildInquiryTile(
            context,
            'Product Issues',
            'Details and common issues related to our products.',
          ),
          _buildInquiryTile(
            context,
            'Order Status',
            'Questions related to the status of your orders.',
          ),
          _buildInquiryTile(
            context,
            'Shipping and Delivery',
            'Information about shipping and delivery processes.',
          ),
          _buildInquiryTile(
            context,
            'Returns and Exchanges',
            'Guidelines and policies on returns and exchanges.',
          ),
          _buildInquiryTile(
            context,
            'General Questions',
            'General inquiries about our services and policies.',
          ),
        ],
      ),
    );
  }

  Widget _buildInquiryTile(BuildContext context, String title, String content) {
    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(content),
        ),
      ],
    );
  }
}
