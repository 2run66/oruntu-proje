# run_with_tunnel.py

from pyngrok import ngrok, conf
import logging
import sys
import time
from app import app  # az önce oluşturduğumuz Flask uygulamamız

NGROK_AUTH_TOKEN = "2gT6LyFhRfj77VEdEqCKhqQbrar_WrViCE5PHdMrb9JsM7ew"
conf.get_default().auth_token = NGROK_AUTH_TOKEN
# ngrok’un sessiyon loglarını bastırmamak için logging seviyesini uyarı üstüne çekelim
logging.getLogger("pyngrok").setLevel(logging.WARNING)

def main():
    # 1) Eğer bir ngrok auth token’ınız varsa buraya ekleyin
    #    Oturum süresini vs. yükseltir, isteğe bağlı
    # conf.get_default().auth_token = "YOUR_NGROK_AUTHTOKEN"

    # 2) Flask uygulamasının çalışacağı port
    port = 5230

    # 3) Lokal Flask portunu internete açan ngrok tünelini başlat
    #    http protokolü ile, aynı porta yönlendirme
    public_url = ngrok.connect(port, "http")
    print(f" * ngrok tunnel \"{public_url}\" -> \"http://127.0.0.1:{port}\"")

    # 4) Flask uygulamasını başlat
    #    debug=False, use_reloader=False:
    #    -> Tek bir process’te çalışmasını sağlamak için
    app.run(host="0.0.0.0", port=port, debug=False, use_reloader=False)

    # 5) Flask kapandığında ngrok’u da durdur
    ngrok.disconnect(public_url)
    ngrok.kill()

if __name__ == "__main__":
    main()
