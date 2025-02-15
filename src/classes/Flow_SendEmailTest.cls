/**
 * Created by Mark Keckeis, Mil Corporation on 7/13/2020.
 */
@IsTest
private with sharing class Flow_SendEmailTest {

	@testSetup static void testSetup() {
		Account account = TestUtils.createAccount(true);
		Program__c program = TestUtils.createProgram('Test Program', true);

		Id pricebookId = Test.getStandardPricebookId();
		Product2 product2 = TestUtils.createProduct('Test Product', true);
		PricebookEntry pbe = TestUtils.createPricebookEntry(pricebookId, product2.Id, true);
		Id servicesRecordTypeId = Schema.SObjectType.Order.getRecordTypeInfosByDeveloperName().get('Services').getRecordTypeId();
		Contract contract = new Contract();
		contract.Name = 'Contract Test X';
		contract.AccountId = account.Id;
		contract.Pricebook2Id = pricebookId;
		contract.StartDate = Date.newInstance(2020, 01, 01);
		contract.ContractTerm = 30;
		contract.BillingCountry = 'United States';
		contract.ShippingCountry = 'United States';
		contract.Status = 'Draft';
		insert contract;
		contract.Status = 'Activated';
		update contract;

		Payment2__c payment1 = TestUtils.CreatePayment2(true, 'Credit_Card_or_ACH_Payment');
		payment1.Account_Type__c = 'Services';
		payment1.Payment_Processor__c = 'Paygov';
		payment1.Transaction_Status__c = 'Success';
		payment1.Transaction_Amount__c = 4800.00;
		payment1.Payment_Type__c = 'PLASTIC_CARD';
		payment1.Receipt_Ready__c = true;
		payment1.Contract__c = contract.Id;
		update payment1;

		List<Order> orders = new List<Order>();
		Order order1 = TestUtils.createOrder(account.Id, null, program.Id, pricebookId);
		OrderItem orderItem1 = TestUtils.createStandardOrderItem(true, order1.Id, pbe.Id);
		order1.Type = 'Services';
		order1.Name = 'Test Order X';
		order1.ContractId = contract.Id;
		order1.RecordTypeId = servicesRecordTypeId;
		order1.Order_Paid__c = true;
		order1.Payment2__c = payment1.Id;
		orders.add(order1);

		Order order2 = TestUtils.createOrder(account.Id, null, program.Id, pricebookId);
		OrderItem orderItem2 = TestUtils.createStandardOrderItem(true, order2.Id, pbe.Id);
		order2.Type = 'Services';
		order2.Name = 'Test Order X';
		order2.ContractId = contract.Id;
		order2.RecordTypeId = servicesRecordTypeId;
		orders.add(order2);
		update orders;


	}
	@IsTest
	static void send_Email_Positive() {
		List<Flow_SendEmail.RequestVariables> rv = new List<Flow_SendEmail.RequestVariables>();
		Flow_SendEmail.RequestVariables rv1 = new Flow_SendEmail.RequestVariables();
		List<Order> orders = [SELECT Id, Type, Payment2__c, Order_Paid__c, ContractId, OwnerId FROM ORDER WHERE Name = 'Test Order X'];
		rv1.emailList = 'test@test.com';
		rv1.recordID = orders[0].ID;
		rv1.userId = orders[0].OwnerId;
		rv.add(rv1);
		List<Flow_SendEmail.ResponseVariables> backFromApex = Flow_SendEmail.createEMailReceipt(rv);
		System.assertEquals(true, backFromApex[0].VarEmailReceiptSent);
	}

	@IsTest
	static void send_Email_NoData() {
		List<Flow_SendEmail.RequestVariables> rv = new List<Flow_SendEmail.RequestVariables>();
		Flow_SendEmail.RequestVariables rv1 = new Flow_SendEmail.RequestVariables();
		List<Flow_SendEmail.ResponseVariables> backFromApex = Flow_SendEmail.createEMailReceipt(rv);
		System.assertEquals(false, backFromApex[0].VarEmailReceiptSent);
	}
}