public with sharing class NewsAppController {
    @AuraEnabled
    public static Map<String,Object> retriveNews(){
        
        NewsApiDetails__mdt newsApiDetail = [SELECT Id,Endpoit__c,API_Key__c FROM NewsApiDetails__mdt WHERE DeveloperName='News_App_Integration' limit 1];
        HttpRequest httpRequest = new HttpRequest();
        HttpResponse httpResp = new HttpResponse();
        string endpoint = newsApiDetail.Endpoit__c+newsApiDetail.API_Key__c;
        httpRequest.setEndpoint(endpoint);
        httpRequest.setMethod('GET');
        Map<String,Object> newsJsonData = new Map<String,Object>();
        Http ht = new Http();
       String strResponse='';
        
        try{
             httpResp = ht.send(httpRequest);
            if(httpResp.getStatusCode()==200){
                strResponse = httpResp.getBody();
            }else{
                throw new CalloutException(httpResp.getBody());
            }
            
        }catch(Exception ex){
            throw ex;
        }
        if(!String.isBlank(strResponse)){
            newsJsonData = (Map<String,Object>)JSON.deserializeUntyped(strResponse);
        }
        if(!newsJsonData.isEmpty()){
            return newsJsonData;
            }else{
                    return null;
                }

    }
}