# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class DavidfunProject3Item(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()
    #카테고리를 추출할 것이라고 예약해놓은것!
    category = scrapy.Field()

    pass
