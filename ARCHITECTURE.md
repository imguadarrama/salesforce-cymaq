## Purpose of the app

A small Salesforce app (interview demo) where a user files a report for the MAQCARE plan of CYMAQ and can see how much time is left before the technician arrives.

In this module the user will:

- File a report describing a problem.
- Track their report with:
  - Report number (auto-generated, increasing, with the creation date: `MQ-{YYYY}{MM}{DD}-{00000}`).
  - Hours left before the technician arrives (12-hour window, counted from the moment the report is filed).

## Data model

### MAQCARE Report (`MAQCARE_Report__c`)

| Field name             | Data type             | Description                                                                                                         |
| ---------------------- | --------------------- | ------------------------------------------------------------------------------------------------------------------- |
| Name                   | Auto Number           | Report number, format `MQ-{YYYY}{MM}{DD}-{00000}`                                                                   |
| Description__c         | Long Text Area(32768) | The problem the user is facing. Required.                                                                           |
| Technician_Required__c | Checkbox              | Set to true by Apex when the report is filed. It is the switch that makes `Hours_Left__c` start counting.           |
| Hours_Left__c          | Formula(Number)       | `12 - hours since CreatedDate`, never below 0. Blank when `Technician_Required__c` is false.                        |

Standard fields used: `CreatedDate` (start of the countdown), `CreatedById`, `Owner`.

## Architecture

- **Apex** `MaqcareReportController`
  - `fileReport(description)`: validates the description, inserts the report with `Technician_Required__c = true`.
  - `getMyReports()`: cacheable query of the user's reports (`Name`, `Description__c`, `CreatedDate`, `Hours_Left__c`).
- **LWC** `maqcareReports`: a form to file a report plus a list of reports. The countdown is computed in the browser from `CreatedDate` (updated with `setInterval`), because a formula field is only evaluated when the record is queried and does not tick on its own.
- **Lightning App Page** inside the `MaqCare` app hosts the LWC.
- **Permission set** `MAQCARE_User` gives access to the object, its fields and the Apex class.

## Functionality

The user must be able to:

- Click `File a report` to send the `Description__c`; the report is saved with `Technician_Required__c` checked.
- See a list of their reports with the time left before the technician's arrival.
