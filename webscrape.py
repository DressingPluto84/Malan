import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
import items
import json
import re
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as exp

def extract_price(s: str) -> str:
    n = s.strip().replace("\n", ".")
    return n

def extract_title_amazon(s: str) -> str:
    n = s.strip().replace("\n", " ")
    return n

def make_proper_FL(s: str) -> str:
    s = s.strip().replace(" ", "%20")
    n = f"https://www.footlocker.ca/en/search?query={s}"
    return n

def make_proper(s: str) -> str:
    s = s.strip().replace(" ", "+")
    n = f"https://www.amazon.ca/s?k={s}&crid=2JFC9O5IA5GIY&sprefix={s}%2Caps%2C110&ref=nb_sb_noss_1"
    return n

def extractPriceFL(s: str):
    pattern = "to \$[0-9]+\.[0-9]{2}"
    matches = re.search(pattern, s)
    return matches.group(0)[3:]

def extractRatingFL(s: str):
    pattern = "\[.+\]"
    matches = re.search(pattern, s)
    n = matches.group(0).replace("[", "").replace("]", "")
    return n

def getProductsAmazon(productInput: str, numResults: int):
    properInput = make_proper(productInput)

    options = Options()
    options.add_argument("--headless")
    driver = webdriver.Chrome(options=options)
    driver.get(properInput)
    prodArray = []
    prodObjArray = []

    for i in range(numResults):
        try:
            item_price = extract_price(driver.find_element(By.XPATH, f"//div[@data-index='{i}']//div[@class='sg-col-inner']//div[@data-cy='price-recipe']//span[@class='a-price']").text)
            item_title = extract_title_amazon(driver.find_element(By.XPATH, f"//div[@data-index='{i}']//div[@class='sg-col-inner']//div[@data-cy='title-recipe']").text)
            item_rating = driver.find_element(By.XPATH, f"//div[@data-index='{i}']//div[@class='sg-col-inner']//div[@data-cy='reviews-block']//span[@class='a-icon-alt']").get_attribute("textContent")
            item_image = driver.find_element(By.XPATH, f"//div[@data-index='{i}']//div[@class='sg-col-inner']//img[@class='s-image']").get_attribute("src")

            CI = items.item(item_price, item_title, item_rating, item_image)

            jFile = {"item_price": CI.price, "item_title": CI.name, "item_rating": CI.rating, "item_image": CI.img}
            prodArray.append(jFile)
            prodObjArray.append(CI)
        except:
            continue

    return (prodArray, prodObjArray)

def getProductsFL(productInput: str):
    properInput = make_proper_FL(productInput)
    itemsList = []
    itemsObjArray = []

    options = Options()
    options.add_argument("--headless")
    driver = webdriver.Chrome(options=options)
    driver.get(properInput)

    products = driver.find_elements(By.XPATH, "//div[@id='app']//main[@id='main']//div[@class='SearchResults']//li[@class='product-container col product-container-mobile-v3']")

    for i in products:
        item_title = WebDriverWait(driver, 10).until(exp.visibility_of_element_located((By.XPATH, ".//span[@class='ProductName-primary']"))).text
        item_price = WebDriverWait(driver, 10).until(exp.visibility_of_element_located((By.XPATH, ".//div[@class='ProductPrice']"))).text
        item_rating = WebDriverWait(driver, 10).until(exp.visibility_of_element_located((By.XPATH, ".//span[@class='ProductRating-SVG']"))).text
        item_image = WebDriverWait(driver, 10).until(exp.visibility_of_element_located((By.XPATH, ".//div[@class='ProductCard-image']//img[@data-id='SimpleImage']"))).get_attribute("src")

        if item_price.__contains__("sale"):
            item_price = extractPriceFL(item_price)
        item_rating = extractRatingFL(item_rating)

        CI = items.item(item_price, item_title, item_rating, item_image)

        jFile = {"item_price": CI.price, "item_title": CI.name, "item_rating": CI.rating, "item_image": CI.img}
        itemsList.append(jFile)
        itemsObjArray.append(CI)

        return (itemsList, itemsObjArray)





