/*
	Author: Jeff Weyhrauch
	Date: 3-12-19
	Name: IPaymentsSelector.cls
	Purpose:
		The interface that defines the methods to be implemented by whatever selector we define. These stubs clarify
		generic needs across our application. More than one class can use this selector to grab Payments by their ID.
		Only a single query need be defined in the implementation and only need be changed if fields are added,
		subtracted, or changed.
 */
public interface IPaymentsSelector extends fflib_ISObjectSelector{

	List<Payment__c> selectById(Set<Id> idSet);

}