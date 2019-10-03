module.exports.function = function getBookDetailByURL (detailURL) {
  const http = require('http');
  const fail = require('fail');
  
  // Oauth를 설정했을 경우, oauthXXXURL을 사용 (https://bixbydevelopers.com/dev/docs/reference/JavaScriptAPI/http#http-oauthgeturl-url-options-code-string-code-)
  response = http.oauthGetUrl(detailURL, {format:"json", cacheTime: 0, returnHeaders:true});

  if(response.status == 404 || response.status == 500 || response.status == 502 || response.status == 504){ 
    throw fail.checkedError("Server Error", "ServerProblem"); 
  }
  
  const bookInfo = response.parsed;
  const tempData = trimBookInfo(bookInfo);
  
  return {
    kind: bookInfo.kind,
    id: bookInfo.id,
    volume:{
      title: bookInfo.volumeInfo.title,
      description: tempData.description,    
      authors: bookInfo.volumeInfo.authors,          
      imageLinks: tempData.url,
      publisher: bookInfo.volumeInfo.publisher,
      publishedDate: bookInfo.volumeInfo.publishedDate,
      pageCount: bookInfo.volumeInfo.pageCount,
      averageRating: tempData.averageRating,
      ratingsCount: tempData.ratingsCount,
      printType: bookInfo.volumeInfo.printType,
      categories: bookInfo.volumeInfo.categories
    },
    sales:{
      country: bookInfo.saleInfo.country,
      saleability: tempData.saleability,
      isEbook: bookInfo.saleInfo.isEbook,
      buyLink: bookInfo.saleInfo.buyLink,
      listPrice: {
       amount: tempData.listPrice.amount,
       currencyCode: tempData.listPrice.currencyCode
      },
      retailPrice: {
       amount: tempData.retailPrice.amount,
       currencyCode: tempData.retailPrice.currencyCode
      }
    } 
  };
}

function trimBookInfo(bookInfo){  
  var url = "";
  var averageRating = 0;
  var ratingsCount = 0;
  var saleability = false;
  var listPrice = null;
  var retailPrice = null;
  var description = null;
  
  // console.log(bookInfo);
   
  if(bookInfo.volumeInfo.imageLinks == undefined){
    url = "/icon/bixby.png";
  }else{
    url = bookInfo.volumeInfo.imageLinks.thumbnail;
  }
  
  if(bookInfo.volumeInfo.averageRating != undefined){
    averageRating = bookInfo.volumeInfo.averageRating;
    ratingsCount = bookInfo.volumeInfo.ratingsCount;
  }
  
  if(bookInfo.saleInfo.saleability != "NOT_FOR_SALE"){
    saleability = true;
  }
  
  if(bookInfo.volumeInfo.description != undefined){
    description = bookInfo.volumeInfo.description.replace(/(<([^>]+)>)/ig,"");
  }

  if(bookInfo.saleInfo.listPrice == undefined){
    listPrice = {
      amount: 0,
      currencyCode: null
    };
    
    retailPrice = {
      amount: 0,
      currencyCode: null
    };  
  }else{
    listPrice = {
      amount: bookInfo.saleInfo.listPrice.amount,
      currencyCode: bookInfo.saleInfo.listPrice.currencyCode
    };
    
    retailPrice = {
      amount: bookInfo.saleInfo.retailPrice.amount,
      currencyCode: bookInfo.saleInfo.retailPrice.currencyCode
    };
  }

  return {
    url: url,
    averageRating: averageRating,
    ratingsCount: ratingsCount,
    saleability: saleability,
    retailPrice: retailPrice,
    listPrice: listPrice,
    description: description
  };
}
