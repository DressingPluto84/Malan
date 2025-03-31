from fastapi import FastAPI

from fastapi.responses import Response
import requests
import webscrape


app = FastAPI()

productsList = []
count = 10

@app.get("/")
def home():
    global productsList, count
    if len(productsList) == 0:
        x = 250
        products = webscrape.getProductsAmazon("clothes", x)
        n = products[0]
        sendToDB(products[1])
        k=count

        productsList.extend(n)
        count = count + 10
        return productsList[:k]
    else:
        k=count
        count+=10
        return productsList[k:k+10]

@app.get("/refetch")
def refetch():
    global count, productsList
    l, r = count, count + 10
    count += 10
    return productsList[l:r]

def sendToDB(l: list):
    print("hello!")
    return
