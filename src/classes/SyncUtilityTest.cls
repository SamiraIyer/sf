/**
 * 
 *    Created by Joshua Moody
 *    on Feb 19 2017
 *    MIL Corporation
 * 
 **/
 @isTest
public class SyncUtilityTest {
 	/************************************************
    * This class performs unit tests on the SyncUtility
    * under these condititions.
    * 1. Test to ensure that in class variabled initialize
    * 2. Test to ensure that source objects are read correctly
    * 3. Test to ensure that custom metadata fields to sync
    * for the current target object and source objects are
    * read correctly for query
    * 4. Test to ensure the values of the fields in scope
    * from the source in scope are populated correctly
    * on the target object
    *************************************************/
    
	private static Date petitionDate = System.today();
	private static String targetObjectName = '';
	private static Set<String> currentSources = new Set<String>();
	private static Map<String,String> currentFieldMappings = new Map<String,String>();	
	private static List<Investigation__c> iList {
		get {
			if(iList == null) {
				iList = [SELECT Id, RecordTypeId, AD_Investigation_Aligned_To__c, Calculated_Final_Signature__c, Petition__c FROM Investigation__c];
			}
			return iList;
		}
	}
	private static List<Petition__c> pList {
		get {
			if(pList == null) {
				pList = [SELECT Id, ADCVD_Case_Number_Text__c, Commodity_Text__c FROM Petition__c];
			}
			return pList;
		}
	}
	private static Investigation__c iAD {
		get {
			Id recordType = utils.getRecordTypeIdMap('Investigation__c').get('AD');
			iAD = [SELECT Id, RecordTypeId, AD_Investigation_Aligned_To__c, Calculated_Final_Signature__c, Petition__c FROM Investigation__c WHERE RecordTypeId =: recordType LIMIT 1];
			return iAD;
		}	
	}
	private static void targetObjectName(List<SObject> soList) {
		targetObjectName = utils.getSObjectName(soList[0]);
	}
	private static Set<String> currentSources(String s) {
		if(s != null) {
			currentSources.removeAll(currentSources);
			currentSources.add(s);
		} else if(targetObjectName == 'Investigation__c') {
			currentSources.removeAll(currentSources);
			currentSources.add('Petition__c');
			currentSources.add('Investigation__c');
		}
		return currentSources;
	}

	@isTest static void initializeInvestigation() {
		Test.startTest();
		targetObjectName(iList);
		SyncUtility.initialize(iList);//initializes, setting targetObjectName and investigationList in utility
		System.assertEquals(targetObjectName, SyncUtility.targetObjectName);
		System.assertEquals(iList, SyncUtility.investigationList);
		Test.stopTest();
	}
	@isTest static void setInvestigationSourceObjectNames() {
		Test.startTest();
		targetObjectName(iList);
		SyncUtility.initialize(iList);//initializes, setting targetObjectName and investigationList in utility
		SyncUtility.setSourceObjectNames(currentSources('Petition__c'), false);
		System.assertEquals(currentSources, SyncUtility.sourceObjectNames);//both have only Petition__c
		SyncUtility.setSourceObjectNames(currentSources, false);
		currentSources.removeAll(currentSources);//reset to size of 0
		System.assertNotEquals(currentSources, SyncUtility.sourceObjectNames);//currentSources size is 0, but that call all sources in utility
		SyncUtility.setSourceObjectNames(currentSources, true);
		System.assertNotEquals(currentSources, SyncUtility.sourceObjectNames);//currentSources still has Petition__c, but the boolean "true" set sourceObjectNames to all sources
		SyncUtility.setSourceObjectNames(currentSources(null), false);
		System.assertEquals(currentSources, SyncUtility.sourceObjectNames);//both have both Petition__c and Investigation__c by passing
		Test.stopTest();
	}
	@isTest static void setInvestigationSyncFieldMap() {
		Test.startTest();
		targetObjectName(iList);
		SyncUtility.initialize(iList);//initializes, setting targetObjectName and investigationList in utility
		SyncUtility.setSourceObjectNames(currentSources, true);//sets sourceObjectNames to all in utility
		SyncUtility.setSyncFieldMap();//grabs CMT for investigation
		System.assertNotEquals(null, SyncUtility.syncFieldMap.get('Petition__c'));//syncFieldMap has Petition values
		currentFieldMappings = SyncUtility.syncFieldMap.get('Petition__c');//map the Petition mappings to current
		System.assertEquals(currentFieldMappings.get('ADCVD_Case_Number_Text__c'), 'ADCVD_Case_Number_Text__c');//confirm a mapping is correct
		currentFieldMappings = SyncUtility.syncFieldMap.get('Investigation__c');//map the Investigation mappings to current
		System.assertEquals(currentFieldMappings.get('Calculated_Final_Signature__c'),'Calculated_Final_Signature__c');//confirm a mapping is correct
		Test.stopTest();
	}
	@isTest static void setInvestigationSourceObjectMap() {
		Test.startTest();
		targetObjectName(iList);
		SyncUtility.initialize(iList);//initializes, setting targetObjectName and investigationList in utility
		SyncUtility.setSourceObjectNames(currentSources(null), true);//sets sourceObjectNames to all in utility
		SyncUtility.setSyncFieldMap();//grabs CMT for investigation
		SyncUtility.setSourceObjectsMap();//map source objects to source map
		System.assertEquals('Foodstuffs', ((Petition__c)SyncUtility.sourceObjectsMap.get(pList[0].Id)).Commodity_Text__c);//confirm source object map queried correctly
		for(Investigation__c i : iList) {
			if(i.RecordTypeId == utils.getRecordTypeIdMap(i).get('AD')){
				System.assertEquals(i.Id, SyncUtility.sourceObjectsMap.get(i.Id).Id);//the AD investigation was queried
			} else {
				System.assertEquals(null, SyncUtility.sourceObjectsMap.get(i.Id));//the CVD investigation was not queried
			}
		}
		Test.stopTest();
	}
	@isTest static void setInvestigationTargetObjectValues() {
		Test.startTest();
		Investigation__c i = TestUtils.createInvestigation(pList[0], false);
		i.AD_Investigation_Aligned_To__c = iAD.Id;
		iList.add(i);
		targetObjectName(iList);
		SyncUtility.initialize(iList);//initializes, setting targetObjectName and investigationList in utility
		SyncUtility.setSourceObjectNames(currentSources(null), true);//sets sourceObjectNames to all in utility
		SyncUtility.setSyncFieldMap();//grabs CMT for investigation
		SyncUtility.setSourceObjectsMap();//map source objects to source map
		SyncUtility.setTargetObjectValues();//set the source value to the target value
		System.assertEquals(i.Calculated_Final_Signature__c, iAD.Calculated_Final_Signature__c);//the CVD investigation is aligned to the AD
		System.assertEquals(i.Commodity_Text__c, pList[0].Commodity_Text__c);//the Petition synced to Investigation
		Test.stopTest();
	}


	@testSetup static void dataSetup() {
		Test.startTest();
		//create custom setting configuration to activate triggers, workflow rules, and validation rules
        Master_Automation__c ma = TestUtils.createMasterAutomation(true, true, true);
        AppConfig__c ac = TestUtils.createAppConfig('default', true, true);
        //create test data
		User testUser = TestUtils.createAdminUser(true, 'myemail@email.com.testita', 1);
		List<ADCVD_Case__c> cList = new List<ADCVD_Case__c>();
		List<Petition__c> petitionsToInsert = new List<Petition__c>();
		ADCVD_Case__c testADCase = TestUtils.createADCVDCase('A-123-123', 'AD ME', false);
		cList.add(testADCase);
		ADCVD_Case__c testCVDCase = TestUtils.createADCVDCase('C-123-123', 'CVD', false);
		cList.add(testCVDCase);
		insert cList;

		Petition__c testADPetition = TestUtils.createPetition(testADCase, petitionDate,false);
		testAdPetition.Commodity_Text__c = 'Foodstuffs';
		petitionsToInsert.add(testAdPetition);
		Petition__c testCvdPetition = TestUtils.createPetition(testCVDCase, petitionDate,false);
		testCvdPetition.Commodity_Text__c = 'Foodstuffs';
		petitionsToInsert.add(testCvdPetition);
		insert petitionsToInsert;

		Investigation__c testADinvestigation = TestUtils.createInvestigation(testAdPetition, true);
		Investigation__c testCVDinvestigation = TestUtils.createInvestigation(testCvdPetition, false);
		testCVDinvestigation.AD_Investigation_Aligned_To__c = testADinvestigation.Id;
		insert testCVDinvestigation;
	}
}