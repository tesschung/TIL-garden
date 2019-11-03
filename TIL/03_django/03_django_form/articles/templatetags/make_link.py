from django import template

register = template.Library()  # 기존 템플릿 라이브러리에


@register.filter
def hashtag_link(word):
    # word 는 article 객체가 들어갈건데
    # article 의 content 들만 모두 가져와서 그 중 해시태그에만 링크를 붙인다.
    content = word.content + ' '
    hashtags = word.hashtags.all()

    for hashtag in hashtags:
        content = content.replace(
            hashtag.content + ' ',
            f'<a href="/articles/{hashtag.pk}/hashtag/">{hashtag.content}</a> ',
        )  # 마지막 공백 주의!!

    return content
