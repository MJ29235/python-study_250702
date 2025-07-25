# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class DavidfunProject2Item(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    
    #title과 description 값을 사전에 정의 하기! 나중에 출력할 요소!
    title = scrapy.Field()
    description = scrapy.Field()
    
    pass
