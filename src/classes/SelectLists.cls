public with sharing class SelectLists {

	public SelectLists() {}
	public SelectLists(ApexPages.standardController controller) {}
	
	public static List<SelectOption> sortByLabel(List<SelectOption> options) {
		
		// create a map, using labels as keys
		// also fill a list of strings.
		Map<String, SelectOption> optionsMap = new Map<String, SelectOption>();
		List<String> strings = new List<String>();
		for(SelectOption o : options) {
			optionsMap.put(o.getLabel(), o);
			strings.add(o.getLabel());
		}
		
		// sort the list
		strings.sort();
		
		// clear options to refill
		options.clear();
		
		// refill based on sorted list with map keys
		for(Integer x = 0; x < strings.size(); x++) options.add(optionsMap.get(strings[x]));
		
		return options;
		
	}
	
	public static List<SelectOption> sortByValue(List<SelectOption> options) {
		
		// create a map, using labels as keys
		// also fill a list of strings.
		Map<String, SelectOption> optionsMap = new Map<String, SelectOption>();
		List<String> strings = new List<String>();
		for(SelectOption o : options) {
			optionsMap.put(o.getValue(), o);
			strings.add(o.getValue());
		}
		
		// sort the list
		strings.sort();
		
		// clear options to refill
		options.clear();
		
		// refill based on sorted list with map keys
		for(Integer x = 0; x < strings.size(); x++) options.add(optionsMap.get(strings[x]));
		
		return options;
		
	}
	
	public static List<SelectOption> allObjectTypes {
		get {
			return createOptions(Schema.getGlobalDescribe().values());
		}
		set;
	}
	
	public static List<SelectOption> objectFields(String objectName) {
		List<Schema.SobjectField> fields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().values();
		return createOptions(fields);
	}
	
	// pass List of sObjects and object fields to use for value and label
	public static List<SelectOption> createOptions(List<Schema.PicklistEntry> picklistEntries) {
		List<SelectOption> options = new List<SelectOption>();
		for(Schema.PicklistEntry s : picklistEntries) {
			options.add(new SelectOption(s.getValue(), s.getLabel()));
		}
		return options;
	}
	
	// pass List of sObjects and object fields to use for value and label
	public static List<SelectOption> createOptions(List<Schema.SObjectType> sObjectTypes) {
		List<SelectOption> options = new List<SelectOption>();
		for(Schema.SObjectType s : sObjectTypes) {
			options.add(new SelectOption(s.getDescribe().getName(), s.getDescribe().getLabel()));
		}
		return options;
	}
	
	// pass List of sObjects and object fields to use for value and label
	public static List<SelectOption> createOptions(List<Schema.SObjectField> sObjectFields) {
		
		List<SelectOption> options = new List<SelectOption>();
        for(Schema.SobjectField f : sObjectFields) {
            options.add(
                new SelectOption(
                    f.getDescribe().getName(),
                    f.getDescribe().getLabel()
                )
            );
        }
		
		return options;
	}
	
	// pass List of sObjects and object fields to use for value and label
	public static List<SelectOption> createOptions(List<sObject> sObjects, String valueField, String labelField) {
		List<SelectOption> options = new List<SelectOption>();
		for(sObject s : sObjects) {
			options.add(new SelectOption(String.valueOf(s.get(valueField)), String.valueOf(s.get(labelField))));
		}
		return options;
	}
	
	// pass List of sObjects
	// default implementation is to use 'Id' for value and 'Name' for label
	public static List<SelectOption> createOptions(List<sObject> sObjects) {
		return createOptions(sObjects, 'Id', 'Name');
	}
	
	// pass delimited string and its delimiter
	public static List<SelectOption> createOptions(String delimitedString, String delimiter) {
		List<SelectOption> options = new List<SelectOption>();
		for(String s : delimitedString.split(delimiter)) {
			options.add(new SelectOption(s, s));
		}
		return options;
	}
	
	// comma-specific implementation
	public static List<SelectOption> createOptions(String commaDelimitedString) {
		return createOptions(commaDelimitedString, ',');
	}
	
	static testMethod void createOptionsTest() {
        
        List<SelectOption> options;
        String delimitedString;
        
        // allObjectTypes
        // createOptions(List<Schema.SObjectType> sObjectTypes)
        options = SelectLists.allObjectTypes;
        System.assert(options.size() > 0);
        
        // objectFields(String objectName)
        // createOptions(List<Schema.SObjectField> sObjectFields)
        options = SelectLists.objectFields('Account');
        System.assert(options.size() > 0);
        
        // createOptions(List<Schema.PicklistEntry> picklistEntries)
        // TODO: find something that is ALWAYS a picklist in SF
        
        // createOptions(List<sObject> sObjects)
        // createOptions(List<sObject> sObjects, String valueField, String labelField)
        Account a1 = new Account(Name = 'Account 1');
        Account a2 = new Account(Name = 'Account 2');
       	Account[] accounts = new Account[] {a1, a2}; 
       	upsert accounts;
	    options = SelectLists.createOptions(accounts);
	    System.assert(options.size() > 0);
        
        // sortByLabel(List<SelectOption> options)
        options = SelectLists.sortByLabel(options);
        
        // sortByValue(List<SelectOption> options)
        options = SelectLists.sortByValue(options);
        
        // createOptions(String commaDelimitedString)
        // createOptions(String delimitedString, String delimiter)
        delimitedString = 'a,b,c';
        options = SelectLists.createOptions(delimitedString);
        System.assert(options.size() == 3);
        
        
    }

}