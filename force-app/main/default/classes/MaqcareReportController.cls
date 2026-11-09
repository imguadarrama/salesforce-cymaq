public with sharing class MaqcareReportController {
  @AuraEnabled(cacheable=true)
  public static List<MAQCARE_Report__c> getReports() {
    return [
      SELECT Id, Name, Description__c, Hours_Left__c, Technician_Required__c
      FROM MAQCARE_Report__c
      WHERE Technician_Required__c = TRUE
      ORDER BY CreatedDate DESC
    ];
  }

  @AuraEnabled
  public static void fileReport(String description) {
    if (String.isBlank(description)) {
      throw new AuraHandledException('Please describe the problem.');
    }
    if (
      ![
          SELECT Id
          FROM MAQCARE_Report__c
          WHERE Technician_Required__c = TRUE
          LIMIT 1
        ]
        .isEmpty()
    ) {
      throw new AuraHandledException('You already have an active report.');
    }
    MAQCARE_Report__c report = new MAQCARE_Report__c();
    report.Description__c = description;
    report.Technician_Required__c = true;
    insert report;
  }

  @AuraEnabled
  public static void cancelReport(Id reportId) {
    delete [SELECT Id FROM MAQCARE_Report__c WHERE Id = :reportId];
  }
}
