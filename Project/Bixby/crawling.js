const request = require('request');
const cheerio = require('cheerio');

request('http://tistory.com', function (error, response, body) {
    if(error) throw error

    $ = cheerio.load(body); // request모듈을 이용해서 가져온정보를 넣어줌

    let json = [], title, writer
    $('#mArticle > div.tistory_recomm > div.recomm_blog').each(function(index, ele){ // <div class="recomm_blog">를 반복
        title = $(this).find('a > .tit_subject').text() // a태그 아래에 class="tit_subject"의 텍스트(제목)
        writer = $(this).find('a > .txt_writer').text() // a태그 아래에 class="txt_writer"의 텍스트(작성자)
        json.push({ title: title, writer: writer })
    });

    console.log('json: ', json);
});
