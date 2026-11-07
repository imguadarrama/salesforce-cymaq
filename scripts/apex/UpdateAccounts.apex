// Create new accounts
// For clarity, use different account names than the ones you used previously
List<Account> newAccts = new List<Account>();
newAccts.add(
  new Account(
    Name = 'My Third New Account',
    Description = 'Original Description'
  )
);
newAccts.add(new Account(Name = 'My Fourth New Account'));
// Insert them into the database
try {
  insert as user newAccts;
  System.debug('Successfully inserted ' + newAccts.size() + ' accounts.');
} catch (Exception e) {
  System.debug('An error inserting the records occurred: ' + e.getMessage());
}
// Pass the original list to update the account descriptions
// The static method is called directly on the class
AccountProcessor.updateAccountDescriptions(newAccts);
