from flask import Flask, render_template, request
from bs4 import BeautifulSoup
from selenium import webdriver

app = Flask(__name__)

def scrape_google_shopping(product_name):
    google_link = f'https://www.google.com/search?q={product_name.replace(" ", "+")}&tbm=shop'
    options = webdriver.ChromeOptions()
    options.add_argument('headless')
    driver = webdriver.Chrome(options=options)

    driver.get(google_link)

    html = driver.page_source
    soup = BeautifulSoup(html, "html.parser")
    
    data = []
    
    for product in soup.find_all("div", class_="sh-dgr__gr-auto sh-dgr__grid-result"):
        name = product.find("h3", class_="tAxDx").text
        price = product.find("span", class_="a8Pemb OFFNJ").text
        seller = product.find('div', class_="aULzUe IuHnof").text
        link = product.find('a', class_="shntl").get('href')[9:]
        
        data.append({'Name': name, 'Price': price, 'Seller': seller, 'Link': link})
    
    return data

@app.route('/')
def index():
    return render_template('index.html', products=[])

@app.route('/search', methods=['POST'])
def search():
    product_name = request.form['product_name']
    products = scrape_google_shopping(product_name)
    return render_template('index.html', products=products)

if __name__ == '__main__':
    app.run(debug=True)
