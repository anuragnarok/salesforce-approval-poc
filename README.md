
# Salesforce Approval POC 🚀  

This project demonstrates an approval process in Salesforce using Apex, Visualforce Pages, and Email Templates. The proof of concept (POC) enables users to approve or reject records through an external site integrated with Salesforce.  

## Features  
✅ Visualforce page for approval actions  
✅ Apex controller for backend logic  
✅ Email template for notifications  
✅ External site authentication handling  

## Installation & Setup  
1. Clone the repository:  
   ```bash
   git clone https://github.com/anuragnarok/salesforce-approval-poc.git
   cd salesforce-approval-poc
Steps -
1. create an approval process for your desired object. In my case i created for the Acocunt object .
2. While adding the email template, add a visual force template which will include the buttons with the link to the external site . the URL will contain the parameters which are fetched by the apex controller . Refer my email template.
3. refer my logic for the apex controller . It fetches the parameters from the URL and processess the approval process accordingly.
4. Create a vf page which will accept the action and show the confirmation message and also run the apex code. Refer my page.
5. Add this VF page to the experience site (Create the site prior to everything and add the guest level permissions ) .
Main priority of this POC is to approve or reject the approval without any credentials .

