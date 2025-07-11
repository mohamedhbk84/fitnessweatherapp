const { onSchedule } = require("firebase-functions/v2/scheduler");
const { initializeApp } = require("firebase-admin/app");
const { getMessaging } = require("firebase-admin/messaging");
const axios = require("axios");

initializeApp();

exports.sendWeatherNotification = onSchedule(
  {
    schedule: "every 15 minutes",
    timeZone: "Africa/Cairo",
  },
  async (event) => {
    try {
      const res = await axios.get(
        "https://api.weatherapi.com/v1/current.json?key=49984c31075544809ac163024251007&q=Cairo&lang=ar"
      );

      const weather = res.data.current;
      const condition = weather.condition.text;
      const temp = weather.temp_c;

      const message = {
        topic: "weather_updates",
        notification: {
          title: "تحديث الطقس 🌤️",
          body: `الجو الآن: ${condition} - ${temp}°C`,
        },
      };

      await getMessaging().send(message);
      console.log("✅ تم إرسال إشعار الطقس بنجاح.");
    } catch (error) {
      console.error("❌ خطأ أثناء إرسال الإشعار:", error.message);
    }
  }
);
