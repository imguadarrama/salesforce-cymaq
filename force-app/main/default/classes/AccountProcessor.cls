public with sharing class AccountProcessor {
  /**
   * Applies a standard formatting to the descriptions of accounts in the list,
   * and updates each account.
   */
  public static void updateAccountDescriptions(List<Account> acctList) {
    if (acctList == null || acctList.isEmpty()) {
      System.debug('Account list is null or empty.');
      return;
    }
    for (Account acc : acctList) {
      applyStandardFormatting(acc);
    }
    Database.SaveResult[] srList = Database.update(
      acctList,
      false,
      AccessLevel.USER_MODE
    );
    inspectResults(srList);
  }
  /**
   * Private helper method to handle the description formatting logic.
   */
  private static void applyStandardFormatting(Account acc) {
    String timestamp = String.valueOf(Datetime.now());
    if (String.isBlank(acc.Description)) {
      acc.Description = 'Account updated on: ' + timestamp;
    } else {
      acc.Description += ' | Last processed: ' + timestamp;
    }
  }
  /*
   * Private helper method to inspect the returned results.
   */
  private static void inspectResults(Database.SaveResult[] results) {
    for (Database.SaveResult sr : results) {
      if (sr.isSuccess()) {
        System.debug('Successfully updated account. Account ID: ' + sr.getId());
      } else {
        for (Database.Error err : sr.getErrors()) {
          System.debug('The following error has occurred.');
          System.debug(err.getStatusCode() + ': ' + err.getMessage());
          System.debug(
            'Account fields that affected this error: ' + err.getFields()
          );
        }
      }
    }
  }
}
