 Folder Structure
portfolio_flask/
│
├── app.py
├── requirements.txt
│
├── static/
│   ├── css/
│   │   └── style.css
│   └── img/
│       └── profile.jpg
│
└── templates/
    ├── index.html
    ├── projects.html
    └── contact.html

 1. app.py (Main Flask App)
from flask import Flask, render_template, request, redirect, url_for, flash

app = Flask(__name__)
app.secret_key = "portfolio_secret"  # Required for flash messages

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/projects')
def projects():
    return render_template('projects.html')

@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        message = request.form['message']

        # Here we just print data to console — simulate sending email
        print(f"📩 New message from {name} ({email}): {message}")

        flash('Thank you! Your message has been received.')
        return redirect(url_for('contact'))

    return render_template('contact.html')

if __name__ == '__main__':
    app.run(debug=True)

🧾 2. requirements.txt
flask

3. HTML Templates
index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Portfolio</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/style.css') }}">
</head>
<body>

<header>
    <h1>Welcome to My Portfolio</h1>
    <nav>
        <a href="/">Home</a>
        <a href="/projects">Projects</a>
        <a href="/contact">Contact</a>
    </nav>
</header>

<section class="intro">
    <img src="{{ url_for('static', filename='img/profile.jpg') }}" alt="Profile Photo">
    <h2>Hi, I'm <span class="highlight">Sanjay</span></h2>
    <p>I’m a passionate software developer skilled in Python, Flask, and Web Development.</p>
</section>

<footer>
    <p>© 2025 Sanjay | Built with Flask</p>
</footer>

</body>
</html>

projects.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Projects</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/style.css') }}">
</head>
<body>

<header>
    <h1>My Projects</h1>
    <nav>
        <a href="/">Home</a>
        <a href="/projects">Projects</a>
        <a href="/contact">Contact</a>
    </nav>
</header>

<section>
    <div class="project">
        <h2>To-Do List App</h2>
        <p>A simple Python-based console app to manage tasks efficiently.</p>
    </div>
    <div class="project">
        <h2>Data Analysis Dashboard</h2>
        <p>Performed sales data analysis using Pandas and visualized results with Matplotlib.</p>
    </div>
    <div class="project">
        <h2>Flask Portfolio Website</h2>
        <p>This project demonstrates web development with Flask, HTML, and CSS.</p>
    </div>
</section>

<footer>
    <p>© 2025 Sanjay | Built with Flask</p>
</footer>

</body>
</html>

contact.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Me</title>
    <link rel="stylesheet" href="{{ url_for('static', filename='css/style.css') }}">
</head>
<body>

<header>
    <h1>Contact Me</h1>
    <nav>
        <a href="/">Home</a>
        <a href="/projects">Projects</a>
        <a href="/contact">Contact</a>
    </nav>
</header>

<section class="contact-section">
    {% with messages = get_flashed_messages() %}
      {% if messages %}
        <div class="flash">
          {% for message in messages %}
            <p>{{ message }}</p>
          {% endfor %}
        </div>
      {% endif %}
    {% endwith %}

    <form method="POST" action="/contact">
        <label for="name">Your Name:</label>
        <input type="text" id="name" name="name" required>

        <label for="email">Your Email:</label>
        <input type="email" id="email" name="email" required>

        <label for="message">Message:</label>
        <textarea id="message" name="message" required></textarea>

        <button type="submit">Send Message</button>
    </form>
</section>

<footer>
    <p>© 2025 Sanjay | Built with Flask</p>
</footer>

</body>
</html>

4. style.css
body {
    font-family: 'Poppins', sans-serif;
    margin: 0;
    background: #f9f9f9;
    color: #333;
}

header {
    background: #222;
    color: white;
    text-align: center;
    padding: 1em 0;
}

nav a {
    color: white;
    margin: 0 15px;
    text-decoration: none;
}

nav a:hover {
    color: #00adb5;
}

.intro {
    text-align: center;
    padding: 2em;
}

.intro img {
    width: 150px;
    border-radius: 50%;
}

.highlight {
    color: #00adb5;
}

.project {
    background: white;
    margin: 1em auto;
    padding: 1em;
    border-radius: 10px;
    width: 60%;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
}

.contact-section {
    width: 60%;
    margin: 2em auto;
    background: white;
    padding: 2em;
    border-radius: 10px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

label {
    display: block;
    margin: 10px 0 5px;
}

input, textarea {
    width: 100%;
    padding: 8px;
    border-radius: 5px;
    border: 1px solid #ccc;
}

button {
    background: #00adb5;
    color: white;
    padding: 10px 15px;
    border: none;
    margin-top: 10px;
    border-radius: 5px;
    cursor: pointer;
}

button:hover {
    background: #007b83;
}

.flash {
    background: #d4edda;
    color: #155724;
    padding: 10px;
    border-radius: 5px;
    margin-bottom: 15px;
    text-align: center;
}

footer {
    background: #222;
    color: white;
    text-align: center;
    padding: 1em 0;
    margin-top: 3em;
}

How to Run the Project

Open your terminal and navigate to the project folder:

cd portfolio_flask


Install Flask:

pip install flask


Run the app:

python app.py


Open your browser and visit:


