import telebot
import requests

API_KEY = "2073003133:AAHOvKKdC5askDO4ahuT9UmTlktFsTcmtBw"
bot = telebot.TeleBot(token = API_KEY)
# bot.infinity_polling(timeout=20, interval=2)
url = f"https://api.telegram.org/bot{API_KEY}/getUpdates"
CHAT_ID = 584775448

def get_update():
    updates = requests.get(url).json()
    text = updates["result"][-1]["message"]["text"]
    message_id = updates["result"][-1]["message"]["message_id"]
    return text, message_id


def send(chat_id,text):
    """
    Sends specific message to user
    :rtype: None
    """
    bot.send_message(chat_id = chat_id, text = text)