import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Shared Calendar',
      'loginTitle': 'Welcome Back',
      'loginSubtitle': 'Sign in to continue',
      'emailLabel': 'Email',
      'passwordLabel': 'Password',
      'loginButton': 'Login',
      'registerButton': 'Register',
      'registerPrompt': "Don't have an account? Register",
      'loginPrompt': 'Already have an account? Login',
      'registerTitle': 'Create Account',
      'registerSubtitle': 'Sign up to get started',
      'nameLabel': 'Name',
      'calendarTitle': 'Shared Calendar',
      'addEventTitle': 'Add Event',
      'editEventTitle': 'Edit Event',
      'titleLabel': 'Title',
      'descriptionLabel': 'Description',
      'startTimeLabel': 'Start Time',
      'endTimeLabel': 'End Time',
      'cancelButton': 'Cancel',
      'saveButton': 'Save',
      'deleteButton': 'Delete',
      'deleteEventConfirm': 'Delete Event?',
      'deleteEventMessage': 'Are you sure you want to delete this event?',
      'groupDetailsTitle': 'Group Details',
      'addMemberTitle': 'Add Member',
      'selectUserLabel': 'Select User',
      'addButton': 'Add',
      'viewMembersTitle': 'Group Members',
      'deleteGroupTitle': 'Delete Group',
      'deleteGroupMessage':
          'Are you sure you want to delete this group? This action cannot be undone.',
      'confirmButton': 'Confirm',
      'logoutButton': 'Logout',
      'groupsTitle': 'Groups',
      'createGroupTitle': 'Create Group',
      'groupNameLabel': 'Group Name',
      'createButton': 'Create',
      'noEventsLabel': 'No events.',
      'myGroupsTitle': 'My Groups',
      'noCalendarsLabel': 'No calendars yet.',
      'myCalendarsTitle': 'My Calendars',
      'otherCalendarsTitle': 'Other Calendars',
      'holidaysLabel': 'Holidays (Mock)',
      'errorLoadingCalendars': 'Error loading calendars',
      'enterNameError': 'Enter name',
      'enterEmailError': 'Enter email',
      'enterPasswordError': 'Enter password',
    },
    'ar': {
      'appTitle': 'التقويم المشترك',
      'loginTitle': 'مرحبًا بعودتك',
      'loginSubtitle': 'تسجيل الدخول للمتابعة',
      'emailLabel': 'البريد الإلكتروني',
      'passwordLabel': 'كلمة المرور',
      'loginButton': 'دخول',
      'registerButton': 'تسجيل',
      'registerPrompt': 'ليس لديك حساب؟ سجل الآن',
      'loginPrompt': 'لديك حساب بالفعل؟ دخول',
      'registerTitle': 'إنشاء حساب',
      'registerSubtitle': 'سجل للبدء',
      'nameLabel': 'الاسم',
      'calendarTitle': 'التقويم المشترك',
      'addEventTitle': 'إضافة حدث',
      'editEventTitle': 'تعديل الحدث',
      'titleLabel': 'العنوان',
      'descriptionLabel': 'الوصف',
      'startTimeLabel': 'وقت البدء',
      'endTimeLabel': 'وقت الانتهاء',
      'cancelButton': 'إلغاء',
      'saveButton': 'حفظ',
      'deleteButton': 'حذف',
      'deleteEventConfirm': 'حذف الحدث؟',
      'deleteEventMessage': 'هل أنت متأكد من رغبتك في حذف هذا الحدث؟',
      'groupDetailsTitle': 'تفاصيل المجموعة',
      'addMemberTitle': 'إضافة عضو',
      'selectUserLabel': 'اختر مستخدم',
      'addButton': 'إضافة',
      'viewMembersTitle': 'أعضاء المجموعة',
      'deleteGroupTitle': 'حذف المجموعة',
      'deleteGroupMessage':
          'هل أنت متأكد من حذف هذه المجموعة؟ لا يمكن التراجع عن هذا الإجراء.',
      'confirmButton': 'تأكيد',
      'logoutButton': 'تسجيل خروج',
      'groupsTitle': 'المجموعات',
      'createGroupTitle': 'إنشاء مجموعة',
      'groupNameLabel': 'اسم المجموعة',
      'createButton': 'إنشاء',
      'noEventsLabel': 'لا توجد أحداث.',
      'myGroupsTitle': 'مجموعاتي',
      'noCalendarsLabel': 'لا توجد تقويمات بعد.',
      'myCalendarsTitle': 'تقويماتي',
      'otherCalendarsTitle': 'تقويمات أخرى',
      'holidaysLabel': 'العطلات (تجريبي)',
      'errorLoadingCalendars': 'خطأ في تحميل التقويمات',
      'enterNameError': 'أدخل الاسم',
      'enterEmailError': 'أدخل البريد الإلكتروني',
      'enterPasswordError': 'أدخل كلمة المرور',
    },
  };

  String get appTitle => _localizedValues[locale.languageCode]!['appTitle']!;
  String get loginTitle =>
      _localizedValues[locale.languageCode]!['loginTitle']!;
  String get loginSubtitle =>
      _localizedValues[locale.languageCode]!['loginSubtitle']!;
  String get emailLabel =>
      _localizedValues[locale.languageCode]!['emailLabel']!;
  String get passwordLabel =>
      _localizedValues[locale.languageCode]!['passwordLabel']!;
  String get loginButton =>
      _localizedValues[locale.languageCode]!['loginButton']!;
  String get registerButton =>
      _localizedValues[locale.languageCode]!['registerButton']!;
  String get registerPrompt =>
      _localizedValues[locale.languageCode]!['registerPrompt']!;
  String get loginPrompt =>
      _localizedValues[locale.languageCode]!['loginPrompt']!;
  String get registerTitle =>
      _localizedValues[locale.languageCode]!['registerTitle']!;
  String get registerSubtitle =>
      _localizedValues[locale.languageCode]!['registerSubtitle']!;
  String get nameLabel => _localizedValues[locale.languageCode]!['nameLabel']!;
  String get calendarTitle =>
      _localizedValues[locale.languageCode]!['calendarTitle']!;
  String get addEventTitle =>
      _localizedValues[locale.languageCode]!['addEventTitle']!;
  String get editEventTitle =>
      _localizedValues[locale.languageCode]!['editEventTitle']!;
  String get titleLabel =>
      _localizedValues[locale.languageCode]!['titleLabel']!;
  String get descriptionLabel =>
      _localizedValues[locale.languageCode]!['descriptionLabel']!;
  String get startTimeLabel =>
      _localizedValues[locale.languageCode]!['startTimeLabel']!;
  String get endTimeLabel =>
      _localizedValues[locale.languageCode]!['endTimeLabel']!;
  String get cancelButton =>
      _localizedValues[locale.languageCode]!['cancelButton']!;
  String get saveButton =>
      _localizedValues[locale.languageCode]!['saveButton']!;
  String get deleteButton =>
      _localizedValues[locale.languageCode]!['deleteButton']!;
  String get deleteEventConfirm =>
      _localizedValues[locale.languageCode]!['deleteEventConfirm']!;
  String get deleteEventMessage =>
      _localizedValues[locale.languageCode]!['deleteEventMessage']!;
  String get groupDetailsTitle =>
      _localizedValues[locale.languageCode]!['groupDetailsTitle']!;
  String get addMemberTitle =>
      _localizedValues[locale.languageCode]!['addMemberTitle']!;
  String get selectUserLabel =>
      _localizedValues[locale.languageCode]!['selectUserLabel']!;
  String get addButton => _localizedValues[locale.languageCode]!['addButton']!;
  String get viewMembersTitle =>
      _localizedValues[locale.languageCode]!['viewMembersTitle']!;
  String get deleteGroupTitle =>
      _localizedValues[locale.languageCode]!['deleteGroupTitle']!;
  String get deleteGroupMessage =>
      _localizedValues[locale.languageCode]!['deleteGroupMessage']!;
  String get confirmButton =>
      _localizedValues[locale.languageCode]!['confirmButton']!;
  String get logoutButton =>
      _localizedValues[locale.languageCode]!['logoutButton']!;
  String get groupsTitle =>
      _localizedValues[locale.languageCode]!['groupsTitle']!;
  String get createGroupTitle =>
      _localizedValues[locale.languageCode]!['createGroupTitle']!;
  String get groupNameLabel =>
      _localizedValues[locale.languageCode]!['groupNameLabel']!;
  String get createButton =>
      _localizedValues[locale.languageCode]!['createButton']!;
  String get noEventsLabel =>
      _localizedValues[locale.languageCode]!['noEventsLabel']!;
  String get myGroupsTitle =>
      _localizedValues[locale.languageCode]!['myGroupsTitle']!;
  String get noCalendarsLabel =>
      _localizedValues[locale.languageCode]!['noCalendarsLabel']!;
  String get myCalendarsTitle =>
      _localizedValues[locale.languageCode]!['myCalendarsTitle']!;
  String get otherCalendarsTitle =>
      _localizedValues[locale.languageCode]!['otherCalendarsTitle']!;
  String get holidaysLabel =>
      _localizedValues[locale.languageCode]!['holidaysLabel']!;
  String get errorLoadingCalendars =>
      _localizedValues[locale.languageCode]!['errorLoadingCalendars']!;
  String get enterNameError =>
      _localizedValues[locale.languageCode]!['enterNameError']!;
  String get enterEmailError =>
      _localizedValues[locale.languageCode]!['enterEmailError']!;
  String get enterPasswordError =>
      _localizedValues[locale.languageCode]!['enterPasswordError']!;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
