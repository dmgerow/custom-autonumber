trigger LeadTrigger on Lead (before insert) {
    AutoNumberService.assignAutoNumbers(trigger.new);
}