
from selenium import webdriver
from bs4 import BeautifulSoup
import pandas as pd

user_input = input()
product = user_input.replace(' ', '+')
google_link = 'https://www.google.com/search?q=' + product + '&tbm=shop'

driver = webdriver.Chrome()

driver.get(google_link)

html = driver.page_source
soup = BeautifulSoup(html, "html.parser")

data = []

for product in soup.find_all("div", class_="sh-dgr__gr-auto sh-dgr__grid-result"):
    name = product.find("h3", class_="tAxDx").text
    price = product.find("span", class_="a8Pemb OFFNJ").text
    seller = product.find('div', class_="aULzUe IuHnof")
    link = product.find('a', class_="shntl").get('href')[9:]

    data.append([name, price, seller, link])

df = pd.DataFrame(data, columns = ['Name', 'Price', 'Seller', 'Link'])

print(df)