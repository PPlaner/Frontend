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
	late final TranslationsCommonEn common = TranslationsCommonEn.internal(_root);
	late final TranslationsAuthEn auth = TranslationsAuthEn.internal(_root);
	late final TranslationsVaultEn vault = TranslationsVaultEn.internal(_root);
	late final TranslationsHomeEn home = TranslationsHomeEn.internal(_root);
	late final TranslationsCalendarEn calendar = TranslationsCalendarEn.internal(_root);
	late final TranslationsTaskEn task = TranslationsTaskEn.internal(_root);
	late final TranslationsProfileEn profile = TranslationsProfileEn.internal(_root);
	late final TranslationsCategoryEn category = TranslationsCategoryEn.internal(_root);
	late final TranslationsTimezonesEn timezones = TranslationsTimezonesEn.internal(_root);
	late final TranslationsBottomNavEn bottomNav = TranslationsBottomNavEn.internal(_root);
	late final TranslationsWidgetsEn widgets = TranslationsWidgetsEn.internal(_root);
	late final TranslationsEmailVerifyEn email_verify = TranslationsEmailVerifyEn.internal(_root);
	late final TranslationsSecurityMethodsEn security_methods = TranslationsSecurityMethodsEn.internal(_root);
	late final TranslationsSetupEn setup = TranslationsSetupEn.internal(_root);
	late final TranslationsSeedEn seed = TranslationsSeedEn.internal(_root);
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'PPlaner'
	String get app_name => 'PPlaner';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Continue'
	String get kContinue => 'Continue';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'Register'
	String get register => 'Register';

	/// en: 'Error'
	String get error_title => 'Error';

	/// en: 'Loading...'
	String get loading => 'Loading...';

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

	/// en: 'Save'
	String get save => 'Save';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Delete'
	String get delete => 'Delete';
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

	/// en: 'Confirmation code sent to $email'
	String codeSent({required Object email}) => 'Confirmation code sent to ${email}';

	/// en: 'Successfully registered'
	String get registerSuccess => 'Successfully registered';

	/// en: 'Successfully logged in'
	String get loginSuccess => 'Successfully logged in';
}

// Path: vault
class TranslationsVaultEn {
	TranslationsVaultEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final TranslationsVaultFatalEn fatal = TranslationsVaultFatalEn.internal(_root);
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

	/// en: 'Edit task'
	String get editTask => 'Edit task';

	/// en: 'What needs to be done?'
	String get whatToDo => 'What needs to be done?';

	/// en: 'Add details...'
	String get addDetails => 'Add details...';

	/// en: 'Delete task?'
	String get deleteTask => 'Delete task?';

	/// en: 'This task will be permanently deleted.'
	String get deleteTaskMessage => 'This task will be permanently deleted.';

	/// en: 'My lists'
	String get myLists => 'My lists';

	/// en: 'Add a list'
	String get addList => 'Add a list';

	/// en: 'Edit list'
	String get editList => 'Edit list';

	/// en: 'Delete list'
	String get deleteList => 'Delete list';

	/// en: 'Delete list?'
	String get deleteListTitle => 'Delete list?';

	/// en: 'The list and all its tasks will be permanently deleted.'
	String get deleteListMessage => 'The list and all its tasks will be permanently deleted.';

	/// en: 'Name'
	String get listName => 'Name';

	/// en: 'List colour'
	String get listColor => 'List colour';

	/// en: 'Icon'
	String get listIcon => 'Icon';

	/// en: 'Inbox'
	String get inbox => 'Inbox';
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

	/// en: 'Show event details'
	String get showDescription => 'Show event details';

	/// en: 'Hide task details'
	String get hideDescription => 'Hide task details';
}

// Path: task
class TranslationsTaskEn {
	TranslationsTaskEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select a list'
	String get chooseList => 'Select a list';

	/// en: 'No list'
	String get noList => 'No list';

	/// en: 'Select a priority'
	String get choosePriority => 'Select a priority';

	/// en: 'Select a reminder'
	String get chooseReminder => 'Select a reminder';

	/// en: 'No reminder'
	String get noReminder => 'No reminder';

	/// en: 'Remind at time'
	String get reminderAtTime => 'Remind at time';

	/// en: '(one) {1 minute} (other) {$n minutes}'
	String reminderMinutes({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 minute',
		other: '${n} minutes',
	);

	/// en: '(one) {1 hour} (other) {$n hours}'
	String reminderHours({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 hour',
		other: '${n} hours',
	);

	/// en: '(one) {1 day} (other) {$n days}'
	String reminderDays({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n,
		one: '1 day',
		other: '${n} days',
	);

	/// en: 'None'
	String get priorityNone => 'None';

	/// en: 'Low'
	String get priorityLow => 'Low';

	/// en: 'Medium'
	String get priorityMedium => 'Medium';

	/// en: 'High'
	String get priorityHigh => 'High';
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

	/// en: 'Email address'
	String get email => 'Email address';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Repeat password'
	String get confirm_password => 'Repeat password';

	/// en: 'Don't have an account?'
	String get no_account => 'Don\'t have an account?';

	/// en: 'Already have an account?'
	String get have_account => 'Already have an account?';

	/// en: 'Enter email'
	String get email_error => 'Enter email';

	/// en: 'Invalid email format'
	String get email_format_error => 'Invalid email format';

	/// en: 'Enter password'
	String get password_error => 'Enter password';

	/// en: 'Minimum 6 characters'
	String get password_length_error => 'Minimum 6 characters';

	/// en: 'Passwords do not match'
	String get passwords_not_match => 'Passwords do not match';
}

// Path: email_verify
class TranslationsEmailVerifyEn {
	TranslationsEmailVerifyEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Email Verification'
	String get title => 'Email\nVerification';

	/// en: 'We sent a code to'
	String get sent_to => 'We sent a code to';

	/// en: 'Verification code'
	String get code_hint => 'Verification code';

	/// en: 'Enter verification code'
	String get code_error => 'Enter verification code';

	/// en: 'Resend code'
	String get resend => 'Resend code';

	/// en: 'Code resent successfully'
	String get resend_success => 'Code resent successfully';
}

// Path: security_methods
class TranslationsSecurityMethodsEn {
	TranslationsSecurityMethodsEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Security Method'
	String get title => 'Security Method';

	/// en: 'Choose a quick login method. A secret phrase will be mandatory in the next step.'
	String get subtitle => 'Choose a quick login method. A secret phrase will be mandatory in the next step.';

	/// en: 'PIN-code'
	String get pin_title => 'PIN-code';

	/// en: 'Quick access via 4-digit code'
	String get pin_sub => 'Quick access via 4-digit code';

	/// en: 'Pattern Lock'
	String get pattern_title => 'Pattern Lock';

	/// en: 'Protection with a unique gesture'
	String get pattern_sub => 'Protection with a unique gesture';

	/// en: 'Association Word'
	String get word_title => 'Association Word';

	/// en: 'Password with a hint for recovery'
	String get word_sub => 'Password with a hint for recovery';

	/// en: 'Identity Verification'
	String get selection_title => 'Identity Verification';

	/// en: 'Choose an unlock method to verify'
	String get selection_subtitle => 'Choose an unlock method to verify';

	/// en: 'Login via PIN-code'
	String get method_pin => 'Login via PIN-code';

	/// en: 'Pattern Lock'
	String get method_pattern => 'Pattern Lock';

	/// en: 'Association Word'
	String get method_word => 'Association Word';

	/// en: 'Seed Phrase (Master Key)'
	String get method_seed => 'Seed Phrase (Master Key)';
}

// Path: setup
class TranslationsSetupEn {
	TranslationsSetupEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create PIN-code'
	String get pin_create => 'Create PIN-code';

	/// en: 'Enter PIN-code'
	String get pin_enter => 'Enter PIN-code';

	/// en: 'For quick access to your plans'
	String get pin_desc_setup => 'For quick access to your plans';

	/// en: 'Enter your PIN-code to login'
	String get pin_desc_login => 'Enter your PIN-code to login';

	/// en: 'Create Pattern Lock'
	String get pattern_create => 'Create Pattern Lock';

	/// en: 'Enter Pattern Lock'
	String get pattern_enter => 'Enter Pattern Lock';

	/// en: 'Pattern too short!'
	String get pattern_short => 'Pattern too short!';

	/// en: 'Connect at least 4 dots'
	String get pattern_desc_setup => 'Connect at least 4 dots';

	/// en: 'Draw your pattern to login'
	String get pattern_desc_login => 'Draw your pattern to login';

	/// en: 'Think of an association'
	String get word_create => 'Think of\nan association';

	/// en: 'Enter association'
	String get word_enter => 'Enter\nassociation';

	/// en: 'Word must be at least 6 characters (no spaces, digits or signs)'
	String get word_desc_setup => 'Word must be at least 6 characters (no spaces, digits or signs)';

	/// en: 'Enter your association word to login'
	String get word_desc_login => 'Enter your association word to login';

	/// en: 'Enter association word'
	String get word_hint => 'Enter association word';
}

// Path: seed
class TranslationsSeedEn {
	TranslationsSeedEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Your Secret Phrase'
	String get title => 'Your Secret Phrase';

	/// en: 'Write these 12 words on paper and keep them in a safe place. If you lose them, access to your data cannot be restored.'
	String get warning => 'Write these 12 words on paper and keep them in a safe place. If you lose them, access to your data cannot be restored.';

	/// en: 'Copy to clipboard'
	String get copy => 'Copy to clipboard';

	/// en: 'Phrase copied to clipboard'
	String get copy_done => 'Phrase copied to clipboard';

	/// en: 'I have written these words'
	String get saved_button => 'I have written these words';

	/// en: 'Enter your secret phrase'
	String get login_title => 'Enter your\nsecret phrase';

	/// en: 'Enter all 12 words in the correct order'
	String get login_subtitle => 'Enter all 12 words in the correct order';

	/// en: 'word'
	String get word_hint => 'word';

	/// en: 'Record Verification'
	String get verify_title => 'Record Verification';

	/// en: 'Words do not match. Try again!'
	String get verify_error => 'Words do not match. Try again!';

	/// en: 'Please enter the specified words from your secret phrase'
	String get verify_desc => 'Please enter the specified words from your secret phrase';

	/// en: 'Enter word...'
	String get verify_input_hint => 'Enter word...';
}

// Path: vault.fatal
class TranslationsVaultFatalEn {
	TranslationsVaultFatalEn.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'App crashed fatally'
	String get title => 'App crashed fatally';

	/// en: 'Failed to load keys both locally and remotely'
	String get subtitle => 'Failed to load keys both locally and remotely';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.app_name' => 'PPlaner',
			'common.back' => 'Back',
			'common.next' => 'Next',
			'common.kContinue' => 'Continue',
			'common.confirm' => 'Confirm',
			'common.login' => 'Login',
			'common.register' => 'Register',
			'common.error_title' => 'Error',
			'common.loading' => 'Loading...',
			'common.logout' => 'Log Out',
			'common.createLocalStorage' => 'Create local storage',
			'common.haveAccount' => 'I already have an account',
			'common.tagline' => 'Your plans under reliable protection',
			'common.chooseMethod' => 'Choose how to use',
			'common.save' => 'Save',
			'common.cancel' => 'Cancel',
			'common.delete' => 'Delete',
			'auth.login' => 'Log In',
			'auth.logout' => 'Log Out',
			'auth.createLocalStorage' => 'Create local storage',
			'auth.haveAccount' => 'I already have an account',
			'auth.tagline' => 'Your plans under reliable protection',
			'auth.chooseMethod' => 'Choose how to use',
			'auth.codeSent' => ({required Object email}) => 'Confirmation code sent to ${email}',
			'auth.registerSuccess' => 'Successfully registered',
			'auth.loginSuccess' => 'Successfully logged in',
			'vault.fatal.title' => 'App crashed fatally',
			'vault.fatal.subtitle' => 'Failed to load keys both locally and remotely',
			'home.today' => 'Today',
			'home.completed' => 'Completed',
			'home.newTask' => 'New task',
			'home.editTask' => 'Edit task',
			'home.whatToDo' => 'What needs to be done?',
			'home.addDetails' => 'Add details...',
			'home.deleteTask' => 'Delete task?',
			'home.deleteTaskMessage' => 'This task will be permanently deleted.',
			'home.myLists' => 'My lists',
			'home.addList' => 'Add a list',
			'home.editList' => 'Edit list',
			'home.deleteList' => 'Delete list',
			'home.deleteListTitle' => 'Delete list?',
			'home.deleteListMessage' => 'The list and all its tasks will be permanently deleted.',
			'home.listName' => 'Name',
			'home.listColor' => 'List colour',
			'home.listIcon' => 'Icon',
			'home.inbox' => 'Inbox',
			'calendar.title' => 'Calendar',
			'calendar.noTasks' => 'No tasks for this day',
			'calendar.viewMonth' => 'Month',
			'calendar.viewTwoWeeks' => '2 weeks',
			'calendar.viewWeek' => 'Week',
			'calendar.viewDay' => 'Day',
			'calendar.calendarView' => 'Calendar view',
			'calendar.taskCategory' => 'Task category',
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
			'calendar.showDescription' => 'Show event details',
			'calendar.hideDescription' => 'Hide task details',
			'task.chooseList' => 'Select a list',
			'task.noList' => 'No list',
			'task.choosePriority' => 'Select a priority',
			'task.chooseReminder' => 'Select a reminder',
			'task.noReminder' => 'No reminder',
			'task.reminderAtTime' => 'Remind at time',
			'task.reminderMinutes' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 minute', other: '${n} minutes', ), 
			'task.reminderHours' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 hour', other: '${n} hours', ), 
			'task.reminderDays' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('en'))(n, one: '1 day', other: '${n} days', ), 
			'task.priorityNone' => 'None',
			'task.priorityLow' => 'Low',
			'task.priorityMedium' => 'Medium',
			'task.priorityHigh' => 'High',
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
			'category.all' => 'All',
			'category.work' => 'Work',
			'category.personal' => 'Personal',
			'category.health' => 'Health',
			'category.other' => 'Other',
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
			'widgets.email' => 'Email address',
			'widgets.password' => 'Password',
			'widgets.confirm_password' => 'Repeat password',
			'widgets.no_account' => 'Don\'t have an account?',
			'widgets.have_account' => 'Already have an account?',
			'widgets.email_error' => 'Enter email',
			'widgets.email_format_error' => 'Invalid email format',
			'widgets.password_error' => 'Enter password',
			'widgets.password_length_error' => 'Minimum 6 characters',
			'widgets.passwords_not_match' => 'Passwords do not match',
			'email_verify.title' => 'Email\nVerification',
			'email_verify.sent_to' => 'We sent a code to',
			'email_verify.code_hint' => 'Verification code',
			'email_verify.code_error' => 'Enter verification code',
			'email_verify.resend' => 'Resend code',
			'email_verify.resend_success' => 'Code resent successfully',
			'security_methods.title' => 'Security Method',
			'security_methods.subtitle' => 'Choose a quick login method. A secret phrase will be mandatory in the next step.',
			'security_methods.pin_title' => 'PIN-code',
			'security_methods.pin_sub' => 'Quick access via 4-digit code',
			'security_methods.pattern_title' => 'Pattern Lock',
			'security_methods.pattern_sub' => 'Protection with a unique gesture',
			'security_methods.word_title' => 'Association Word',
			'security_methods.word_sub' => 'Password with a hint for recovery',
			'security_methods.selection_title' => 'Identity Verification',
			'security_methods.selection_subtitle' => 'Choose an unlock method to verify',
			'security_methods.method_pin' => 'Login via PIN-code',
			'security_methods.method_pattern' => 'Pattern Lock',
			'security_methods.method_word' => 'Association Word',
			'security_methods.method_seed' => 'Seed Phrase (Master Key)',
			'setup.pin_create' => 'Create PIN-code',
			'setup.pin_enter' => 'Enter PIN-code',
			'setup.pin_desc_setup' => 'For quick access to your plans',
			'setup.pin_desc_login' => 'Enter your PIN-code to login',
			'setup.pattern_create' => 'Create Pattern Lock',
			'setup.pattern_enter' => 'Enter Pattern Lock',
			'setup.pattern_short' => 'Pattern too short!',
			'setup.pattern_desc_setup' => 'Connect at least 4 dots',
			'setup.pattern_desc_login' => 'Draw your pattern to login',
			'setup.word_create' => 'Think of\nan association',
			'setup.word_enter' => 'Enter\nassociation',
			'setup.word_desc_setup' => 'Word must be at least 6 characters (no spaces, digits or signs)',
			'setup.word_desc_login' => 'Enter your association word to login',
			'setup.word_hint' => 'Enter association word',
			'seed.title' => 'Your Secret Phrase',
			'seed.warning' => 'Write these 12 words on paper and keep them in a safe place. If you lose them, access to your data cannot be restored.',
			'seed.copy' => 'Copy to clipboard',
			'seed.copy_done' => 'Phrase copied to clipboard',
			'seed.saved_button' => 'I have written these words',
			'seed.login_title' => 'Enter your\nsecret phrase',
			'seed.login_subtitle' => 'Enter all 12 words in the correct order',
			'seed.word_hint' => 'word',
			'seed.verify_title' => 'Record Verification',
			'seed.verify_error' => 'Words do not match. Try again!',
			'seed.verify_desc' => 'Please enter the specified words from your secret phrase',
			'seed.verify_input_hint' => 'Enter word...',
			_ => null,
		};
	}
}
