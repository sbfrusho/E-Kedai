class GloablVariableDeclaration{
  bool? selectService;
  bool setSelectService(bool value){
    
    selectService = value;
    
    print("this is $selectService");
    return value;
  }
}