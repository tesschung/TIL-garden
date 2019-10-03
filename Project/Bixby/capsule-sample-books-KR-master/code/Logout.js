module.exports.function = function logout ($vivContext) {
  const config = require('config');
  const http = require('http');
  const fail = require('fail');
  const logoutURL = config.get("revokeURL");
  
  let result = false;
  
  if($vivContext.accessToken == null){
    throw fail.checkedError("No LogIn", "NoLogIn"); 
  }
  
  const url = logoutURL + $vivContext.accessToken;
  
  
  const response = http.oauthGetUrl(url, {format:"json", cacheTime: 0, returnHeaders:true});
  
  if(response.status == 400){
    throw fail.checkedError("Logout Failed", "LogoutFailed"); 
  }else{
    result = true;
  }
  
  return result;
}
