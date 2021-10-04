import 'package:enough_mail/enough_mail.dart';
import './email-message.dart';
import './email-account.dart';

void test() async {
  var c = await ExtendMailAccount.create('greg@sqlprompt.net', 'test');
}

class ExtendMailAccount extends MailAccount {
  /// Private constructor
  ExtendMailAccount._create() {
    print("_create() (private constructor)");

    // Do most of your initialization here, that's what a constructor is for
    //...
  }

  /// Public factory
  static Future<MailAccount> create(String email, String password) async {
    print("create() (public factory)");

    // Call the private constructor
    //var component = ExtendMailAccount._create();

    // Do initialization that requires async
    //await component._complexAsyncInit();

    ClientConfig _clientConfig =
        (await Discover.discover(email, isLogEnabled: false))!;
    String _domain = email;

    MailAccount component = MailAccount.fromDiscoveredSettings(
        'my account', email, password, _clientConfig,
        userName: email, outgoingClientDomain: _domain);

    // Return the fully initialized object
    return component;
  }
}

class TestMailAccount {
  TestMailAccount();
  late MailAccount account;
  //MailServerConfig? _mailServer;
  var dummy = 1;

  void init(String email, String password) async {
    print('init email account');
    ClientConfig _clientConfig =
        (await Discover.discover(email, isLogEnabled: false))!;
    String _domain = email;
    account = MailAccount.fromDiscoveredSettings(
        'my account', email, password, _clientConfig,
        userName: email, outgoingClientDomain: _domain);
    //_mailServer = MailServerConfig         MailClient(_account, isLogEnabled: true);
    print(_clientConfig.preferredOutgoingSmtpServer);

    test();
  }

  setConfig() async {
    ClientConfig? _config =
        (await Discover.discover(account.email!, isLogEnabled: false));
    if (_config?.preferredOutgoingSmtpServer != null) {
      print(_config?.preferredOutgoingSmtpServer);
    } else {
      print('no smtp server found');
    }
  }

  void printConfig() {
    print(this.toString());
    //TODO figure out how to print setting for account config
  }
}

class EmailService {
  EmailService(this.emailAccount);

  late EmailAccount emailAccount;
  ClientConfig? clientConfig;
  send(emailMessage) {
    var sendMail = SendMail(emailMessage, emailAccount);
    print(sendMail);
  }

  setConfig() async {
    clientConfig =
        await Discover.discover(emailAccount.emailAddress, isLogEnabled: false);
    if (clientConfig?.preferredOutgoingSmtpServer != null) {
      print(clientConfig?.preferredOutgoingSmtpServer);
    } else {
      print('no smtp server found');
    }
  }
}

/*

  
*/

String userName = 'kade.koss49@ethereal.email';
String password = 'W7NyENBmpe1tYw3ZCu';

String imapServerHost = 'imap.ethereal.email';
int imapServerPort = 993; // 993 is typical
bool isImapServerSecure = true;
String popServerHost = 'pop.domain.com';
int popServerPort = 995;
bool isPopServerSecure = true;
String smtpServerHost = 'smtp.ethereal.email';

///mail.smtpbucket.com (port 8025
int smtpServerPort = 587; //587; //465 is typical
bool isSmtpServerSecure = true;

Future<void> discoverExample() async {
  var email = userName; //'sender@domain.com';
  var config = await Discover.discover(email, isLogEnabled: false);
  if (config == null) {
    print('Unable to discover settings for $email');
  } else {
    print('Settings for $email:');
    if (config.emailProviders != null) {
      for (var provider in config.emailProviders ?? []) {
        print('provider: ${provider.displayName}');
        print('provider-domains: ${provider.domains}');
        print('documentation-url: ${provider.documentationUrl}');
        print('Incoming:');
        print(provider.preferredIncomingServer);
        print('Outgoing:');
        print(provider.preferredOutgoingServer);
      }
    }
  }
}

/// Low level IMAP API usage example
Future<void> imapExample() async {
  final client = ImapClient(isLogEnabled: false);
  try {
    await client.connectToServer(imapServerHost, imapServerPort,
        isSecure: isImapServerSecure);
    await client.login(userName, password);
    final mailboxes = await client.listMailboxes();
    print('mailboxes: $mailboxes');
    await client.selectInbox();
    // fetch 10 most recent messages:
    final fetchResult = await client.fetchRecentMessages(
        messageCount: 10, criteria: 'BODY.PEEK[]');
    for (final message in fetchResult.messages) {
      printMessage(message);
    }
    await client.logout();
  } on ImapException catch (e) {
    print('IMAP failed with $e');
  }
}

/// Low level SMTP API example
Future<void> smtpExample() async {
  final client = SmtpClient(smtpServerHost, isLogEnabled: true);
  try {
    await client.connectToServer(smtpServerHost, smtpServerPort,
        isSecure: isSmtpServerSecure);
    await client.ehlo();
    print("ready to authenticate");
    await client.authenticate(userName, password);
    final builder = MessageBuilder.prepareMultipartAlternativeMessage();
    print("ready to send mail");
    builder.from = [
      MailAddress('My name', userName)
    ]; //    builder.from = [MailAddress('My name', userName)]; //
    builder.to = [MailAddress('Your name', 'recipient@domain.com')];
    builder.subject = 'My first message';
    builder.addTextPlain('hello world.');
    builder.addTextHtml('<p>hello <b>world</b></p>');
    final mimeMessage = builder.buildMimeMessage();
    final sendResponse = await client.sendMessage(mimeMessage);
    print('message sent: ${sendResponse.isOkStatus}');
  } on SmtpException catch (e) {
    print('SMTP failed with $e');
  }
}

/// High level mail API example
Future<void> SendMail(
    EmailMessage emailMessage, EmailAccount emailConfig) async {
  final email = emailConfig.emailAddress;

  print('discovering settings for  $email...');
  final config = await Discover.discover(email);
  if (config == null) {
    // note that you can also directly create an account when
    // you cannot autodiscover the settings:
    // Compare [MailAccount.fromManualSettings] and [MailAccount.fromManualSettingsWithAuth]
    // methods for details
    print('Unable to autodiscover settings for $email');
    return;
  }
  print('connecting to ${config.displayName}.');
  final account =
      MailAccount.fromDiscoveredSettings('my account', email, password, config);
  final mailClient = MailClient(account, isLogEnabled: true);
  try {
    await mailClient.connect();
    print('connected');
    final mailboxes =
        await mailClient.listMailboxesAsTree(createIntermediate: false);
    print(mailboxes);
    await mailClient.selectInbox();
    final messages = await mailClient.fetchMessages(count: 20);
    for (final msg in messages) {
      printMessage(msg);
    }
    mailClient.eventBus.on<MailLoadEvent>().listen((event) {
      print('New message at ${DateTime.now()}:');
      printMessage(event.message);
    });
    await mailClient.startPolling();
  } on MailException catch (e) {
    print('High level API failed with $e');
  }
  try {
    final builder = MessageBuilder.prepareMultipartAlternativeMessage();
    print("ready to send mail");
    builder.from = [
      MailAddress('My name', userName)
    ]; //    builder.from = [MailAddress('My name', userName)]; //
    builder.to = [MailAddress('Your name', 'recipient@domain.com')];
    builder.subject = 'My first message';
    builder.addTextPlain('hello world.');
    builder.addTextHtml('<p>hello <b>world</b></p>');
    final mimeMessage = builder.buildMimeMessage();
    final sendResponse = await mailClient.sendMessage(mimeMessage);
    //print('message sent: ${sendResponse}'); //.isOkStatus}'//
  } on SmtpException catch (e) {
    print('SMTP failed with $e');
  }
}

/// Low level POP3 API example
Future<void> popExample() async {
  final client = PopClient(isLogEnabled: false);
  try {
    await client.connectToServer(popServerHost, popServerPort,
        isSecure: isPopServerSecure);
    await client.login(userName, password);
    // alternative login:
    // await client.loginWithApop(userName, password); // optional different login mechanism
    final status = await client.status();
    print(
        'status: messages count=${status.numberOfMessages}, messages size=${status.totalSizeInBytes}');
    final messageList = await client.list(status.numberOfMessages);
    print(
        'last message: id=${messageList.first.id} size=${messageList.first.sizeInBytes}');
    var message = await client.retrieve(status.numberOfMessages);
    printMessage(message);
    message = await client.retrieve(status.numberOfMessages + 1);
    print('trying to retrieve newer message succeeded');
    await client.quit();
  } on PopException catch (e) {
    print('POP failed with $e');
  }
}

void printMessage(MimeMessage message) {
  print('from: ${message.from} with subject "${message.decodeSubject()}"');
  if (!message.isTextPlainMessage()) {
    print(' content-type: ${message.mediaType}');
  } else {
    final plainText = message.decodeTextPlainPart();
    if (plainText != null) {
      final lines = plainText.split('\r\n');
      for (final line in lines) {
        if (line.startsWith('>')) {
          // break when quoted text starts
          break;
        }
        print(line);
      }
    }
  }
}
