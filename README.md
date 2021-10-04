# flutter-email

working directly in Dart to create email client
no 3rd party JARs or PODs

Just clone and run 
-- dart pub get 

in terminal

One form right now that lets you pick from a list of addresses
debug output shows it searching for the email server settings based on the address chosen

Next step is to hook this into the email form and test sending email

After this step the email form will be separated from the choose address form and password will be added to the

One complication is GMail and other providers use OAuth and for GMail this may require app registration firstItem
