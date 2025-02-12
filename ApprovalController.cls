public with sharing class ApprovalController {
    // Properties to hold URL parameters
    public String recordId { get; set; }
    public String action { get; set; }
    private String workitemId;  // Private since it will be queried

   
    public ApprovalController() {
        recordId = ApexPages.currentPage().getParameters().get('recordId');
        action = ApexPages.currentPage().getParameters().get('action');

       
        workitemId = fetchWorkItemId(recordId);
    }

    // Method to fetch the Work Item ID for the given record
   private String fetchWorkItemId(String accountId) {
    if (String.isBlank(accountId)) {
        return null;
    }

    // Query for the latest pending work item related to this account's approval process
    List<ProcessInstanceWorkitem> workItems = [
        SELECT Id 
        FROM ProcessInstanceWorkitem
        WHERE ProcessInstance.TargetObjectId = :accountId
        AND ProcessInstance.Status = 'Pending'  // Filter for pending approvals
        ORDER BY CreatedDate DESC
        LIMIT 1
    ];

    return (workItems.isEmpty()) ? null : workItems[0].Id;
}


    // Method to process the approval action
    public PageReference processApprovalAction() {
        // Basic validation
        if (String.isBlank(recordId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Missing recordId parameter.'));
            return null;
        }
        if (String.isBlank(action)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Missing action parameter.'));
            return null;
        }
        if (String.isBlank(workitemId)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No pending approval found for this record.'));
            return null;
        }

        try {
            // Create a ProcessWorkitemRequest to act on the approval item.
            Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
            req.setWorkitemId(workitemId);

            // The action name must match the action defined in your approval process
            // Typically "Approve" or "Reject" (case sensitive).
            req.setAction(action);

            // Optionally, you can provide comments
            req.setComments('Processed via Experience Site');

            // Process the request
            Approval.ProcessResult result = Approval.process(req);

            // Check the result and display an appropriate message
            if (result.isSuccess()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Record has been ' + action + 'd successfully.'));
            } else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Action failed: ' + result.getErrors()));
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error: ' + e.getMessage()));
        }
        return null;
    }
}