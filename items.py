from typing import Optional

class item:
    def __init__(self, p:str, n:str, r:str, img: Optional[str]):
        self.price = p
        self.name = n
        self.rating = r
        self.img = img