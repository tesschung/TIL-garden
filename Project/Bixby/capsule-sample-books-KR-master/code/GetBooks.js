module.exports.function = function getBooks (keyword) {
  const config = require('config');
  const http = require('http');
  const fail = require('fail');
  const baseAPIURL = config.get("baseAPIURL");
  const searchURL = config.get("searchURL");
  const maxResults = config.get("maxResults");
 
  keyword = encodeURIComponent(keyword.trim());
  const url = baseAPIURL + keyword + "&maxResults=" + maxResults;
  
  // OAuth를 설정했을 경우, oauthXXXUrl 함수를 사용 (https://bixbydevelopers.com/dev/docs/reference/JavaScriptAPI/http#http-oauthgeturl-url-options-code-string-code-)
  const response = http.oauthGetUrl(url, {format:"json", cacheTime: 0, returnHeaders:true});

  if(response.status == 404 || response.status == 500 || response.status == 502 || response.status == 504){
    throw fail.checkedError("Server Error", "ServerProblem"); 
  }
  
  const booksInfo = response.parsed;
  
  return {
    kind: booksInfo.kind,
    totalItems: booksInfo.totalItems,
    query: searchURL + keyword,
    book: setBookResults(booksInfo.items)
  };
}

function setBookResults(booksInfo){
  let result = [];

  for(var i = 0; i < booksInfo.length; i++){
    let url = null;
    let description = null;
    
    if(booksInfo[i].volumeInfo.imageLinks == undefined){
      url = "/icon/bixby.png";
    }else{
      url = booksInfo[i].volumeInfo.imageLinks.thumbnail;
    }
    
    if(booksInfo[i].volumeInfo.description != undefined){
      description = booksInfo[i].volumeInfo.description.replace(/(<([^>]+)>)/ig,"");
    }
    
    result.push(
      {
        kind: booksInfo[i].kind,
        id: booksInfo[i].id,
        detailLink: booksInfo[i].selfLink,
        volume:{
          title: booksInfo[i].volumeInfo.title,
          authors: booksInfo[i].volumeInfo.authors,
          description: description,
          imageLinks: url
        }
      }
    );
  }
  
  return result;
}