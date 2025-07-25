# Define here the models for your scraped items
#
# See documentation in:
# https://docs.scrapy.org/en/latest/topics/items.html

import scrapy


class DavidfunProject5Item(scrapy.Item):
    # define the fields for your item here like:
    # name = scrapy.Field()

    # 1, 타이틀을 스크래피에서 가져올거야
    title = scrapy.Field()
    pass
