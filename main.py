import time
import telegram_bot
import threading
from firebase_rtdb import rtdb

_, old_message_id = telegram_bot.get_update()
last_alert_key = ""


# # todo: [additional] when people query, give last sighting
# def sighting_query():
#     global old_message_id
#     while True:
#         text, message_id= telegram_bot.get_update()
#         if text.lower() == "last sighting" and message_id != old_message_id:
#             latest_alert_key = list(rtdb.child("Data").get().val())[-1]
#             latest_alert = dict(rtdb.child("Data").child(latest_alert_key).get().val())
#             latest_time = latest_alert["time"]
#             latest_location = latest_alert["location"]
#             telegram_bot.send(chat_id = telegram_bot.CHAT_ID, text = f"Last seen at {latest_location} at {latest_time}")
#             old_message_id = message_id
#         time.sleep(.5)


# todo: when there is monkey, send message
def new_sighting():
    global last_alert_key
    while True:
        current_alert_key = list(rtdb.child("Data").get().val())[-1]
        if current_alert_key != last_alert_key:
            current_alert = dict(rtdb.child("Data").child(current_alert_key).get().val())
            current_time = current_alert["time"]
            current_location = current_alert["location"]
            telegram_bot.send(chat_id = telegram_bot.CHAT_ID, text = f"Sighting at {current_location} @ {current_time}")
            last_alert_key = current_alert_key
        time.sleep(.5)


if __name__ == "__main__":
    # query_thread = threading.Thread(target = sighting_query)
    sighting_thread = threading.Thread(target = new_sighting)
    # query_thread.start()
    sighting_thread.start()
    # query_thread.join()
    sighting_thread.join()