public without sharing class UiUtils {
	public static Boolean isSalesforce1() {
		Boolean isSalesforce1;
        if(UserInfo.getUiThemeDisplayed() == 'Theme4t') {
            isSalesforce1 = true;
        } else {
            isSalesforce1 = false;
        }
        return isSalesforce1;
    }

    public static Boolean isLightningExperience() {
    	Boolean isLightningExperience;
        if(UserInfo.getUiThemeDisplayed() == 'Theme4d') {
            isLightningExperience = true;
        } else {
            isLightningExperience = false;
        }
        return isLightningExperience;
    }
    
    public static Boolean isSalesforceClassic() {
    	Boolean isSalesforceClassic;
        if(UserInfo.getUiThemeDisplayed() == 'Theme3') {
            isSalesforceClassic = true;
        } else {
            isSalesforceClassic = false;
        }
        return isSalesforceClassic;
    }
    /**
     * Method accepts a fieldset in the returned order from the Schema call. It will manipulate the set order to match
     * how lightning displays in columns rather than zig-zag like page blocks.
     * @param  apexRepeatOrderedList List<Schema.FieldSetMember>
     * @return                       List<Schema.FieldSetMember>
     */
    public static List<Schema.FieldSetMember> sortFieldSetListForHTML(List<Schema.FieldSetMember> apexRepeatOrderedList) {
    	List<Schema.FieldSetMember> htmlOrderedList = new List<Schema.FieldSetMember>();
    	List<Schema.FieldSetMember> tempList1 = new List<Schema.FieldSetMember>();
    	List<Schema.FieldSetMember> tempList2 = new List<Schema.FieldSetMember>();
    	Boolean oddNumber = false;
    	Boolean switchList = true;
    	Schema.FieldSetMember oddObject;
    	Integer totalCount = apexRepeatOrderedList.size();
    	Decimal halfCount = Decimal.valueOf(Math.floor(totalCount / 2));
    	Integer compareTotal = (Integer)halfCount * 2;
    	if(compareTotal != totalCount){
    		oddObject = apexRepeatOrderedList.get(totalCount-1);
    		apexRepeatOrderedList.remove(totalCount-1);
    		oddNumber = true;
    	}
    	for(Schema.FieldSetMember o : apexRepeatOrderedList) {
    		if(switchList) {
    			tempList1.add(o);
    			switchList = false;
    		} else {
    			tempList2.add(o);
    			switchList = true;
    		}
    	}
    	if(oddNumber) {
    		tempList1.add(oddObject);
    	}
    	htmlOrderedList.addAll(tempList1);
    	htmlOrderedList.addAll(tempList2);
    	return htmlOrderedList;
    }

    public static List<sObject> sortSObjectListForHTML(List<sObject> apexRepeatOrderedList) {
    	List<sObject> htmlOrderedList = new List<sObject>();
    	List<sObject> tempList1 = new List<sObject>();
    	List<sObject> tempList2 = new List<sObject>();
    	Boolean oddNumber = false;
    	Boolean switchList = true;
    	sObject oddObject;
    	Integer totalCount = apexRepeatOrderedList.size();
    	Decimal halfCount = Decimal.valueOf(Math.floor(totalCount / 2));
    	Integer compareTotal = (Integer)halfCount * 2;
    	if(compareTotal != totalCount){
    		oddObject = apexRepeatOrderedList.get(totalCount-1);
    		apexRepeatOrderedList.remove(totalCount-1);
    		oddNumber = true;
    	}
    	for(sObject o : apexRepeatOrderedList) {
    		if(switchList) {
    			tempList1.add(o);
    			switchList = false;
    		} else {
    			tempList2.add(o);
    			switchList = true;
    		}
    	}
    	if(oddNumber) {
    		tempList1.add(oddObject);
    	}
    	htmlOrderedList.addAll(tempList1);
    	htmlOrderedList.addAll(tempList2);
    	return htmlOrderedList;
    }

    public static List<Object> sortFieldListForHTML(List<Object> apexRepeatOrderedList) {
    	List<Object> htmlOrderedList = new List<Object>();
    	List<Object> tempList1 = new List<Object>();
    	List<Object> tempList2 = new List<Object>();
    	Boolean oddNumber = false;
    	Boolean switchList = true;
    	Object oddObject;
    	Integer totalCount = apexRepeatOrderedList.size();
    	Decimal halfCount = Decimal.valueOf(Math.floor(totalCount / 2));
    	Integer compareTotal = (Integer)halfCount * 2;
    	if(compareTotal != totalCount){
    		oddObject = apexRepeatOrderedList.get(totalCount-1);
    		apexRepeatOrderedList.remove(totalCount-1);
    		oddNumber = true;
    	}
    	for(Object o : apexRepeatOrderedList) {
    		if(switchList) {
    			tempList1.add(o);
    			switchList = false;
    		} else {
    			tempList2.add(o);
    			switchList = true;
    		}
    	}
    	if(oddNumber) {
    		tempList1.add(oddObject);
    	}
    	htmlOrderedList.addAll(tempList1);
    	htmlOrderedList.addAll(tempList2);
    	return htmlOrderedList;
    }
}