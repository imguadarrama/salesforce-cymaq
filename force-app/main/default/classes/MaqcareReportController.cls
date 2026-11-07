public with sharing class MaqcareReportController {
  @AuraEnabled(cacheable=true)
  public static List<MAQCARE_Report__c> getReports() {
    return [
      SELECT Id, Name, Description__c, Hours_Left__c
      FROM MAQCARE_Report__c
      ORDER BY CreatedDate DESC
    ];
  }

  @AuraEnabled
  public static void fileReport(String description) {
    if (String.isBlank(description)) {
      throw new AuraHandledException('Please describe the problem.');
    }
    MAQCARE_Report__c report = new MAQCARE_Report__c();
    report.Description__c = description;
    report.Technician_Required__c = true;
    insert report;
  }
}
