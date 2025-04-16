from flask import Flask, render_template, request, jsonify, send_file
import subprocess
import re
import os

app = Flask(__name__)

DOWNLOAD_DIR = "/storage/emulated/0/Download"

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/get-formats")
def get_formats():
    url = request.args.get("url")
    try:
        result = subprocess.run(
            ["yt-dlp", "-F", url],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        formats = []
        for line in result.stdout.split('\n'):
            match = re.match(r'(\d+).*?(\d+p).*?mp4', line)
            if match:
                formats.append({"id": match.group(1), "quality": match.group(2)})
        return jsonify(formats)
    except Exception as e:
        return jsonify({"error": str(e)})

@app.route("/download", methods=["POST"])
def download():
    url = request.form.get("url")
    fmt = request.form.get("format")
    quality = request.form.get("quality")

    cmd = ["yt-dlp", "-P", DOWNLOAD_DIR, url]

    if fmt == "mp3":
        cmd = ["yt-dlp", "-x", "--audio-format", "mp3", "-P", DOWNLOAD_DIR, url]
    elif fmt == "mp4" and quality != "best":
        cmd = ["yt-dlp", "-f", quality, "-P", DOWNLOAD_DIR, url]

    subprocess.run(cmd)

    return "<h2 style='color:white; background:black; padding:20px;'>Download Complete! Check your Download folder.</h2>"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)