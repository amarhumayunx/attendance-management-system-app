import 'package:cloud_firestore/cloud_firestore.dart';
enum DocumentType {
  cnic,
  transcript,
  degree,
  matricCertificate,
  intermediateCertificate,
  other,
}
class UserDocument {
  final String id;
  final DocumentType type;
  final String url;
  final String? notes;
  final Timestamp? uploadedAt;
  UserDocument({
    required this.id,
    required this.type,
    required this.url,
    this.notes,
    this.uploadedAt,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.name,
      'url': url,
      'notes': notes,
      'uploadedAt': uploadedAt ?? FieldValue.serverTimestamp(),
    };
  }
  factory UserDocument.fromMap(Map<String, dynamic> map, String id) {
    return UserDocument(
      id: id,
      type: _typeFromString(map['type'] as String?),
      url: map['url'] as String,
      notes: map['notes'] as String?,
      uploadedAt: map['uploadedAt'] as Timestamp?,
    );
  }
}
DocumentType _typeFromString(String? v) {
  switch (v) {
    case 'cnic':
      return DocumentType.cnic;
    case 'transcript':
      return DocumentType.transcript;
    case 'degree':
      return DocumentType.degree;
    case 'matricCertificate':
      return DocumentType.matricCertificate;
    case 'intermediateCertificate':
      return DocumentType.intermediateCertificate;
    default:
      return DocumentType.other;
  }
}
