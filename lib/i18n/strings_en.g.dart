///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations

	/// en: 'PPlaner'
	String get appName => 'PPlaner';

	late final TranslationsAuthEn auth = TranslationsAuthEn.internal(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn.internal(_root);
	late final TranslationsCalendarEn calendar = TranslationsCalendarEn.internal(_root);
	late final TranslationsProfileEn profile = TranslationsProfileEn.internal(_root);
	late final TranslationsCategoryEn category = TranslationsCategoryEn.internal(_root);
	late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
	late final TranslationsTimezonesEn timezones = TranslationsTimezonesEn.internal(_root);
	late final TranslationsBottomNavEn bottomNav = TranslationsBottomNavEn.internal(_root);
	late final TranslationsWidgetsEn widgets = TranslationsWidgetsEn.internal(_root);
}

// Path: auth
class TranslationsAuthEn {
	TranslationsAuthEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Log In'
	String get login => 'Log In';

	/// en: 'Log Out'
	String get logout => 'Log Out';

	/// en: 'Create local storage'
	String get createLocalStorage => 'Create local storage';

	/// en: 'I already have an account'
	String get haveAccount => 'I already have an account';

	/// en: 'Your plans under reliable protection'
	String get tagline => 'Your plans under reliable protection';

	/// en: 'Choose how to use'
	String get chooseMethod => 'Choose how to use';
}

// Path: home
class TranslationsHomeEn {
	TranslationsHomeEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Today'
	String get today => 'Today';

	/// en: 'Completed'
	String get completed => 'Completed';

	/// en: 'New task'
	String get newTask => 'New task';

	/// en: 'What needs to be done?'
	String get whatToDo => 'What needs to be done?';

	/// en: 'Add details...'
	String get addDetails => 'Add details...';

	/// en: 'Delete task?'
	String get deleteTask => 'Delete task?';

	/// en: 'This task will be permanently deleted.'
	String get deleteTaskMessage => 'This task will be permanently deleted.';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Delete'
	String get delete => 'Delete';
}

// Path: calendar
class TranslationsCalendarEn {
	TranslationsCalendarEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Calendar'
	String get title => 'Calendar';

	/// en: 'No tasks for this day'
	String get noTasks => 'No tasks for this day';

	/// en: 'Month'
	String get viewMonth => 'Month';

	/// en: '2 weeks'
	String get viewTwoWeeks => '2 weeks';

	/// en: 'Week'
	String get viewWeek => 'Week';

	/// en: 'Day'
	String get viewDay => 'Day';

	/// en: 'Calendar view'
	String get calendarView => 'Calendar view';

	/// en: 'Task category'
	String get taskCategory => 'Task category';

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Choose timezone'
	String get chooseTimezone => 'Choose timezone';

	/// en: 'Filter'
	String get filter => 'Filter';

	List<String> get months => [
		'January',
		'February',
		'March',
		'April',
		'May',
		'June',
		'July',
		'August',
		'September',
		'October',
		'November',
		'December',
	];
}

// Path: profile
class TranslationsProfileEn {
	TranslationsProfileEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Profile'
	String get title => 'Profile';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Create account'
	String get createAccount => 'Create account';

	/// en: 'Create an account so you don't lose your data'
	String get createAccountSubtitle => 'Create an account so you don\'t lose your data';

	/// en: 'Personalization'
	String get personalization => 'Personalization';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Appearance'
	String get appearance => 'Appearance';

	/// en: 'Date and time'
	String get dateTime => 'Date and time';

	/// en: 'Widgets'
	String get widgets => 'Widgets';

	/// en: 'Log Out'
	String get logout => 'Log Out';

	/// en: 'Delete account'
	String get deleteAccount => 'Delete account';

	/// en: 'Data will be lost'
	String get deleteAccountSubtitle => 'Data will be lost';

	/// en: 'Change name'
	String get changeName => 'Change name';

	/// en: 'Change password'
	String get changePassword => 'Change password';

	/// en: 'Change encryption method'
	String get changeEncryption => 'Change encryption method';

	/// en: 'Your data will be lost'
	String get deleteConfirmTitle => 'Your data will be lost';

	/// en: 'Light'
	String get appearanceLight => 'Light';

	/// en: 'Dark'
	String get appearanceDark => 'Dark';

	/// en: 'System'
	String get appearanceSystem => 'System';

	/// en: 'Choose language'
	String get chooseLanguage => 'Choose language';

	/// en: 'Appearance'
	String get chooseAppearance => 'Appearance';

	/// en: 'Add widget'
	String get addWidget => 'Add widget';

	/// en: 'Today's tasks'
	String get widgetTasks => 'Today\'s tasks';

	/// en: 'Calendar'
	String get widgetCalendar => 'Calendar';

	/// en: 'Progress'
	String get widgetProgress => 'Progress';
}

// Path: category
class TranslationsCategoryEn {
	TranslationsCategoryEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All'
	String get all => 'All';

	/// en: 'Work'
	String get work => 'Work';

	/// en: 'Personal'
	String get personal => 'Personal';

	/// en: 'Health'
	String get health => 'Health';

	/// en: 'Other'
	String get other => 'Other';
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Back'
	String get back => 'Back';
}

// Path: timezones
class TranslationsTimezonesEn {
	TranslationsTimezonesEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Ukraine'
	String get ukraine => 'Ukraine';

	/// en: 'Poland'
	String get poland => 'Poland';

	/// en: 'Germany'
	String get germany => 'Germany';

	/// en: 'USA (New York)'
	String get usaNy => 'USA (New York)';

	/// en: 'USA (Los Angeles)'
	String get usaLa => 'USA (Los Angeles)';

	/// en: 'Great Britain'
	String get greatBritain => 'Great Britain';
}

// Path: bottomNav
class TranslationsBottomNavEn {
	TranslationsBottomNavEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Tasks'
	String get tasks => 'Tasks';

	/// en: 'Calendar'
	String get calendar => 'Calendar';

	/// en: 'Profile'
	String get profile => 'Profile';
}

// Path: widgets
class TranslationsWidgetsEn {
	TranslationsWidgetsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Today's tasks'
	String get tasks => 'Today\'s tasks';

	/// en: 'Calendar'
	String get calendar => 'Calendar';

	/// en: 'Progress'
	String get progress => 'Progress';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'appName' => 'PPlaner',
			'auth.login' => 'Log In',
			'auth.logout' => 'Log Out',
			'auth.createLocalStorage' => 'Create local storage',
			'auth.haveAccount' => 'I already have an account',
			'auth.tagline' => 'Your plans under reliable protection',
			'auth.chooseMethod' => 'Choose how to use',
			'home.today' => 'Today',
			'home.completed' => 'Completed',
			'home.newTask' => 'New task',
			'home.whatToDo' => 'What needs to be done?',
			'home.addDetails' => 'Add details...',
			'home.deleteTask' => 'Delete task?',
			'home.deleteTaskMessage' => 'This task will be permanently deleted.',
			'home.cancel' => 'Cancel',
			'home.delete' => 'Delete',
			'calendar.title' => 'Calendar',
			'calendar.noTasks' => 'No tasks for this day',
			'calendar.viewMonth' => 'Month',
			'calendar.viewTwoWeeks' => '2 weeks',
			'calendar.viewWeek' => 'Week',
			'calendar.viewDay' => 'Day',
			'calendar.calendarView' => 'Calendar view',
			'calendar.taskCategory' => 'Task category',
			'calendar.save' => 'Save',
			'calendar.chooseTimezone' => 'Choose timezone',
			'calendar.filter' => 'Filter',
			'calendar.months.0' => 'January',
			'calendar.months.1' => 'February',
			'calendar.months.2' => 'March',
			'calendar.months.3' => 'April',
			'calendar.months.4' => 'May',
			'calendar.months.5' => 'June',
			'calendar.months.6' => 'July',
			'calendar.months.7' => 'August',
			'calendar.months.8' => 'September',
			'calendar.months.9' => 'October',
			'calendar.months.10' => 'November',
			'calendar.months.11' => 'December',
			'profile.title' => 'Profile',
			'profile.name' => 'Name',
			'profile.email' => 'Email',
			'profile.createAccount' => 'Create account',
			'profile.createAccountSubtitle' => 'Create an account so you don\'t lose your data',
			'profile.personalization' => 'Personalization',
			'profile.language' => 'Language',
			'profile.appearance' => 'Appearance',
			'profile.dateTime' => 'Date and time',
			'profile.widgets' => 'Widgets',
			'profile.logout' => 'Log Out',
			'profile.deleteAccount' => 'Delete account',
			'profile.deleteAccountSubtitle' => 'Data will be lost',
			'profile.changeName' => 'Change name',
			'profile.changePassword' => 'Change password',
			'profile.changeEncryption' => 'Change encryption method',
			'profile.deleteConfirmTitle' => 'Your data will be lost',
			'profile.appearanceLight' => 'Light',
			'profile.appearanceDark' => 'Dark',
			'profile.appearanceSystem' => 'System',
			'profile.chooseLanguage' => 'Choose language',
			'profile.chooseAppearance' => 'Appearance',
			'profile.addWidget' => 'Add widget',
			'profile.widgetTasks' => 'Today\'s tasks',
			'profile.widgetCalendar' => 'Calendar',
			'profile.widgetProgress' => 'Progress',
			'category.all' => 'All',
			'category.work' => 'Work',
			'category.personal' => 'Personal',
			'category.health' => 'Health',
			'category.other' => 'Other',
			'common.save' => 'Save',
			'common.cancel' => 'Cancel',
			'common.delete' => 'Delete',
			'common.back' => 'Back',
			'timezones.ukraine' => 'Ukraine',
			'timezones.poland' => 'Poland',
			'timezones.germany' => 'Germany',
			'timezones.usaNy' => 'USA (New York)',
			'timezones.usaLa' => 'USA (Los Angeles)',
			'timezones.greatBritain' => 'Great Britain',
			'bottomNav.tasks' => 'Tasks',
			'bottomNav.calendar' => 'Calendar',
			'bottomNav.profile' => 'Profile',
			'widgets.tasks' => 'Today\'s tasks',
			'widgets.calendar' => 'Calendar',
			'widgets.progress' => 'Progress',
			_ => null,
		};
	}
}
