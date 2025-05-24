class ChurchService {

  // قائمة الكنائس مع أكوادها
  static final Map<String, String> churches = {
    '101': 'كنيسة السلام',
    '102': 'مدرسة المستقبل',
    '103': 'كنيسة العائلة المقدسة',
    '104': 'كنيسة الأنبا بولا',
    '105': 'كنيسة مارجرجس',
    // ... يمكنك إضافة المزيد حسب الحاجة
  };

  // دالة لتحويل الكود إلى اسم الكنيسة
  static String getChurchName(String code) {
    return churches[code] ?? 'كنيسة غير معروفة';
  }

  // دالة للحصول على قائمة الكنائس
  static List<String> getChurchList() {
    return churches.entries.map((entry) => '${entry.value} (${entry.key})').toList();
}
  static List<Map<String, String>> getCairoChurches() {
    return ['101', '102'].map((code) => {'code': code, 'name': churches[code]!}).toList();
  }
  static List<Map<String, String>> getGizaChurches() {
    return ['103', '104'].map((code) => {'code': code, 'name': churches[code]!}).toList();
  }
  static List<Map<String, String>> getAlexChurches() {
    return ['105'].map((code) => {'code': code, 'name': churches[code]!}).toList();
  }
  static List<Map<String, String>> getChurchesByGovernorate(String governorateCode) {
    switch (governorateCode) {
      case '01':
        return getCairoChurches();
      case '02':
        return getGizaChurches();
      case '03':
        return getAlexChurches();
    // أضف باقي المحافظات حسب الحاجة
      default:
        return [];
    }
  }



}

