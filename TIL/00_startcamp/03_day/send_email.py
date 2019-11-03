import smtplib
from email.message import EmailMessage
import getpass
password = getpass.getpass('PASSWORD : ')

to_email_list = ['edujunho.hphk@gmail.com', 'wnsgh1083@nate.com', 'wnsgh1083@hanmail.net']

for email in to_email_list:
    msg = EmailMessage()
    msg['Subject'] = '권고사직서'
    msg['From'] = 'wnsgh6315@naver.com'
    msg['To'] = email
    msg.set_content('죄송합니다..')

    ssafy = smtplib.SMTP_SSL('smtp.naver.com', 465)
    ssafy.login('wnsgh6315', password)
    ssafy.send_message(msg)

print('이메일 전송 완료!')