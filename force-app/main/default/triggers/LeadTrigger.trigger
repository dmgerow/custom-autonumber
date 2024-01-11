trigger LeadTrigger on Lead(before insert) {
    AutoNumberService.assignAutoNumbers(Trigger.new);
}
