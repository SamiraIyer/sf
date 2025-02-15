Public without sharing Class PaymentTriggerHandler {
	public static void createCases(Payment__c[] newList, map<id, Payment__c> newMap, map<id, Payment__c> oldMap){
		Set<Id> newListIds = new Set<Id>();
		for(Payment__c payment : newList){
			if(payment != null && payment.order__c !=  null && oldMap.get(payment.id) != null && oldMap.get(payment.id).Transaction_Status__c != payment.Transaction_Status__c && (payment.Transaction_Status__c == 'Received' || payment.Transaction_Status__c == 'Success')){
				newListIds.add(payment.id);
			}
		}
        if(newListIds.size() > 0) {
            createCaseFuture(newListIds);
        }
	}
	@Future
	public static void createCaseFuture(Set<Id> newListIds) {
		string subject = 'Application for Review';
		Id recordType = [select id from recordtype where sobjecttype = 'Case' and DeveloperName = 'U_S_Business' limit 1].id;
		List<Case> caseList = new List<Case>();
		//Set<Id> participationIds = new Set<Id>();
		Payment__c[] payments = [select id, order__r.id, order__r.participant__c, order__c, order__r.participant__r.organization__c from payment__c
		//Payment__c[] payments = [select id, order__r.participant__c, order__r.participation__c, order__c, order__r.participant__r.organization__c from payment__c
			where id = :newListIds];
			for(Payment__c payment: payments){ 
			if(payment != null && payment.Order__c != null && payment.order__r.participant__c != null && payment.order__r.participant__r.organization__c != null) {
			//if(payment != null && payment.Order__c != null && payment.order__r.participation__c != null && payment.order__r.participant__r.organization__c != null) { 
				//participationIds.add(payment.order__r.participation__c);
				case c = new case();
				c.subject = subject; 
				c.Order__c = payment.Order__c;
				c.recordtypeid = recordType;
				c.accountid = payment.order__r.participant__r.organization__c;
				c.participation_profile__c = payment.order__r.participant__c;
				//c.participation__c = payment.order__r.participation__c;
				c.description = 'Thank you for contacting the Privacy Shield team at the U.S. Department of Commerce’s International Trade Administration (ITA).  We will work diligently to review and respond to your submission in a timely manner.  Please note that the processing time will depend on the nature and completeness of the submission, as well as the volume of submissions received.';
			Database.DMLOptions dmo = new Database.DMLOptions();		
					dmo.assignmentRuleHeader.useDefaultRule = true;	 
				c.setOptions(dmo);
				system.debug(c);
				caseList.add(c);
			}
			}
		if(caseList.size() > 0) {
			system.debug(caseList);
			INSERT CASELIST;
		}
	}
}