from flask import Flask

app = Flask(__name__)


@app.route("/")
def index():
    # ИЗМЕНЕНО ДЛЯ ЛАБ 11:
    return """
    <h1>Cloud Technologies Laboratory</h1>
    <p>My first Docker application with CI/CD</p>
    <p><a href="/about">About</a> | <a href="/contact">Contact</a></p>
    """


@app.route("/about")
def about():
    return """
    <h1>About</h1>
    <p>Flask application running in a Docker container.</p>
    <p><a href="/">Home</a> | <a href="/contact">Contact</a></p>
    """


@app.route("/contact")
def contact():
    return """
    <h1>Contact</h1>
    <p>Student: Alikhan Sagindykov</p>
    <p><a href="/">Home</a> | <a href="/about">About</a></p>
    """


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
